package vn.coffee;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.*;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(value="/api/*", loadOnStartup=1)
public class ShopApi extends HttpServlet {
    private static final ObjectMapper JSON = new ObjectMapper();
    private final Map<String, List<Long>> failures = new ConcurrentHashMap<>();
    private static final Set<String> STATES = Set.of("pending", "confirmed", "preparing", "completed", "cancelled");
    private static final Set<String> PAYMENTS = Set.of("unpaid", "paid", "refunded");
    public void init() throws ServletException {
        try { Database.required("COFFEE_ADMIN_HASH"); Database.required("COFFEE_ADMIN_USER"); Database.initialize(); }
        catch (Exception e) { throw new ServletException("PostgreSQL initialization failed", e); }
    }
    private static class Problem extends RuntimeException {
        final int code;
        Problem(int code, String message) { super(message); this.code=code; }
    }
    private static void require(boolean condition, int code, String message) { if (!condition) throw new Problem(code,message); }
    private void send(HttpServletResponse r,int code,Object value) throws IOException {
        r.setStatus(code); r.setContentType("application/json; charset=UTF-8"); JSON.writeValue(r.getWriter(),value);
    }
    private JsonNode body(HttpServletRequest r) throws IOException {
        require(r.getContentType()!=null && r.getContentType().toLowerCase(Locale.ROOT).startsWith("application/json"),415,"Gửi dữ liệu ở dạng JSON.");
        byte[] data=r.getInputStream().readNBytes(65537);
        require(data.length<=65536,413,"Dữ liệu quá lớn.");
        try {
            JsonNode value=JSON.readTree(data);
            require(value!=null && value.isObject(),400,"Dữ liệu không hợp lệ.");
            return value;
        } catch (com.fasterxml.jackson.core.JsonProcessingException e) { throw new Problem(400,"Dữ liệu không hợp lệ."); }
    }
    private static String text(JsonNode b,String key,int min,int max) {
        JsonNode node=b.get(key);
        require(node!=null && node.isTextual(),400,"Thiếu hoặc sai trường: "+key);
        String value=node.asText().strip();
        require(value.length()>=min && value.length()<=max,400,"Độ dài không hợp lệ: "+key);
        return value;
    }
    private static long number(JsonNode b,String key,long min,long max) {
        JsonNode n=b.get(key);
        require(n!=null && n.isIntegralNumber() && n.canConvertToLong(),400,"Số không hợp lệ: "+key);
        long v=n.asLong(); require(v>=min && v<=max,400,"Giá trị ngoài giới hạn: "+key); return v;
    }
    private static UUID uuid(String raw) {
        try { return UUID.fromString(raw); } catch (Exception e) { throw new Problem(400,"Mã không hợp lệ."); }
    }
    private HttpSession admin(HttpServletRequest r,boolean mutation) {
        HttpSession session=r.getSession(false);
        require(session!=null && Boolean.TRUE.equals(session.getAttribute("admin")),401,"Vui lòng đăng nhập quản trị.");
        if (mutation) {
            String token=r.getHeader("X-CSRF-Token");
            String expected=(String)session.getAttribute("csrf");
            require(token!=null && MessageDigest.isEqual(token.getBytes(java.nio.charset.StandardCharsets.UTF_8),expected.getBytes(java.nio.charset.StandardCharsets.UTF_8)),403,"Phiên làm việc không hợp lệ. Hãy đăng nhập lại.");
        }
        return session;
    }
    protected void service(HttpServletRequest req,HttpServletResponse res) throws IOException {
        res.setHeader("Cache-Control","no-store");
        try {
            String path=Optional.ofNullable(req.getPathInfo()).orElse("");
            String method=req.getMethod();
            if (method.equals("GET") && path.equals("/health")) {
                try(Connection c=Database.open();Statement s=c.createStatement()){s.execute("SELECT 1");}
                send(res,200,Map.of("status","ok","database","postgresql")); return;
            }
            if (method.equals("GET") && path.equals("/products")) { send(res,200,products(false)); return; }
            if (method.equals("POST") && path.equals("/orders")) { send(res,201,placeOrder(body(req))); return; }
            if (method.equals("POST") && path.equals("/admin/login")) { login(req,res); return; }
            if (path.startsWith("/admin/")) {
                HttpSession session=admin(req,!method.equals("GET"));
                if (path.equals("/admin/session") && method.equals("GET")) {send(res,200,Map.of("username",Database.required("COFFEE_ADMIN_USER"),"csrf",session.getAttribute("csrf")));return;}
                if (path.equals("/admin/logout") && method.equals("POST")) {session.invalidate();send(res,200,Map.of("ok",true));return;}
                if (path.equals("/admin/products") && method.equals("GET")) {send(res,200,products(true));return;}
                if (path.equals("/admin/products") && method.equals("POST")) {send(res,201,saveProduct(null,body(req)));return;}
                if (path.matches("/admin/products/[0-9]+") && method.equals("PUT")) {send(res,200,saveProduct(Long.valueOf(path.substring(path.lastIndexOf('/')+1)),body(req)));return;}
                if (path.equals("/admin/orders") && method.equals("GET")) {send(res,200,orders(req.getParameter("status")));return;}
                if (path.matches("/admin/orders/[0-9a-fA-F-]+") && method.equals("PATCH")) {send(res,200,updateOrder(uuid(path.substring(path.lastIndexOf('/')+1)),body(req)));return;}
                if (path.equals("/admin/summary") && method.equals("GET")) {send(res,200,summary());return;}
            }
            throw new Problem(404,"Không tìm thấy chức năng này.");
        } catch (Problem e) { send(res,e.code,Map.of("error",e.getMessage())); }
        catch (SQLException e) {
            getServletContext().log("Database operation failed; SQLState="+e.getSQLState());
            send(res,503,Map.of("error","Chưa thể xử lý yêu cầu. Vui lòng thử lại."));
        } catch (Exception e) {
            getServletContext().log("Request failed: "+e.getClass().getSimpleName());
            send(res,500,Map.of("error","Có lỗi khi xử lý yêu cầu."));
        }
    }
    private void login(HttpServletRequest req,HttpServletResponse res) throws Exception {
        String ip=req.getRemoteAddr();long now=System.currentTimeMillis();
        List<Long> attempts=failures.computeIfAbsent(ip,k->Collections.synchronizedList(new ArrayList<>()));
        synchronized(attempts){attempts.removeIf(t->t<now-900000);require(attempts.size()<10,429,"Bạn đã thử quá nhiều lần. Hãy đợi 15 phút.");attempts.add(now);}
        JsonNode b=body(req);String username=text(b,"username",1,100),password=text(b,"password",1,200);
        String[] hash=Database.required("COFFEE_ADMIN_HASH").split(":");
        byte[] salt=Base64.getDecoder().decode(hash[0]),expected=Base64.getDecoder().decode(hash[1]);
        var spec=new PBEKeySpec(password.toCharArray(),salt,260000,256);
        byte[] actual=SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();spec.clearPassword();
        boolean valid=MessageDigest.isEqual(actual,expected) && username.equals(Database.required("COFFEE_ADMIN_USER"));
        if(!valid){throw new Problem(401,"Tên đăng nhập hoặc mật khẩu không đúng.");}
        failures.remove(ip);
        HttpSession session=req.getSession(true);req.changeSessionId();session.setAttribute("admin",true);
        String csrf=UUID.randomUUID().toString();session.setAttribute("csrf",csrf);
        send(res,200,Map.of("username",username,"csrf",csrf));
    }
    private List<Map<String,Object>> products(boolean all) throws SQLException {
        List<Map<String,Object>> result=new ArrayList<>();
        try(Connection c=Database.open();PreparedStatement s=c.prepareStatement("SELECT * FROM products"+(all?"":" WHERE active")+" ORDER BY id" );ResultSet r=s.executeQuery()) {
            while(r.next())result.add(Map.of("id",r.getLong("id"),"name",r.getString("name"),"category",r.getString("category"),"description",r.getString("description"),"price",r.getLong("price"),"stock",r.getInt("stock"),"active",r.getBoolean("active")));
        }return result;
    }
    private Map<String,Object> saveProduct(Long id,JsonNode b) throws SQLException {
        String name=text(b,"name",1,120),category=text(b,"category",1,30),description=text(b,"description",0,500);
        require(Set.of("coffee","tea","food").contains(category),400,"Danh mục không hợp lệ.");
        long price=number(b,"price",1000,100000000),stock=number(b,"stock",0,1000000);
        require(b.has("active")&&b.get("active").isBoolean(),400,"Trạng thái sản phẩm không hợp lệ.");
        long expectedStock=id==null?0:number(b,"expectedStock",0,1000000);
        try(Connection c=Database.open();PreparedStatement s=c.prepareStatement(id==null?"INSERT INTO products(name,category,description,price,stock,active) VALUES (?,?,?,?,?,?) RETURNING id":"UPDATE products SET name=?,category=?,description=?,price=?,stock=?,active=? WHERE id=? AND stock=? RETURNING id")) {
            s.setString(1,name);s.setString(2,category);s.setString(3,description);s.setLong(4,price);s.setInt(5,(int)stock);s.setBoolean(6,b.get("active").asBoolean());if(id!=null){s.setLong(7,id);s.setLong(8,expectedStock);}
            try(ResultSet r=s.executeQuery()){require(r.next(),409,"Tồn kho vừa thay đổi. Đóng cửa sổ, làm mới rồi cập nhật lại.");return Map.of("id",r.getLong(1));}
        }
    }
    private Map<String,Object> placeOrder(JsonNode b) throws SQLException {
        String name=text(b,"name",2,100),phone=text(b,"phone",8,20),address=text(b,"address",3,400),note=text(b,"note",0,500),payment=text(b,"paymentMethod",1,20);
        require(phone.matches("[+0-9 .()-]{8,20}"),400,"Số điện thoại không hợp lệ.");
        require(Set.of("cash","bank").contains(payment),400,"Phương thức thanh toán không hợp lệ.");
        UUID requestKey=uuid(text(b,"requestKey",36,36));JsonNode items=b.get("items");
        require(items!=null&&items.isArray()&&items.size()>0&&items.size()<=30,400,"Giỏ hàng không hợp lệ.");
        SortedMap<Long,Integer> wanted=new TreeMap<>();
        for(JsonNode item:items){long pid=number(item,"productId",1,Long.MAX_VALUE);int qty=(int)number(item,"quantity",1,100);require(!wanted.containsKey(pid),400,"Sản phẩm bị lặp trong giỏ.");wanted.put(pid,qty);}
        try(Connection c=Database.open()) {
            c.setAutoCommit(false);
            try {
                // A transaction lock makes retried submissions return the original order.
                try(PreparedStatement lock=c.prepareStatement("SELECT pg_advisory_xact_lock(?)")){lock.setLong(1,requestKey.getMostSignificantBits()^requestKey.getLeastSignificantBits());lock.execute();}
                try(PreparedStatement old=c.prepareStatement("SELECT id,total,status FROM orders WHERE request_key=?")){old.setObject(1,requestKey);try(ResultSet r=old.executeQuery()){if(r.next()){var existing=Map.<String,Object>of("id",r.getString("id"),"total",r.getLong("total"),"status",r.getString("status"));c.commit();return existing;}}}
                List<Map<String,Object>> lines=new ArrayList<>();long total=0;
                for(var entry:wanted.entrySet()){
                    try(PreparedStatement s=c.prepareStatement("SELECT name,price,stock,active FROM products WHERE id=? FOR UPDATE")){
                        s.setLong(1,entry.getKey());try(ResultSet r=s.executeQuery()){
                            require(r.next(),409,"Một sản phẩm không còn tồn tại.");
                            require(r.getBoolean("active")&&r.getInt("stock")>=entry.getValue(),409,"Sản phẩm hết hàng hoặc không đủ số lượng: "+r.getString("name"));
                            long price=r.getLong("price");total=Math.addExact(total,Math.multiplyExact(price,entry.getValue()));
                            lines.add(Map.of("id",entry.getKey(),"name",r.getString("name"),"price",price,"quantity",entry.getValue()));
                        }
                    }
                }
                UUID id=UUID.randomUUID();
                try(PreparedStatement s=c.prepareStatement("INSERT INTO orders(id,request_key,customer_name,phone,address,note,payment_method,total) VALUES (?,?,?,?,?,?,?,?)")){
                    s.setObject(1,id);s.setObject(2,requestKey);s.setString(3,name);s.setString(4,phone);s.setString(5,address);s.setString(6,note);s.setString(7,payment);s.setLong(8,total);s.executeUpdate();
                }
                for(var line:lines){
                    try(PreparedStatement s=c.prepareStatement("INSERT INTO order_items(order_id,product_id,name,unit_price,quantity) VALUES (?,?,?,?,?)")){s.setObject(1,id);s.setLong(2,(Long)line.get("id"));s.setString(3,(String)line.get("name"));s.setLong(4,(Long)line.get("price"));s.setInt(5,(Integer)line.get("quantity"));s.executeUpdate();}
                    try(PreparedStatement s=c.prepareStatement("UPDATE products SET stock=stock-? WHERE id=?")){s.setInt(1,(Integer)line.get("quantity"));s.setLong(2,(Long)line.get("id"));s.executeUpdate();}
                }
                event(c,id,"Khách đặt hàng");c.commit();return Map.of("id",id.toString(),"total",total,"status","pending");
            } catch(Exception e){c.rollback();throw e;}
        }
    }
    private void event(Connection c,UUID id,String description) throws SQLException {
        try(PreparedStatement s=c.prepareStatement("INSERT INTO order_events(order_id,description) VALUES (?,?)")){s.setObject(1,id);s.setString(2,description);s.executeUpdate();}
    }
    private List<Map<String,Object>> orders(String status) throws SQLException {
        if(status!=null&&!status.isBlank())require(STATES.contains(status),400,"Trạng thái không hợp lệ.");
        boolean filter=status!=null&&!status.isBlank();List<Map<String,Object>> result=new ArrayList<>();
        try(Connection c=Database.open();PreparedStatement s=c.prepareStatement("SELECT * FROM orders"+(filter?" WHERE status=?":"")+" ORDER BY created_at DESC LIMIT 200")){
            if(filter)s.setString(1,status);
            try(ResultSet r=s.executeQuery()){
                while(r.next()){
                    Map<String,Object> order=new LinkedHashMap<>();String id=r.getString("id");order.put("id",id);order.put("name",r.getString("customer_name"));order.put("phone",r.getString("phone"));order.put("address",r.getString("address"));order.put("note",r.getString("note"));order.put("total",r.getLong("total"));order.put("status",r.getString("status"));order.put("paymentMethod",r.getString("payment_method"));order.put("paymentStatus",r.getString("payment_status"));order.put("createdAt",r.getTimestamp("created_at").toInstant().toString());
                    List<Map<String,Object>> lines=new ArrayList<>();
                    try(PreparedStatement linesQuery=c.prepareStatement("SELECT name,unit_price,quantity FROM order_items WHERE order_id=? ORDER BY product_id")){linesQuery.setObject(1,UUID.fromString(id));try(ResultSet lr=linesQuery.executeQuery()){while(lr.next())lines.add(Map.of("name",lr.getString(1),"price",lr.getLong(2),"quantity",lr.getInt(3)));}}
                    order.put("items",lines);result.add(order);
                }
            }
        }return result;
    }
    private Map<String,Object> updateOrder(UUID id,JsonNode b) throws SQLException {
        String newStatus=text(b,"status",1,20),newPayment=text(b,"paymentStatus",1,20);
        require(STATES.contains(newStatus)&&PAYMENTS.contains(newPayment),400,"Trạng thái không hợp lệ.");
        try(Connection c=Database.open()){
            c.setAutoCommit(false);
            try {
                String previous,previousPayment;
                try(PreparedStatement s=c.prepareStatement("SELECT status,payment_status FROM orders WHERE id=? FOR UPDATE")){s.setObject(1,id);try(ResultSet r=s.executeQuery()){require(r.next(),404,"Không tìm thấy đơn.");previous=r.getString(1);previousPayment=r.getString(2);}}
                Map<String,Set<String>> transitions=Map.of("pending",Set.of("confirmed","cancelled"),"confirmed",Set.of("preparing","cancelled"),"preparing",Set.of("completed","cancelled"),"completed",Set.of("cancelled"),"cancelled",Set.of());
                require(previous.equals(newStatus)||transitions.get(previous).contains(newStatus),409,"Không thể chuyển trạng thái đơn theo thứ tự này.");
                require(!newStatus.equals("completed")||newPayment.equals("paid"),409,"Xác nhận đã thu tiền trước khi hoàn tất đơn.");
                require(!newStatus.equals("cancelled")||!newPayment.equals("paid"),409,"Đơn đã thu tiền cần được hoàn tiền trước khi hủy.");
                require(!newPayment.equals("refunded")||previousPayment.equals("paid")||previousPayment.equals("refunded"),409,"Không thể hoàn tiền cho đơn chưa thanh toán.");
                require(!previousPayment.equals("refunded")||newPayment.equals("refunded"),409,"Đơn đã hoàn tiền không thể đổi trạng thái thanh toán.");
                require(!previousPayment.equals("paid")||!newPayment.equals("unpaid"),409,"Đơn đã thu tiền chỉ có thể chuyển sang hoàn tiền.");
                require(!newPayment.equals("refunded")||newStatus.equals("cancelled"),409,"Đơn hoàn tiền cần được hủy.");
                if(newStatus.equals("cancelled")&&!previous.equals("cancelled")&&!previous.equals("completed")){
                    try(PreparedStatement s=c.prepareStatement("SELECT product_id,quantity FROM order_items WHERE order_id=? ORDER BY product_id")){s.setObject(1,id);try(ResultSet r=s.executeQuery()){while(r.next()){try(PreparedStatement stock=c.prepareStatement("UPDATE products SET stock=stock+? WHERE id=?")){stock.setInt(1,r.getInt(2));stock.setLong(2,r.getLong(1));stock.executeUpdate();}}}}
                }
                try(PreparedStatement s=c.prepareStatement("UPDATE orders SET status=?,payment_status=?,updated_at=now() WHERE id=?")){s.setString(1,newStatus);s.setString(2,newPayment);s.setObject(3,id);s.executeUpdate();}
                if(!previous.equals(newStatus)||!previousPayment.equals(newPayment))event(c,id,previous+" → "+newStatus+"; "+previousPayment+" → "+newPayment);
                c.commit();return Map.of("id",id.toString(),"status",newStatus,"paymentStatus",newPayment);
            }catch(Exception e){c.rollback();throw e;}
        }
    }
    private Map<String,Object> summary() throws SQLException {
        try(Connection c=Database.open();Statement s=c.createStatement();ResultSet r=s.executeQuery("SELECT count(*) AS all_orders,count(*) FILTER (WHERE status='pending') AS pending,count(*) FILTER (WHERE status IN ('confirmed','preparing')) AS processing,coalesce(sum(total) FILTER (WHERE payment_status='paid'),0) AS revenue,coalesce(sum(total) FILTER (WHERE payment_status='paid' AND (created_at AT TIME ZONE 'Asia/Ho_Chi_Minh')::date=(now() AT TIME ZONE 'Asia/Ho_Chi_Minh')::date),0) AS today,coalesce(sum(total) FILTER (WHERE payment_status='unpaid' AND status<>'cancelled'),0) AS due FROM orders")){
            r.next();return Map.of("orders",r.getLong("all_orders"),"pending",r.getLong("pending"),"processing",r.getLong("processing"),"revenue",r.getLong("revenue"),"today",r.getLong("today"),"due",r.getLong("due"));
        }
    }
}
