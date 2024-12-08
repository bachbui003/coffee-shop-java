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
    String url = "jdbc:mysql://localhost:3306/baitaplon"; 
    String username = "root"; 
    String password = "1234"; 

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Lấy dữ liệu từ form
    String tentkadmin = request.getParameter("hoten");
    String mkadmin = request.getParameter("matkhau");
    String matkhaumoi = request.getParameter("matkhaumoi");

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);

        if (tentkadmin != null && mkadmin != null && matkhaumoi != null) {
            String query = "SELECT * FROM tk_admin WHERE tentkadmin = ? AND mkadmin = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, tentkadmin);
            pstmt.setString(2, mkadmin);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                String updateQuery = "UPDATE tk_admin SET mkadmin = ? WHERE tentkadmin = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setString(1, matkhaumoi);
                pstmt.setString(2, tentkadmin);
                int result = pstmt.executeUpdate();

                if (result > 0) {
                    out.print("<script>alert('Đổi mật khẩu thành công');</script>");
                } else {
                    out.print("<script>alert('Lỗi không thể đổi mật khẩu, vui lòng thử lại');</script>");
                }
            } else {
                out.print("<script>alert('Thông tin nhập vào không chính xác');</script>");
            }
        } 
    } catch (SQLException e) {
        e.printStackTrace();
        out.print("<script>alert('Lỗi kết nối dữ liệu');</script>");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.print("<script>alert('Lỗi tải driver cơ sở dữ liệu');</script>");
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
            <h1>Đổi Mật Khẩu</h1>     
            <input type="text" name="hoten" placeholder="Họ Tên" required>
            <input type="password" name="matkhau" placeholder="Mật khẩu cũ" required>
            <input type="password" name="matkhaumoi" placeholder="Mật khẩu mới" required>
            <a href="<%= request.getContextPath() %>/Admin/header.jsp">Quay lại</a>
            <button type="submit">Đổi Mật Khẩu</button>
        </form>
    </div>
    <div class="toggle-container">
        <div class="toggle">
            <div class="toggle-panel toggle-right">
                <h1>Đổi Mật Khẩu</h1>
                <p>Điền đúng thông tin tài khoản bạn đã đăng ký và nhập mật khẩu mới để đổi mật khẩu</p>
            </div>
        </div>
    </div>
</div>

<script src="script.js"></script>
</body>
</html>
