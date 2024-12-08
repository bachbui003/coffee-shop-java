<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<style>
body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
    }

    .containerForm {
        display: flex;
        align-items: flex-start;
        justify-content: center;
        width: 80%;
        padding: 20px;
        margin-top: 10%;
        margin-left: 15%; 
    }

    .Formnhap, .banghienthi {
        width: 50%;
        margin: 10px;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
        background-color: #f9f9f9;
    }
	.Formnhap{
		width: 25%;
	}
    .formm {
        display: flex;
        flex-direction: column;
    }

    .formm label, .formm input {
        margin-bottom: 10px;
    }

    .formm input[type="text"] {
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    .formm input[type="submit"] {
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        background-color: #4CAF50;
        color: white;
        cursor: pointer;
    }

    .formm input[type="submit"]:hover {
        background-color: #45a049;
    }

    .bangnhom {
        width: 100%;
        border-collapse: collapse;
    }

    .bangnhom th, .bangnhom td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }

    .bangnhom th {
        background-color: #f2f2f2;
        color: black;
    }

    .bangnhom tr:nth-child(even) {
        background-color: #f9f9f9;
    }

    .bangnhom tr:hover {
        background-color: #ddd;
    }

</style>
<body>
<jsp:include page="header.jsp" />
<div class="containerForm">
<div class="Formnhap">
<h2>Thêm Thông Tin Nhân Viên</h2>
<form action="" method="post" accept-charset="UTF-8" class="formm">
    <label for="IDNhanVien">ID Nhân Viên:</label>
    <input type="text" id="IDNhanVien" name="IDNhanVien" ><br>

    <label for="HoTenNV">Họ Tên:</label>
    <input type="text" id="HoTenNV" name="HoTenNV"><br>

    <label for="NamSingNV">Năm Sinh:</label>
    <input type="text" id="NamSingNV" name="NamSingNV"><br>

    <label for="GioiTinhNV">Giới Tính:</label>
    <input type="text" id="GioiTinhNV" name="GioiTinhNV"><br>

    <label for="SDT">Số Điện Thoại:</label>
    <input type="text" id="SDT" name="SDT"><br>

    <input type="hidden" id="action" name="action" value="insert">
    <input type="submit" value="Thêm">
</form>
<h2>Sửa Thông Tin</h2>
<form action="" method="post" class="formm">
    <label for="update_IDNhanVien">ID Nhân Viên:</label>
    <input type="text" id="update_IDNhanVien" name="update_IDNhanVien" placeholder="Nhập id cần sửa"><br>

    <label for="update_HoTenNV">Họ Tên:</label>
    <input type="text" id="update_HoTenNV" name="update_HoTenNV"><br>

    <label for="update_NamSingNV">Năm Sinh:</label>
    <input type="text" id="update_NamSingNV" name="update_NamSingNV"><br>

    <label for="update_GioiTinhNV">Giới Tính:</label>
    <input type="text" id="update_GioiTinhNV" name="update_GioiTinhNV"><br>

    <label for="update_SDT">Số Điện Thoại:</label>
    <input type="text" id="update_SDT" name="update_SDT"><br>
    
    <input type="hidden" id="action" name="action" value="update">
    <input type="submit" value="Sửa">
