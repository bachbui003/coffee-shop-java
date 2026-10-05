// Real browser workflow. Uses the same development-only cleanup settings as integration.py.
const {chromium}=require('playwright');
const fs=require('fs'),path=require('path'),{spawnSync}=require('child_process');
const assert=require('assert/strict');
const base=(process.env.COFFEE_TEST_URL||'http://127.0.0.1:8080/coffee-shop').replace(/\/$/,'');
const tag='browser-'+Date.now();
const productIds=[];
const output=process.env.COFFEE_SCREENSHOTS||'/workspace/cloud-setup/screenshots';
fs.mkdirSync(output,{recursive:true});
(async()=>{
  const browser=await chromium.launch({headless:true,executablePath:process.env.COFFEE_CHROMIUM,args:['--no-sandbox','--disable-dev-shm-usage']});
  try{
    const admin=await browser.newPage({viewport:{width:1440,height:1000}});
    const customer=await browser.newPage({viewport:{width:1440,height:1000}});
    const pageErrors=[];for(const page of [admin,customer])page.on('pageerror',e=>pageErrors.push(e.message));
    await admin.goto(base+'/admin');
    await admin.locator('#login-screen').waitFor({state:'visible'});
    await admin.locator('input[name=username]').fill(process.env.COFFEE_TEST_ADMIN_USER);
    await admin.locator('input[name=password]').fill(process.env.COFFEE_TEST_ADMIN_PASSWORD);
    await admin.locator('#login-form button').click();
    await admin.locator('#dashboard').waitFor({state:'visible'});
    await admin.locator('.metric').first().waitFor();
    await admin.locator('[data-tab=inventory]').click();
    await admin.locator('#new-product').click();
    await admin.locator('#product-form input[name=name]').fill(tag);
    await admin.locator('#product-form textarea[name=description]').fill('Món dùng cho kiểm thử giao diện');
    await admin.locator('#product-form input[name=price]').fill('30000');
    await admin.locator('#product-form input[name=stock]').fill('3');
    await admin.locator('#product-form button').click();
    await admin.locator('#product-dialog').waitFor({state:'hidden'});
    const card=admin.locator('.inventory-card').filter({hasText:tag});
    await card.waitFor();
    const pid=Number(await card.locator('[data-product]').getAttribute('data-product'));productIds.push(pid);
    await card.locator('button').click();
    await admin.locator('#product-form input[name=stock]').fill('7');
    await admin.locator('#product-form button').click();
    await admin.locator('#product-dialog').waitFor({state:'hidden'});
    await admin.waitForFunction(name=>Array.from(document.querySelectorAll('.inventory-card')).some(c=>c.textContent.includes(name)&&c.textContent.includes('7')),tag);
    console.log('PASS: admin login, add product, refill stock in browser');
    await customer.goto(base+'/');
    await customer.locator('.product-card').first().waitFor();
    await customer.locator('[data-category=food]').click();
    assert.equal(await customer.locator('.product-card').count(),2);
    await customer.locator('[data-category=all]').click();
    await customer.locator(`[data-add="${pid}"]`).click();
    await customer.locator(`[data-add="${pid}"]`).click();
    assert.equal(await customer.locator('#cart-count').textContent(),'2');
    await customer.locator('#checkout').click();
    await customer.locator('#checkout-form input[name=name]').fill(tag);
    await customer.locator('#checkout-form input[name=phone]').fill('0900000000');
    await customer.locator('#checkout-form input[name=address]').fill('Nhận tại quán');
    await customer.locator('#checkout-form textarea[name=note]').fill('<img src=x onerror="window.mocXss=true">');
    await customer.locator('#submit-order').click();
    await customer.locator('#success-dialog').waitFor({state:'visible'});
    const orderId=await customer.locator('#order-receipt code').textContent();
    assert.match(orderId,/^[0-9a-f-]{36}$/);
    assert.equal(await customer.locator('#cart-count').textContent(),'0');
    await customer.locator('#success-dialog .button').click();
    console.log('PASS: filter menu, cart, submit order, show receipt and clear cart');
    await admin.locator('[data-tab=orders]').click();await admin.locator('#refresh').click();
    const orderCard=admin.locator('.order-card').filter({hasText:tag});await orderCard.waitFor();
    await orderCard.locator('button').click();
    assert.equal(await admin.evaluate(()=>window.mocXss),undefined);
    assert.equal(await admin.locator('#order-detail img').count(),0);
    for(const state of ['confirmed','preparing','completed']){
      await admin.locator('#order-update select[name=status]').selectOption(state);
      if(state==='completed')await admin.locator('#order-update select[name=paymentStatus]').selectOption('paid');
      await admin.locator('#order-update button').click();
      await admin.locator('#order-dialog').waitFor({state:'hidden'});
      await admin.waitForFunction(({name,state})=>Array.from(document.querySelectorAll('.order-card')).some(c=>c.textContent.includes(name)&&c.querySelector('.badge.'+state)),{name:tag,state});
      if(state!=='completed')await admin.locator('.order-card').filter({hasText:tag}).locator('button').click();
    }
    assert.ok((await admin.locator('.metric.primary .metric-value').textContent()).includes('60.000'));
    console.log('PASS: confirm order, prepare, mark paid, complete, verify revenue; note HTML stays text');
    await admin.screenshot({path:path.join(output,'admin-desktop.png'),fullPage:true});
    await customer.screenshot({path:path.join(output,'customer-desktop.png'),fullPage:true});
    await customer.setViewportSize({width:390,height:844});
    await customer.screenshot({path:path.join(output,'customer-mobile.png'),fullPage:true});
    assert.ok(await customer.evaluate(()=>document.documentElement.scrollWidth<=window.innerWidth),'Customer page overflows on mobile');
    await admin.setViewportSize({width:390,height:844});
    await admin.screenshot({path:path.join(output,'admin-mobile.png'),fullPage:true});
    assert.ok(await admin.evaluate(()=>document.documentElement.scrollWidth<=window.innerWidth),'Admin page overflows on mobile');
    await admin.locator('#logout').click();await admin.locator('#login-screen').waitFor({state:'visible'});
    assert.deepEqual(pageErrors,[]);
    console.log('PASS: desktop/mobile layouts, logout, zero JavaScript errors');
  }finally{
    await browser.close();
    if(productIds.length){
      const ids=productIds.join(',');
      const sql=`BEGIN; DELETE FROM order_events WHERE order_id IN (SELECT order_id FROM order_items WHERE product_id IN (${ids})); DELETE FROM order_items WHERE product_id IN (${ids}); DELETE FROM orders WHERE customer_name='${tag}'; DELETE FROM products WHERE id IN (${ids}); COMMIT;`;
      const result=spawnSync(process.env.COFFEE_TEST_PSQL,['-X','-v','ON_ERROR_STOP=1','-h',process.env.COFFEE_TEST_PG_SOCKET,'-d','baitaplon'],{input:sql,encoding:'utf8'});
      if(result.status!==0)throw new Error('Browser fixture cleanup failed');
    }
  }
})().catch(e=>{console.error(e.message);process.exit(1);});
