<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*, javax.sql.*" %>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>Thêm Loại Mặt Hàng</title>

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
        width: 30%;
        margin: 10px;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 5px;
        background-color: #f9f9f9;
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
<h2>Thêm Sản Phẩm</h2>
<form action="" method="post" accept-charset="UTF-8"  class="formm">
    <label for="id_cafe">Mã Cafe:</label>
    <input type="text" id="id_cafe" name="id_cafe" ><br>
    
    <label for="ten_cafe">Tên Cafe:</label>
    <input type="text" id="ten_cafe" name="ten_cafe"><br>
    
     <label for="giatien">Giá Tiền:</label>
    <input type="text" id="giatien" name="giatien"><br>
    
    <input type="hidden" id="action" name="action" value="insert">
    <input type="submit" value="Thêm">

	

</form>
<h2>Sửa Sản Phẩm</h2>
<form action="" method="post" class="formm">
    <label for="update_id_cafe">Mã Cafe cần sửa:</label>
    <input type="text" id="update_id_cafe" name="update_id_cafe" placeholder="Nhập id cần chỉnh sửa"><br>
    
    <label for="update_ten_cafe">Tên Cafe mới:</label>
    <input type="text" id="update_ten_cafe" name="update_ten_cafe"><br>
    
    <label for="update_giatien">Giá Tiền mới:</label>
    <input type="text" id="update_giatien" name="update_giatien"><br>
    
    <input type="hidden" id="action" name="action" value="update">
    <input type="submit" value="Sửa">
</form>
</div>
<div class="banghienthi">
<table border="1" class="bangnhom">
    <tr>
        <th>Mã Cafe</th>
        <th>Tên Cafe</th>
        <th>GiaTien</th>
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
            String id_cafe = request.getParameter("id_cafe");
            String ten_cafe = request.getParameter("ten_cafe");
            String giatien = request.getParameter("giatien");
            if ("insert".equalsIgnoreCase(action)) {
                String insertSQL = "INSERT INTO cafe (id_cafe, ten_cafe, giatien) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, id_cafe);
                pstmt.setString(2, ten_cafe);
                pstmt.setString(3, giatien);
                pstmt.executeUpdate();
            }else if ("delete".equalsIgnoreCase(action)) {
                String deleteid_cafe = request.getParameter("deleteid_cafe");
                String deleteten_cafe = request.getParameter("deleteten_cafe");
                String deletegiatien = request.getParameter("deletegiatien");
                
                // Sử dụng câu SQL DELETE phù hợp
                String deleteSQL = "DELETE FROM cafe WHERE id_cafe = ? AND ten_cafe = ? AND giatien = ?";
                
                
                    pstmt = conn.prepareStatement(deleteSQL);
                    pstmt.setString(1, deleteid_cafe);
                    pstmt.setString(2, deleteten_cafe);
                    pstmt.setString(3, deletegiatien);
                    
                    pstmt.executeUpdate();
                    
       
            }// Phần xử lý action "update"
            else if ("update".equalsIgnoreCase(action)) {
                String update_id_cafe = request.getParameter("update_id_cafe");
                String update_ten_cafe = request.getParameter("update_ten_cafe");
                String update_giatien = request.getParameter("update_giatien");
                
                // Sử dụng câu SQL UPDATE để cập nhật sản phẩm
                String updateSQL = "UPDATE cafe SET ten_cafe = ?, giatien = ? WHERE id_cafe = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, update_ten_cafe);
                pstmt.setString(2, update_giatien);
                pstmt.setString(3, update_id_cafe);
                
                pstmt.executeUpdate();
            }


            String selectSQL = "SELECT * FROM cafe";
            pstmt = conn.prepareStatement(selectSQL);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	String id_cafeResult = rs.getString("id_cafe");
                String ten_cafeResult = rs.getString("ten_cafe");
                String giatienResult = rs.getString("giatien");
    %>
    <tr>
        <td><%= id_cafeResult %></td>
        <td><%= ten_cafeResult %></td>
        <td><%= giatienResult %></td>
<td>
    <form method="post" action="">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="deleteid_cafe" value="<%= id_cafeResult %>">
        <input type="hidden" name="deleteten_cafe" value="<%= ten_cafeResult %>">
        <input type="hidden" name="deletegiatien" value="<%= giatienResult %>">
        <input type="submit" value="Xóa">
    </form>

</td>


    </tr>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();
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
