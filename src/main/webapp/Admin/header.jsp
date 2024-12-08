<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Header Admin</title>
	<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600&display=swap" rel="stylesheet">
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css" rel="stylesheet">
	<link href="headercss.css" rel="stylesheet">
</head>
<body>

<nav>
		<ul>
			<li class="logo"><img alt="" src="https://i.postimg.cc/WzkCM20g/logo1.png"></li>
			<li>
				<a href="#"><i class="fa fa-home"></i>   home</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/Admin/ThemCafe.jsp"><i class="fa fa-book"></i>Quản Lý Cafe</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/Admin/ThemDoAn.jsp"><i class="fa fa-users"></i>   Quản Lý ĐÒ Ăn</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/Admin/themNhanVien.jsp"><i class="fa fa-picture-o"></i>Quản Lý Nhân Viên</a>
			</li>
		<li>
				<a href="<%=request.getContextPath()%>/nguoidung/doimkadmin.jsp"><i class="fa fa-picture-o"></i>Đổi Mật Khẩu</a>
			</li>
			<li>
				<a href="<%=request.getContextPath()%>/Admin/DNAdmin.jsp"><i class="fa fa-picture-o"></i>Đăng xuất</a>
			</li>
		</ul>
	</nav>



</body>
</html>