</form>
</div>
<div class="banghienthi">
<table border="1" class="bangnhom">
    <tr>
        <th>ID Nhân Viên</th>
        <th>Họ Tên</th>
        <th>Năm Sinh</th>
        <th>Giới Tính</th>
        <th>SĐT</th>
        <th>Hành Động</th>
    </tr>
    <%
        String dbURL = "jdbc:mysql://localhost:3306/baitaplon?useUnicode=true&characterEncoding=UTF-8";
        String dbUser = "root";
        String dbPass = "1234";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            request.setCharacterEncoding("UTF-8");
            response.setContentType("text/html; charset=UTF-8");

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            String action = request.getParameter("action");
            String IDNhanVien = request.getParameter("IDNhanVien");
            String HoTenNV = request.getParameter("HoTenNV");
            String NamSingNV = request.getParameter("NamSingNV");
            String GioiTinhNV = request.getParameter("GioiTinhNV");
            String SDT = request.getParameter("SDT");

            if ("insert".equalsIgnoreCase(action)) {
                String insertSQL = "INSERT INTO thongtinnv (IDNhanVien, HoTenNV, NamSingNV, GioiTinhNV, SDT) VALUES (?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, IDNhanVien);
                pstmt.setString(2, HoTenNV);
                pstmt.setString(3, NamSingNV);
                pstmt.setString(4, GioiTinhNV);
                pstmt.setString(5, SDT);
                int rowsInserted = pstmt.executeUpdate();
  
            }else if ("delete".equalsIgnoreCase(action)) {
                String deleteIDNhanVien = request.getParameter("deleteIDNhanVien");
                String deleteHoTenNV = request.getParameter("deleteHoTenNV");
                String deleteNamSingNV = request.getParameter("deleteNamSingNV");
                String deleteGioiTinhNV = request.getParameter("deleteGioiTinhNV");
                String deleteSDT = request.getParameter("deleteSDT");
                
                // Sử dụng câu SQL DELETE phù hợp
                String deleteSQL = "DELETE FROM thongtinnv WHERE IDNhanVien = ? AND HoTenNV = ? AND NamSingNV = ? AND GioiTinhNV = ? AND SDT = ?";
                
                
                    pstmt = conn.prepareStatement(deleteSQL);
                    pstmt.setString(1, deleteIDNhanVien);
                    pstmt.setString(2, deleteHoTenNV);
                    pstmt.setString(3, deleteNamSingNV);
                    pstmt.setString(4, deleteGioiTinhNV);
                    pstmt.setString(5, deleteSDT);
                    
                    pstmt.executeUpdate();
                    
       
            }         else if ("update".equalsIgnoreCase(action)) {
                String update_IDNhanVien = request.getParameter("update_IDNhanVien");
                String update_HoTenNV = request.getParameter("update_HoTenNV");
                String update_NamSingNV = request.getParameter("update_NamSingNV");
                String update_GioiTinhNV = request.getParameter("update_GioiTinhNV");
                String update_SDT = request.getParameter("update_SDT");

                // Sử dụng câu SQL UPDATE để cập nhật thông tin nhân viên
                String updateSQL = "UPDATE thongtinnv SET HoTenNV = ?, NamSingNV = ?, GioiTinhNV = ?, SDT = ? WHERE IDNhanVien = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, update_HoTenNV);
                pstmt.setString(2, update_NamSingNV);
                pstmt.setString(3, update_GioiTinhNV);
                pstmt.setString(4, update_SDT);
                pstmt.setString(5, update_IDNhanVien);

                int rowsUpdated = pstmt.executeUpdate();
            }


            String selectSQL = "SELECT * FROM thongtinnv";
            pstmt = conn.prepareStatement(selectSQL);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String IDNhanVienResult = rs.getString("IDNhanVien");
                String HoTenNVResult = rs.getString("HoTenNV");
                String NamSingNVResult = rs.getString("NamSingNV");
                String GioiTinhNVResult = rs.getString("GioiTinhNV");
                String SDTResult = rs.getString("SDT");
    %>
    <tr>
        <td><%= IDNhanVienResult %></td>
        <td><%= HoTenNVResult %></td>
        <td><%= NamSingNVResult %></td>
        <td><%= GioiTinhNVResult %></td>
        <td><%= SDTResult %></td>
        <td>
    <form method="post" action="">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="deleteIDNhanVien" value="<%= IDNhanVienResult %>">
        <input type="hidden" name="deleteHoTenNV" value="<%= HoTenNVResult %>">
        <input type="hidden" name="deleteNamSingNV" value="<%= NamSingNVResult %>">
        <input type="hidden" name="deleteGioiTinhNV" value="<%= GioiTinhNVResult %>">
        <input type="hidden" name="deleteSDT" value="<%= SDTResult %>">
        <input type="submit" value="Xóa">
    </form>

</td>
    </tr>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Lỗi: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</table>
</div>
</div>
</body>
</html>