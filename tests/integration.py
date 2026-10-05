"""Real HTTP/PostgreSQL checks. Run against a development instance only.

Set COFFEE_TEST_URL, COFFEE_TEST_ADMIN_USER, COFFEE_TEST_ADMIN_PASSWORD.
Local fixture cleanup uses COFFEE_TEST_PSQL and COFFEE_TEST_PG_SOCKET.
"""
import concurrent.futures
import http.cookiejar
import json
import os
import subprocess
import unittest
import urllib.error
import urllib.request
import uuid

BASE = os.environ.get('COFFEE_TEST_URL', 'http://127.0.0.1:8080/coffee-shop').rstrip('/')

class Client:
    def __init__(self):
        self.opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
        self.csrf = ''
    def request(self, path, method='GET', data=None, csrf=True):
        headers={'Content-Type':'application/json'}
        if csrf and self.csrf: headers['X-CSRF-Token']=self.csrf
        request=urllib.request.Request(BASE+'/api/'+path,method=method,headers=headers,data=json.dumps(data).encode() if data is not None else None)
        try:
            response=self.opener.open(request,timeout=15)
        except urllib.error.HTTPError as error:
            response=error
        with response:
            return response.status,json.loads(response.read())

class Workflow(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.admin=Client();cls.guest=Client();cls.product_ids=[]
        status,result=cls.admin.request('admin/login','POST',{'username':os.environ['COFFEE_TEST_ADMIN_USER'],'password':os.environ['COFFEE_TEST_ADMIN_PASSWORD']})
        if status!=200:raise RuntimeError('Test admin login failed')
        cls.admin.csrf=result['csrf']
        cls.tag='integration-'+uuid.uuid4().hex
    @classmethod
    def tearDownClass(cls):
        if cls.product_ids:
            ids=','.join(str(i) for i in cls.product_ids)
            sql=f"BEGIN; DELETE FROM order_events WHERE order_id IN (SELECT order_id FROM order_items WHERE product_id IN ({ids})); DELETE FROM order_items WHERE product_id IN ({ids}); DELETE FROM orders WHERE customer_name='{cls.tag}'; DELETE FROM products WHERE id IN ({ids}); COMMIT;"
            subprocess.run([os.environ['COFFEE_TEST_PSQL'],'-X','-v','ON_ERROR_STOP=1','-h',os.environ['COFFEE_TEST_PG_SOCKET'],'-d','baitaplon'],input=sql,text=True,stdout=subprocess.DEVNULL,check=True)
    def product(self,stock=8):
        data={'name':self.tag,'category':'coffee','description':'Test fixture','price':30000,'stock':stock,'active':True}
        status,result=self.admin.request('admin/products','POST',data)
        self.assertEqual(status,201,result);pid=result['id'];self.product_ids.append(pid);return pid,data
    def order(self,pid,qty=1,key=None):
        return {'name':self.tag,'phone':'0900000000','address':'Nhận tại quán','note':'Kiểm thử tự động','paymentMethod':'cash','requestKey':key or str(uuid.uuid4()),'items':[{'productId':pid,'quantity':qty}],'total':1}
    def stock(self,pid):
        status,products=self.admin.request('admin/products');self.assertEqual(status,200)
        return next(p['stock'] for p in products if p['id']==pid)
    def patch(self,oid,status,payment='unpaid'):
        return self.admin.request('admin/orders/'+oid,'PATCH',{'status':status,'paymentStatus':payment})
    def test_01_admin_security(self):
        self.assertEqual(self.guest.request('admin/orders')[0],401)
        self.assertEqual(self.guest.request('admin/summary')[0],401)
        status,_=self.admin.request('admin/products','POST',{},csrf=False);self.assertEqual(status,403)
        self.assertEqual(self.guest.request('admin/login','POST',{'username':'admin','password':'incorrect'})[0],401)
        for legacy in ['/Admin/ThemCafe.jsp','/nguoidung/coffee-main/index.jsp']:
            with self.assertRaises(urllib.error.HTTPError) as result:urllib.request.urlopen(BASE+legacy)
            self.assertEqual(result.exception.code,404)
    def test_02_order_idempotency_and_server_price(self):
        pid,_=self.product();body=self.order(pid,2)
        status,first=self.guest.request('orders','POST',body);self.assertEqual(status,201,first);self.assertEqual(first['total'],60000)
        status,again=self.guest.request('orders','POST',body);self.assertEqual(status,201);self.assertEqual(first['id'],again['id']);self.assertEqual(self.stock(pid),6)
        self.assertEqual(self.patch(first['id'],'cancelled')[0],200);self.assertEqual(self.stock(pid),8)
        self.assertEqual(self.patch(first['id'],'cancelled')[0],200);self.assertEqual(self.stock(pid),8)
        self.assertEqual(self.patch(first['id'],'confirmed')[0],409)
    def test_03_paid_workflow_and_revenue(self):
        pid,_=self.product();_,before=self.admin.request('admin/summary')
        _,order=self.guest.request('orders','POST',self.order(pid))
        self.assertEqual(self.patch(order['id'],'completed')[0],409)
        self.assertEqual(self.patch(order['id'],'confirmed')[0],200)
        self.assertEqual(self.patch(order['id'],'preparing')[0],200)
        self.assertEqual(self.patch(order['id'],'completed')[0],409)
        self.assertEqual(self.patch(order['id'],'completed','paid')[0],200)
        _,after=self.admin.request('admin/summary');self.assertEqual(after['revenue']-before['revenue'],30000)
        self.assertEqual(self.patch(order['id'],'cancelled','paid')[0],409)
        self.assertEqual(self.patch(order['id'],'cancelled','refunded')[0],200)
        _,after_refund=self.admin.request('admin/summary');self.assertEqual(after_refund['revenue'],before['revenue'])
        self.assertEqual(self.stock(pid),7,'Delivered items must not be restocked when money is refunded')
    def test_04_validation_atomicity(self):
        pid,_=self.product(stock=2)
        self.assertEqual(self.guest.request('orders','POST',self.order(pid,3))[0],409);self.assertEqual(self.stock(pid),2)
        body=self.order(pid,0);self.assertEqual(self.guest.request('orders','POST',body)[0],400)
        body=self.order(pid);body['items'].append({'productId':9223372036854775807,'quantity':1})
        self.assertEqual(self.guest.request('orders','POST',body)[0],409);self.assertEqual(self.stock(pid),2)
    def test_05_concurrent_stock_and_idempotency(self):
        pid,_=self.product(stock=2)
        bodies=[self.order(pid,2),self.order(pid,2)]
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            results=list(pool.map(lambda body:Client().request('orders','POST',body),bodies))
        self.assertEqual(sorted(s for s,_ in results),[201,409]);self.assertEqual(self.stock(pid),0)
        winner=next(body for status,body in results if status==201)
        self.assertEqual(self.patch(winner['id'],'cancelled')[0],200)
        body=self.order(pid,1)
        with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
            results=list(pool.map(lambda _:Client().request('orders','POST',body),range(2)))
        self.assertEqual([s for s,_ in results],[201,201]);self.assertEqual(results[0][1]['id'],results[1][1]['id']);self.assertEqual(self.stock(pid),1)
    def test_06_inventory_conflicts_and_hidden_product(self):
        pid,data=self.product(stock=3)
        data.update(stock=5,expectedStock=3);self.assertEqual(self.admin.request('admin/products/'+str(pid),'PUT',data)[0],200)
        data.update(stock=20,expectedStock=3);self.assertEqual(self.admin.request('admin/products/'+str(pid),'PUT',data)[0],409);self.assertEqual(self.stock(pid),5)
        data.update(stock=5,expectedStock=5,active=False);self.assertEqual(self.admin.request('admin/products/'+str(pid),'PUT',data)[0],200)
        _,public=self.guest.request('products');self.assertNotIn(pid,[p['id'] for p in public]);self.assertEqual(self.guest.request('orders','POST',self.order(pid))[0],409)
    def test_07_logout_invalidates_session(self):
        client=Client();_,session=client.request('admin/login','POST',{'username':os.environ['COFFEE_TEST_ADMIN_USER'],'password':os.environ['COFFEE_TEST_ADMIN_PASSWORD']});client.csrf=session['csrf']
        self.assertEqual(client.request('admin/logout','POST',{})[0],200);self.assertEqual(client.request('admin/orders')[0],401)

if __name__=='__main__':unittest.main(verbosity=2)
