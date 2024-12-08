	<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
        <%@ page import="java.sql.*" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="javax.naming.*, javax.sql.*" %>
	<!DOCTYPE html>
	<html lang="zxx" class="no-js">
<head>
		<!-- Mobile Specific Meta -->
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="shortcut icon" href="img/fav.png">
		<!-- Author Meta -->
		<meta name="author" content="codepixer">
		<!-- Meta Description -->
		<meta name="description" content="">
		<!-- Meta Keyword -->
		<meta name="keywords" content="">
		<!-- meta character set -->
		<meta charset="UTF-8">
		<!-- Site Title -->
		<title>Coffee</title>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
		<link href="https://fonts.googleapis.com/css?family=Poppins:100,200,400,300,500,600,700" rel="stylesheet"> 
			<!--
			CSS
			============================================= -->
			<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
			<link rel="stylesheet" href="css/linearicons.css">
			<link rel="stylesheet" href="css/font-awesome.min.css">
			<link rel="stylesheet" href="css/bootstrap.css">
			<link rel="stylesheet" href="css/magnific-popup.css">
			<link rel="stylesheet" href="css/nice-select.css">					
			<link rel="stylesheet" href="css/animate.min.css">
			<link rel="stylesheet" href="css/owl.carousel.css">
			<link rel="stylesheet" href="css/main.css">
		</head>
<body>
<header id="header" id="home">
				<div class="header-top">
		  			<div class="container">
				  		<div class="row justify-content-end">
				  			<div class="col-lg-8 col-sm-4 col-8 header-top-right no-padding">
				  				<ul>
				  					<li>
				  						<a href="tel:(012) 6985 236 7512">Liên hệ chúng tôi: 0867646734</a>
				  					</li>				  					
				  				</ul>
				  			</div>
				  		</div>			  					
		  			</div>
				</div>			  	
			    <div class="container">
			    	<div class="row align-items-center justify-content-between d-flex">
				      <div id="logo">
				        <a href="index.html"><img src="img/logo.png" alt="" title="" /></a>
				      </div>
				      <nav id="nav-menu-container">
				        <ul class="nav-menu">
				          <li class="menu-active"><a href="#home">Home</a></li>
				          <li><a href="#about">Về chúng tôi</a></li>
				          
				          <li class="menu-has-children"><a href="">Coffee</a>
				            <ul>
				              <li><a href="#coffee">coffee</a></li>
				              <li><a href="#AnVat">Đồ ăn vặt</a></li>
				            </ul>
				          </li>
			          <li class="menu-has-children"><a href="">Oder</a>
				            <ul>
				              <li><a href="generic.html">Đặt bàn</a></li>
				              <li><a href="elements.html">Đặt mang về</a></li>
				            </ul>
				          </li>
				       <li class="menu-has-children"><a href="">Tài Khoản</a>
				            <ul>
				              <li><a href="<%= request.getContextPath() %>/nguoidung/doimatkhau.jsp">Đổi mật khẩu</a></li>
				              <li><a href="<%= request.getContextPath() %>/nguoidung/TknguoiDung.jsp">Đăng xuất</a></li>
				            </ul>
				          </li>
				          <li><a href="#about"><i class="fas fa-shopping-cart"></i></a></li>
				        </ul>
				      </nav><!-- #nav-menu-container -->		    		
			    	</div>
			    </div>
			  </header><!-- #header -->
	
</body>
</html>