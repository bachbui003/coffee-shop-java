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
    <label for="id_doan">Mã Đồ Ăn:</label>
    <input type="text" id="id_doan" name="id_doan" ><br>
    
    <label for="ten_doan">Tên Đồ Ăn:</label>
    <input type="text" id="ten_doan" name="ten_doan"><br>
    
     <label for="giatien">Giá Tiền:</label>
    <input type="text" id="giatien" name="giatien"><br>
    
    <input type="hidden" id="action" name="action" value="insert">
    <input type="submit" value="Thêm">

	

</form>
<h2>Sửa Sản Phẩm</h2>
<form action="" method="post" class="formm">
    <label for="update_id_doan">Mã đồ ăn cần sửa:</label>
    <input type="text" id="update_id_doan" name="update_id_doan" placeholder="Nhập id cần chỉnh sửa"><br>
    
    <label for="update_ten_doan">Tên đồ ăn mới:</label>
    <input type="text" id="update_ten_doan" name="update_ten_doan"><br>
    
    <label for="update_giatien">Giá Tiền mới:</label>
    <input type="text" id="update_giatien" name="update_giatien"><br>
    
    <input type="hidden" id="action" name="action" value="update">
    <input type="submit" value="Sửa">
</form>
</div>
<div class="banghienthi">
<table border="1" class="bangnhom">
    <tr>
        <th>Mã Đồ Ăn</th>
        <th>Tên Đồ Ăn</th>
        <th>Giá Tiền</th>
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
            String id_doan = request.getParameter("id_doan");
            String ten_doan = request.getParameter("ten_doan");
            String giatien = request.getParameter("giatien");
            if ("insert".equalsIgnoreCase(action)) {
                String insertSQL = "INSERT INTO doan (id_doan, ten_doan, giatien) VALUES (?, ?, ?)";
                pstmt = conn.prepareStatement(insertSQL);
                pstmt.setString(1, id_doan);
                pstmt.setString(2, ten_doan);
                pstmt.setString(3, giatien);
                pstmt.executeUpdate();
            }else if ("delete".equalsIgnoreCase(action)) {
                String deleteid_doan = request.getParameter("deleteid_doan");
                String deleteten_doan = request.getParameter("deleteten_doan");
                String deletegiatien = request.getParameter("deletegiatien");
                
                // Sử dụng câu SQL DELETE phù hợp
                String deleteSQL = "DELETE FROM doan WHERE id_doan = ? AND ten_doan = ? AND giatien = ?";
                
                
                    pstmt = conn.prepareStatement(deleteSQL);
                    pstmt.setString(1, deleteid_doan);
                    pstmt.setString(2, deleteten_doan);
                    pstmt.setString(3, deletegiatien);
                    
                    pstmt.executeUpdate();
                    
       
            }// Phần xử lý action "update"
            else if ("update".equalsIgnoreCase(action)) {
                String update_id_doan = request.getParameter("update_id_doan");
                String update_ten_doan = request.getParameter("update_ten_doan");
                String update_giatien = request.getParameter("update_giatien");
                
                // Sử dụng câu SQL UPDATE để cập nhật sản phẩm
                String updateSQL = "UPDATE doan SET ten_doan = ?, giatien = ? WHERE id_doan = ?";
                pstmt = conn.prepareStatement(updateSQL);
                pstmt.setString(1, update_ten_doan);
                pstmt.setString(2, update_giatien);
                pstmt.setString(3, update_id_doan);
                
                pstmt.executeUpdate();
            }


            String selectSQL = "SELECT * FROM doan";
            pstmt = conn.prepareStatement(selectSQL);
            rs = pstmt.executeQuery();

            while (rs.next()) {
            	String id_doanResult = rs.getString("id_doan");
                String ten_doanResult = rs.getString("ten_doan");
                String giatienResult = rs.getString("giatien");
    %>
    <tr>
        <td><%= id_doanResult %></td>
        <td><%= ten_doanResult %></td>
        <td><%= giatienResult %></td>
<td>
    <form method="post" action="">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="deleteid_doan" value="<%= id_doanResult %>">
        <input type="hidden" name="deleteten_doan" value="<%= ten_doanResult %>">
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
