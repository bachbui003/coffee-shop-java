<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
       <%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="../nguoidung/style.css">
<title>Insert title here</title>
</head>
<body>
<% 
String url = "jdbc:mysql://localhost:3306/baitaplon"; 
String username = "root"; 
String password = "1234"; 

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
try {
    // Lấy dữ liệu từ form
    String tentkadmin = request.getParameter("tentkadmin");
    String mkadmin = request.getParameter("mkadmin");

    // Kết nối đến cơ sở dữ liệu
    Class.forName("com.mysql.jdbc.Driver");
    conn = DriverManager.getConnection(url, username, password);

    // Thực hiện truy vấn để kiểm tra email hoặc số điện thoại
    String sql = "SELECT * FROM tk_admin WHERE tentkadmin = ? OR mkadmin = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, tentkadmin);
    pstmt.setString(2, mkadmin);

    // Thực hiện truy vấn SELECT
    rs = pstmt.executeQuery();

    // Kiểm tra xem thông tin đăng nhập có hợp lệ hay không
    if (rs.next()) {
        String storedmkadmin = rs.getString("mkadmin");
        if (storedmkadmin.equals(mkadmin)) {
            String contextPath = request.getContextPath();
            out.print("<script>alert('Đăng nhập thành công!'); window.location = '" + contextPath + "/Admin/header.jsp';</script>");
            // out.print("<script>alert('Đăng nhập thành công!'); window.location = '..nguoidung/coffee-main/index.jsp';</script>");
        } else {
            out.print("<script>alert('Mật khẩu không chính xác, vui lòng kiểm tra lại!');</script>");
        }
    } 

} catch (SQLException e) {
    e.printStackTrace();
    out.print("<script>alert('Có lỗi xảy ra trong quá trình kết nối cơ sở dữ liệu.');</script>");
} catch (ClassNotFoundException e) {
    e.printStackTrace();
    out.print("<script>alert('Có lỗi xảy ra với driver cơ sở dữ liệu.');</script>");
} finally {
    try {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>
<div class="container" id="container">
        <div class="form-container sign-in">
            <form method="post">
                <h1>Đăng Nhập</h1>     
    <input type="text" name="tentkadmin" placeholder="Tên Tài Khoản" required>
    <input type="text" name="mkadmin" placeholder="Mật Khẩu" required>

                
                <button type="submit">Đăng Nhập</button>
            </form>
        </div>
        <div class="toggle-container">
            <div class="toggle">
                <div class="toggle-panel toggle-right">
                    <h1>ADMIN</h1>
                    <p>Điền thông tin đăng nhập</p>
                   
                </div>
            </div>
        </div>
    </div>
</body>
</html>