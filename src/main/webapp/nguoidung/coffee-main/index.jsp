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
				  			   <%
                String hoten = (String) session.getAttribute("nguoidung");
                if (hoten != null) {
                    out.print("Xin chào, " + hoten + " ");
                } 
            %>
				  					</li>
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


			<!-- start banner Area -->
			<section class="banner-area" id="home">	
				<div class="container">
					<div class="row fullscreen d-flex align-items-center justify-content-start">
						<div class="banner-content col-lg-7">
							<h6 class="text-white text-uppercase">Bây giờ bạn có thể cảm thấy năng lượng trong bản thân</h6>
							<h1>
								Khởi đầu ngày mới <br>
								với một tách cafe				
							</h1>
							<a href="#" class="primary-btn text-uppercase">Mua ngay</a>
						</div>											
					</div>
				</div>
			</section>
			<!-- End banner Area -->	

			<!-- Start video-sec Area -->
			<section class="video-sec-area pb-100 pt-40" id="about">
				<div class="container">
					<div class="row justify-content-start align-items-center">
						<div class="col-lg-6 video-right justify-content-center align-items-center d-flex">
							<div class="overlay overlay-bg"></div>
							<a class="play-btn" href="https://www.youtube.com/watch?v=ARA0AxrnHdM"><img class="img-fluid" src="img/play-icon.png" alt=""></a>
						</div>						
						<div class="col-lg-6 video-left">
							<h6>quy trình làm cafe sống</h6>
							<h1>Cafe Siêu Nhân <br>
							Hương Liệu Cuộc Sống</h1>
							<p><span>Chúng tôi ở đây để nắng nghe những ý kiến của bạn</span></p>
							<p>
								Chúng tôi luôn muốn cho bạn những năng lượng tích qua từng cốc cafe mà bạn uống, hãy để chúng tôi giúp cuộc sống của bạn trở nên tràn đầy năng lượng và tích cực
							</p>
							<img class="img-fluid" src="img/signature.png" alt="">
						</div>
					</div>
				</div>	
			</section>
			<!-- End video-sec Area -->
			
			<!-- Start menu Area -->
			<section class="menu-area section-gap" id="coffee">
				<div class="container">
					<div class="row d-flex justify-content-center">
						<div class="menu-content pb-60 col-lg-10">
							<div class="title text-center">
								<h1 class="mb-10">Nước uống và cafe</h1>
								<p>Những tách cà phê đang tìm kiếm chủ nhân của nó</p>
							</div>
						</div>
					</div>	
					
					<div class="row">
					  <%
            // Thông tin kết nối cơ sở dữ liệu
            String url = "jdbc:mysql://localhost:3306/baitaplon";
            String user = "root";
            String password = "1234";  // Thay bằng mật khẩu thực tế của bạn

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Tải driver MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Kết nối đến cơ sở dữ liệu
                conn = DriverManager.getConnection(url, user, password);

         
                stmt = conn.createStatement();

                // Truy vấn bảng cafe
                String sql = "SELECT ten_cafe, giatien FROM cafe";
                rs = stmt.executeQuery(sql);
                
 

                // Hiển thị dữ liệu lên trang JSP
                while (rs.next()) {
                    String tenCafe = rs.getString("ten_cafe");
                    double giaTien = rs.getDouble("giatien");
        %>
						<div class="col-lg-4">
						      
							<div class="single-menu">
								<div class="title-div justify-content-between d-flex">
									<h4><%= tenCafe%></h4>
									<p class="price float-right">
										<%= giaTien %>
									</p>
								</div>
								<p>
									Usage of the Internet is becoming more common due to rapid advance.
								</p>
											<i class="fas fa-shopping-cart"></i>	
							</div>
						</div>
						 <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
						</div>
						
						
																			
					</div>
			
			</section>
			<!-- End menu Area -->
			
			<section class="menu-area section-gap" id="AnVat">
				<div class="container">
					<div class="row d-flex justify-content-center">
						<div class="menu-content pb-60 col-lg-10">
							<div class="title text-center">
								<h1 class="mb-10">Đồ ăn vặt</h1>
								<p>Những món ăn tuyệt vời chờ bạn thưởng thức</p>
							</div>
						</div>
					</div>						
				<div class="row">
  <%
        String action = request.getParameter("action");

        PreparedStatement pstmt = null;


        if ("insert".equalsIgnoreCase(action)) {
            String hoTen = (String) session.getAttribute("user");
            String sdt = (String) session.getAttribute("sdt");
            String tenmh = request.getParameter("tenmh");
            double giaTien = 0;
            int soLuong = 0;

            try {
                giaTien = Double.parseDouble(request.getParameter("giaTien"));
                soLuong = Integer.parseInt(request.getParameter("soLuong"));
            } catch (NumberFormatException e) {
                out.print("<script>alert('Lỗi: Giá tiền hoặc số lượng không hợp lệ!');</script>");
            }

            if (hoTen == null) {
                out.print("<script>alert('Lỗi: Bạn chưa đăng nhập!');</script>");
            } else {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, user, password);

                    String insertSql = "INSERT INTO gio_hang (hoten, sdt, tenmh, giatien, soluong) VALUES (?, ?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, hoTen);
                    pstmt.setString(2, sdt);
                    pstmt.setString(3, tenmh);
                    pstmt.setDouble(4, giaTien);
                    pstmt.setInt(5, soLuong);
                    pstmt.executeUpdate();

                    out.print("<script>alert('Đã thêm vào giỏ hàng thành công!');</script>");
                } catch (ClassNotFoundException e) {
                    out.print("<script>alert('Lỗi: Không tìm thấy driver cơ sở dữ liệu!');</script>");
                    e.printStackTrace();
                } catch (SQLException e) {
                    out.print("<script>alert('Lỗi: Không thể kết nối đến cơ sở dữ liệu!');</script>");
                    e.printStackTrace();
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            }
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);
            stmt = conn.createStatement();

            String sql = "SELECT ten_doan, giatien FROM doan";
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                String tenDoan = rs.getString("ten_doan");
                double giaTien = rs.getDouble("giatien");
    %>
    <div class="col-lg-4">
        <div class="single-menu">
            <div class="title-div justify-content-between d-flex">
                <h4><%= tenDoan %></h4>
                <p class="price float-right">
                    <%= giaTien %>
                </p>
            </div>
            <p>
                Usage of the Internet is becoming more common due to rapid advance.
            </p>
            <form action="" method="post">
                <input type="hidden" name="tenmh" value="<%= tenDoan %>">
                <input type="hidden" name="giaTien" value="<%= giaTien %>">
                <input type="hidden" name="action" value="insert">
                <input type="number" name="soLuong" placeholder="Nhập số lượng" min="1" required>
                <button type="submit" id="addToCart" name="addToCart"><i class="fas fa-shopping-cart"></i></button>
            </form>
        </div>
    </div>
    <%
            }
        } catch (ClassNotFoundException e) {
            out.print("<script>alert('Lỗi: Không tìm thấy driver cơ sở dữ liệu!');</script>");
            e.printStackTrace();
        } catch (SQLException e) {
            out.print("<script>alert('Lỗi: Không thể kết nối đến cơ sở dữ liệu!');</script>");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>
				</div>	
			</section>
			
			<!-- Start review Area -->
			<section class="review-area section-gap" id="review">
				<div class="container">
					<div class="row d-flex justify-content-center">
						<div class="menu-content pb-60 col-lg-10">
							<div class="title text-center">
								<h1 class="mb-10">Loại cà phê nào chúng tôi phục vụ cho bạn</h1>
								<p>Những người cực kỳ yêu thích hệ thống thân thiện với môi trường.</p>
							</div>
						</div>
					</div>						
					<div class="row">
						<div class="col-lg-6 col-md-6 single-review">
							<img src="img/r1.png" alt="">
							<div class="title d-flex flex-row">
								<h4>Đánh giá</h4>
								<div class="star">
									<span class="fa fa-star checked"></span>
									<span class="fa fa-star checked"></span>
									<span class="fa fa-star checked"></span>
									<span class="fa fa-star"></span>
									<span class="fa fa-star"></span>								
								</div>
							</div>
							<p>
								Nơi đây bạn có thể tìm kiếm cho mình những dòng cafe phê đặc biệt nhất, phù hợp với khẩu vị và phong cách của chính bản thân bạn, hãy đến với chúng tôi
							</p>
						</div>	
						<div class="col-lg-6 col-md-6 single-review">
							<img src="img/r2.png" alt="">
							<div class="title d-flex flex-row">
								<h4>lorem ipusm</h4>
								<div class="star">
									<span class="fa fa-star checked"></span>
									<span class="fa fa-star checked"></span>
									<span class="fa fa-star"></span>
									<span class="fa fa-star"></span>
									<span class="fa fa-star"></span>								
								</div>
							</div>
							<p>
							Nơi đây bạn có thể tìm kiếm cho mình những dòng cafe phê đặc biệt nhất, phù hợp với khẩu vị và phong cách của chính bản thân bạn, hãy đến với chúng tôi
							</p>
						</div>	
					</div>
					<div class="row counter-row">
						<div class="col-lg-3 col-md-6 single-counter">
							<h1 class="counter">2536</h1>
							<p>Lượt Khách Hài Lòng</p>
						</div>
						<div class="col-lg-3 col-md-6 single-counter">
							<h1 class="counter">7562</h1>
							<p>Tổng Lượt Đánh Giá</p>
						</div>
						<div class="col-lg-3 col-md-6 single-counter">
							<h1 class="counter">2013</h1>
							<p>Cups Coffee</p>
						</div>
						<div class="col-lg-3 col-md-6 single-counter">
							<h1 class="counter">10536</h1>
							<p>Tổng Số Đã Bán</p>
						</div>																		
					</div>
				</div>	
			</section>
			<!-- End review Area -->
			
			<!-- Start blog Area -->
			<section class="blog-area section-gap" id="blog">
				<div class="container">
					<div class="row d-flex justify-content-center">
						<div class="menu-content pb-60 col-lg-10">
							<div class="title text-center">
								<h1 class="mb-10">Loại cà phê nào chúng tôi phục vụ cho bạn</h1>
								<p>Những người cực kỳ yêu thích hệ thống thân thiện với môi trường.</p>
							</div>
						</div>
					</div>						
					<div class="row">
						<div class="col-lg-6 col-md-6 single-blog">
							<img class="img-fluid" src="img/b1.jpg" alt="">
							<ul class="post-tags">
								<li><a href="#">Khám Phá</a></li>
								<li><a href="#">Phong Cách</a></li>
							</ul>
							<a href="#"><h4>Lựa chọn mỗi li cà phê cho buổi sáng</h4></a>
							<p>
								Vào buổi sáng uống một tách cà phê cùng không gian thoáng đãng, ngắm nhìn phố phường tấp nập, tạo cảm giác thư giãn và thoải mải
							</p>
							<p class="post-date">
								31st January, 2018
							</p>
						</div>
						<div class="col-lg-6 col-md-6 single-blog">
							<img class="img-fluid" src="img/b2.jpg" alt="">
							<ul class="post-tags">
								<li><a href="#">Khám Phá</a></li>
								<li><a href="#">Phong Cách</a></li>
							</ul>
							<a href="#"><h4>Lựa chọn mỗi li cà phê cho buổi sáng</h4></a>
							<p>
								Vào buổi sáng uống một tách cà phê cùng không gian thoáng đãng, ngắm nhìn phố phường tấp nập, tạo cảm giác thư giãn và thoải mải
							</p>
							<p class="post-date">
								31st January, 2018
							</p>
						</div>						
					</div>
				</div>	
			</section>
			<!-- End blog Area -->
			

			<!-- start footer Area -->		
			<footer class="footer-area section-gap">
				<div class="container">
					<div class="row">
						<div class="col-lg-5 col-md-6 col-sm-6">
							<div class="single-footer-widget">
								<h6>Về Chúng Tôi</h6>
								<p>
									Những ý kiến đóng góp của bạn là điều chân quý nhất với chúng tôi để giúp cho chúng tôi có thể chở nên tốt hơn và phục vụ bạn tốt nhất có thể
								</p>
								<p class="footer-text">
									<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
								</p>								
							</div>
						</div>
						<div class="col-lg-5  col-md-6 col-sm-6">
							<div class="single-footer-widget">
								<h6>Đăng ký</h6>
								<p>Nhận những thông tin mới nhất về sản phẩm của chúng tôi</p>
								<div class="" id="mc_embed_signup">
									<form target="_blank" novalidate="true" action="https://spondonit.us12.list-manage.com/subscribe/post?u=1462626880ade1ac87bd9c93a&amp;id=92a4423d01" method="get" class="form-inline">
										<input class="form-control" name="EMAIL" placeholder="Enter Email" onfocus="this.placeholder = ''" onblur="this.placeholder = 'Enter Email '" required="" type="email">
			                            	<button class="click-btn btn btn-default"><i class="fa fa-long-arrow-right" aria-hidden="true"></i></button>
			                            	<div style="position: absolute; left: -5000px;">
												<input name="b_36c4fd991d266f23781ded980_aefe40901a" tabindex="-1" value="" type="text">
											</div>

										<div class="info pt-20"></div>
									</form>
								</div>
							</div>
						</div>						
						<div class="col-lg-2 col-md-6 col-sm-6 social-widget">
							<div class="single-footer-widget">
								<h6>Theo dõi tôi</h6>
								<p>Các trang mạng</p>
								<div class="footer-social d-flex align-items-center">
									<a href="#"><i class="fa fa-facebook"></i></a>
									<a href="#"><i class="fa fa-twitter"></i></a>
									<a href="#"><i class="fa fa-dribbble"></i></a>
									<a href="#"><i class="fa fa-behance"></i></a>
								</div>
							</div>
						</div>							
					</div>
				</div>
			</footer>	
			<!-- End footer Area -->	

			<script src="js/vendor/jquery-2.2.4.min.js"></script>
			<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
			<script src="js/vendor/bootstrap.min.js"></script>			
			<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBhOdIF3Y9382fqJYt5I_sswSrEw5eihAA"></script>
  			<script src="js/easing.min.js"></script>			
			<script src="js/hoverIntent.js"></script>
			<script src="js/superfish.min.js"></script>	
			<script src="js/jquery.ajaxchimp.min.js"></script>
			<script src="js/jquery.magnific-popup.min.js"></script>	
			<script src="js/owl.carousel.min.js"></script>			
			<script src="js/jquery.sticky.js"></script>
			<script src="js/jquery.nice-select.min.js"></script>			
			<script src="js/parallax.min.js"></script>	
			<script src="js/waypoints.min.js"></script>
			<script src="js/jquery.counterup.min.js"></script>					
			<script src="js/mail-script.js"></script>	
			<script src="js/main.js"></script>	
		</body>
	</html>



