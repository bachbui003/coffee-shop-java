<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="stylesheet" href="style.css">
    <title>Modern Login Page | AsmrProg</title>

</head>
<body>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<%
    // Khai báo các thông số kết nối
    String url = "jdbc:mysql://localhost:3306/baitaplon"; 
    String username = "root"; 
    String password = "1234"; 

    Connection conn = null;
    PreparedStatement pstmt = null;
    try {

        // Lấy dữ liệu từ form
        String hoten = request.getParameter("hoten");
        String email = request.getParameter("email");
        String sdt = request.getParameter("sdt");
        String matkhau = request.getParameter("matkhau");
    
        // Kết nối đến cơ sở dữ liệu
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        
        // Thực hiện truy vấn để thêm dữ liệu vào cơ sở dữ liệu
        String sql = "INSERT INTO nguoidung (email, sdt, matkhau, hoten) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, sdt);
        pstmt.setString(3, matkhau);
        pstmt.setString(4, hoten);
        
        // Thực hiện truy vấn INSERT
        int rowsAffected = pstmt.executeUpdate();
        
        // Kiểm tra xem dữ liệu đã được thêm thành công hay không
        if (rowsAffected > 0) {
        	out.print("<script>alert('Thêm tài khoản thành công');</script>");

        } else {
        	out.print("<script>alert('Lỗi không thể thêm tài khoản, vui lòng thử lại');</script>");

        }
        
    } catch (SQLException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        // Đóng tất cả các kết nối và câu lệnh
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%
    ResultSet rs = null;


    try {
        // Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String matkhau = request.getParameter("matkhau");

        // Kết nối đến cơ sở dữ liệu
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);

        // Thực hiện truy vấn để kiểm tra email hoặc số điện thoại
        String sql = "SELECT * FROM nguoidung WHERE email = ? OR sdt = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, email);
        pstmt.setString(2, email);

        // Thực hiện truy vấn SELECT
        rs = pstmt.executeQuery();

        // Kiểm tra xem thông tin đăng nhập có hợp lệ hay không
        if (rs.next()) {
            String storedMatkhau = rs.getString("matkhau");
            if (storedMatkhau.equals(matkhau)) {
                // Lưu thông tin người dùng vào session
                String hoten = rs.getString("hoten");
                session.setAttribute("user", hoten);
                session.setAttribute("email", email);

                String contextPath = request.getContextPath();
                out.print("<script>alert('Đăng nhập thành công!, xin chào " + hoten + "'); window.location = '" + contextPath + "/nguoidung/coffee-main/index.jsp';</script>");

            } else {
                out.print("<script>alert('Mật khẩu không đúng!'); window.location = '" + request.getContextPath() + "/login.jsp';</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>





<div class="container" id="container">
        <div class="form-container sign-up">
<form method="post">
    <h1>Tạo Tài Khoản</h1>
    <span>điền thông tin tài khoản đăng ký</span>
    <input type="text" name="hoten" placeholder="Họ Tên" required>
    <input type="email" name="email" placeholder="Email" required>
    <input type="text" name="sdt" placeholder="Số điện thoại" required>
    <input type="password" name="matkhau" placeholder="Mật khẩu" required>
    <button type="submit">Đăng Ký</button>
</form>
        </div>
        <div class="form-container sign-in">
            <form method="post">
                <h1>Đăng Nhập</h1>               
                <input type="text" name="email" placeholder="Nhập email hoặc số điện thoại">
                <input type="password" name="matkhau" placeholder="mật khẩu">
                <a href="#">Quên mật khẩu?</a>
                <button type="submit">Đăng nhập</button>
            </form>
        </div>
        <div class="toggle-container">
            <div class="toggle">
                <div class="toggle-panel toggle-left">
                    <h1>Trở Lại!</h1>
                    <p>Đăng nhập với thông tin cá nhân của bạn để xử dụng tất cả chức năng của trang web</p>
                    <button class="hidden" id="login">Đăng Nhập</button>
                </div>
                <div class="toggle-panel toggle-right">
                    <h1>Chúc Một Ngày Tốt Lành!</h1>
                    <p>Đăng ký với thông tin cá nhân của bạn để xử dụng tất cả chức năng của trang web</p>
                    <button class="hidden" id="register">Đăng Ký</button>
                </div>
            </div>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>