<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<%@ page import="java.util.Map"%>
<!DOCTYPE html>
<html>
<head>
<title>Home Page</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</head>
<body style="background-color: #FFFFFF;">

	<%
	/* Checking the user credentials */
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
	}

	ProductServiceImpl prodDao = new ProductServiceImpl();
	List<ProductBean> products = new ArrayList<ProductBean>();

	String search = request.getParameter("search");
	String type = request.getParameter("type");
	String message = "All Products";
	if (search != null) {
		products = prodDao.searchAllProducts(search);
		message = "Showing Results for '" + search + "'";
	} else if (type != null) {
		products = prodDao.getAllProductsByType(type);
		message = "Showing Results for '" + type + "'";
	} else {
		products = prodDao.getAllProducts();
	}
	if (products.isEmpty()) {
		message = "No items found for the search '" + (search != null ? search : type) + "'";
		products = prodDao.getAllProducts();
	}
	%>



	<jsp:include page="header.jsp" />

	<div class="text-center"
		style="color: black; font-size: 14px; font-weight: bold;"><%=message%></div>
	<!-- <script>document.getElementById('mycart').innerHTML='<i data-count="20" class="fa fa-shopping-cart fa-3x icon-white badge" style="background-color:#333;margin:0px;padding:0px; margin-top:5px;"></i>'</script>
 -->
	<!-- Start of Product Items List -->
	<div class="container">
		<div class="row text-center">


			<div class="container1">
				<%
				String category = request.getParameter("type");

				if (category == null) {
				%>
				<h2>Recommended for you</h2>
				<% } %>
				<!-- The row displaying most selling products -->
				<div class="row">
					<div class="col-md-12">
						<%
						
						if (category == null) {
						%>
						<h3>Most Popular Items</h3>
						<div class="row">
							<%
							OrderServiceImpl orderService = new OrderServiceImpl();
							ProductServiceImpl productService = new ProductServiceImpl();
							String preference = orderService.getPreferenceByUser(userName);
							List<ProductBean> mostSelling = orderService.getMostSellingItems(preference);

							for (ProductBean product : mostSelling) {
								int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
								int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
							%>
							<div class="col-sm-4" style="max-height: 400px; overflow-y: auto;">
								<div class="thumbnail">
									<img src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product" style="height: 150px; max-width: 180px;">
									<p class="productname"
										style="font-family: Arial, Helvetica, sans-serif; color: black; font-weight: bold"><%=product.getProdName()%>
										(<%=product.getProdId()%>)
									</p>
									<p class="productinfo"><%=product.getProdInfo()%></p>
									<p style="color: black; font-size: 15px;" class="price">

										<%
										if (product.getProdDiscountPrice() > 0) {
										%>
										<span class="newRibbon">DISCOUNT</span> $CAD
										<%=product.getProdDiscountPrice()%>

										<%
										} else {
										%>
										<span class="ribbon">NEW</span> $CAD
										<%=product.getProdPrice()%>
										<%
										}
										;
										%>

										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
										<%=product.getProdUsedPrice()%>
										<%
										}
										%>
									</p>

									<form method="post">
										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										<%
										if ((cartQty > 0 && cartUsedQty == 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>
										<%
										} else if ((cartQty == 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										} else if ((cartQty > 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>
										<%
										} else {
										%>

										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>

										<%
										}
										%>
										<%
										} else {
										%>
										<%
										if (cartQty == 0) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>
										<%
										} else {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										}
										%>
										<%
										}
										%>

									</form>
									<br />
								</div>
							</div>
							<%
							}
							%>
						</div>
						<!-- The row displaying least selling products -->
						<div class="row">
							<h3>Least Popular Items</h3>
							<%
							List<ProductBean> leastSelling = orderService.getLeastSellingItems(preference);

							for (ProductBean product : leastSelling) {
								int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
								int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
							%>
							<div class="col-sm-4" style="height: 400px; overflow-y: auto;">
								<div class="thumbnail">
									<img src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product" style="height: 150px; max-width: 180px;">
									<p class="productname"
										style="font-family: Arial, Helvetica, sans-serif; color: black; font-weight: bold"><%=product.getProdName()%>
										(<%=product.getProdId()%>)
									</p>
									<p class="productinfo"><%=product.getProdInfo()%></p>
									<p style="color: black; font-size: 15px;" class="price">

										<%
										if (product.getProdDiscountPrice() > 0) {
										%>
										<span class="newRibbon">DISCOUNT</span> $CAD
										<%=product.getProdDiscountPrice()%>

										<%
										} else {
										%>
										<span class="ribbon">NEW</span> $CAD
										<%=product.getProdPrice()%>
										<%
										}
										;
										%>

										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
										<%=product.getProdUsedPrice()%>
										<%
										}
										%>
									</p>

									<form method="post">
										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										<%
										if ((cartQty > 0 && cartUsedQty == 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>
										<%
										} else if ((cartQty == 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										} else if ((cartQty > 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>
										<%
										} else {
										%>

										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>

										<%
										}
										%>
										<%
										} else {
										%>
										<%
										if (cartQty == 0) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>
										<%
										} else {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										}
										%>
										<%
										}
										%>

									</form>
									<br />
								</div>
							</div>
							<%
							}
							%>
						</div>
						<!-- The row displaying discounted products -->
						<div class="row">
							<%
							List<ProductBean> discountedProducts = productService.getDiscountedProductsByType(preference);
							if(discountedProducts.isEmpty()){ %>
								<h3>Discounted Items</h3>
								No discounted items in your preferred category.
							<% } else { %>
							<h3>Discounted Items</h3>
							<%		
							for (ProductBean product : discountedProducts) {
								int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
								int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
							%>
							<div class="col-sm-4" style="height: 400px; overflow-y: auto;">
								<div class="thumbnail">
									<img src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product" style="height: 150px; max-width: 180px;">
									<p class="productname"
										style="font-family: Arial, Helvetica, sans-serif; color: black; font-weight: bold"><%=product.getProdName()%>
										(<%=product.getProdId()%>)
									</p>
									<p class="productinfo"><%=product.getProdInfo()%></p>
									<p style="color: black; font-size: 15px;" class="price">

										<%
										if (product.getProdDiscountPrice() > 0) {
										%>
										<span class="newRibbon">DISCOUNT</span> $CAD
										<%=product.getProdDiscountPrice()%>

										<%
										} else {
										%>
										<span class="ribbon">NEW</span> $CAD
										<%=product.getProdPrice()%>
										<%
										}
										;
										%>

										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
										<%=product.getProdUsedPrice()%>
										<%
										}
										%>
									</p>

									<form method="post">
										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										<%
										if ((cartQty > 0 && cartUsedQty == 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>
										<%
										} else if ((cartQty == 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										} else if ((cartQty > 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>
										<%
										} else {
										%>

										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>

										<%
										}
										%>
										<%
										} else {
										%>
										<%
										if (cartQty == 0) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>
										<%
										} else {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										}
										%>
										<%
										}
										%>

									</form>
									<br />
								</div>
							</div>
							<%
							}
							%>
							<%
							}
							%>
						</div>
						<!-- The row displaying used products -->
						<div class="row">
							
							<%
							List<ProductBean> usedProducts = productService.getUsedProductsByType(preference);
							if(usedProducts.isEmpty()){
							%>
								<h3>Used Items</h3>
								No used items in your preferred category.
							<% 
							} else {
							%>
							<h3>Used Items</h3>
							<%
							for (ProductBean product : usedProducts) {
								int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
								int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
							%>
							<div class="col-sm-4" style="height: 400px; overflow-y: auto;">
								<div class="thumbnail">
									<img src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product" style="height: 150px; max-width: 180px;">
									<p class="productname"
										style="font-family: Arial, Helvetica, sans-serif; color: black; font-weight: bold"><%=product.getProdName()%>
										(<%=product.getProdId()%>)
									</p>
									<p class="productinfo"><%=product.getProdInfo()%></p>
									<p style="color: black; font-size: 15px;" class="price">

										<%
										if (product.getProdDiscountPrice() > 0) {
										%>
										<span class="newRibbon">DISCOUNT</span> $CAD
										<%=product.getProdDiscountPrice()%>

										<%
										} else {
										%>
										<span class="ribbon">NEW</span> $CAD
										<%=product.getProdPrice()%>
										<%
										}
										;
										%>

										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
										<%=product.getProdUsedPrice()%>
										<%
										}
										%>
									</p>

									<form method="post">
										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										<%
										if ((cartQty > 0 && cartUsedQty == 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>
										<%
										} else if ((cartQty == 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										} else if ((cartQty > 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>
										<%
										} else {
										%>

										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>

										<%
										}
										%>
										<%
										} else {
										%>
										<%
										if (cartQty == 0) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>
										<%
										} else {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										}
										%>
										<%
										}
										%>

									</form>
									<br />
								</div>
							</div>
							<%
							}
							%>
							<%
							}
							%>
							
						</div>
						<%
						}
						%>
					</div>
				</div>

				<!-- 
				<!-- Best and Least popular by Category 
				<div class="container">

					<div class="row">
						<%
						String category5 = request.getParameter("type");

						if (category != null) {
							OrderServiceImpl orderService = new OrderServiceImpl();

							List<ProductBean> mostPopular = orderService.getMostSellingItems(category);
							List<ProductBean> leastPopular = orderService.getLeastSellingItems(category);
						%>

						<h3>
							Most Popular Items For
							<%=category%></h3>
						<div class="row">
							<%
							for (ProductBean product : mostPopular) {
								int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
								int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
							%>
							<div class="col-sm-4" style="height: 350px;">
								<div class="thumbnail">
									<img src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product" style="height: 150px; max-width: 180px;">
									<p class="productname"
										style="font-family: Arial, Helvetica, sans-serif; color: black; font-weight: bold"><%=product.getProdName()%>
										(<%=product.getProdId()%>)
									</p>
									<p class="productinfo"><%=product.getProdInfo()%></p>
									<p style="color: black; font-size: 15px;" class="price">

										<%
										if (product.getProdDiscountPrice() > 0) {
										%>
										<span class="newRibbon">DISCOUNT</span> $CAD
										<%=product.getProdDiscountPrice()%>

										<%
										} else {
										%>
										<span class="ribbon">NEW</span> $CAD
										<%=product.getProdPrice()%>
										<%
										}
										;
										%>

										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
										<%=product.getProdUsedPrice()%>
										<%
										}
										%>
									</p>

									<form method="post">
										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										<%
										if ((cartQty > 0 && cartUsedQty == 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>
										<%
										} else if ((cartQty == 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										} else if ((cartQty > 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>
										<%
										} else {
										%>

										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>

										<%
										}
										%>
										<%
										} else {
										%>
										<%
										if (cartQty == 0) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>
										<%
										} else {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										}
										%>
										<%
										}
										%>

									</form>
									<br />
								</div>
							</div>
							<%
							}
							%>
						</div>

						<h3>
							Least Popular Items For
							<%=category%></h3>
						<div class="row">
							<%
							for (ProductBean product : leastPopular) {
								int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
								int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
							%>
							<div class="col-sm-4" style="height: 350px;">
								<div class="thumbnail">
									<img src="./ShowImage?pid=<%=product.getProdId()%>"
										alt="Product" style="height: 150px; max-width: 180px;">
									<p class="productname"
										style="font-family: Arial, Helvetica, sans-serif; color: black; font-weight: bold"><%=product.getProdName()%>
										(<%=product.getProdId()%>)
									</p>
									<p class="productinfo"><%=product.getProdInfo()%></p>
									<p style="color: black; font-size: 15px;" class="price">

										<%
										if (product.getProdDiscountPrice() > 0) {
										%>
										<span class="newRibbon">DISCOUNT</span> $CAD
										<%=product.getProdDiscountPrice()%>

										<%
										} else {
										%>
										<span class="ribbon">NEW</span> $CAD
										<%=product.getProdPrice()%>
										<%
										}
										;
										%>

										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
										<%=product.getProdUsedPrice()%>
										<%
										}
										%>
									</p>

									<form method="post">
										<%
										if (product.getProdUsedQuantity() > 0) {
										%>
										<%
										if ((cartQty > 0 && cartUsedQty == 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>
										<%
										} else if ((cartQty == 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										} else if ((cartQty > 0 && cartUsedQty > 0)) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>
										<%
										} else {
										%>

										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>

										&nbsp;&nbsp;&nbsp;
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
											class="btn btn-primary"
											style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											Used to Cart</button>

										<%
										}
										%>
										<%
										} else {
										%>
										<%
										if (cartQty == 0) {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
											class="btn btn-success"
											style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
											to Cart</button>
										<%
										} else {
										%>
										<button type="submit"
											formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
											class="btn btn-danger"
											style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
											From Cart</button>

										<%
										}
										%>
										<%
										}
										%>

									</form>
									<br />
								</div>
							</div>
							<%
							}
							%>
						</div>
						<%
						}
						%>
					</div>
				</div>
				 -->
			</div>
			<h3>All products available</h3>




			<%
			for (ProductBean product : products) {
				int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
				int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
			%>
			<div class="col-sm-4" style='height: 350px;'>
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px">
					<p
						style="color: black; font-family: Arial, Helvetica, sans-serif; font-weight: bold;"
						class="productname"><%=product.getProdName()%><%=cartQty%>
					</p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 100));
					%>
					<p class="productinfo"><%=description%>..
					</p>

					<p style="color: black; font-size: 15px;" class="price">

						<%
						if (product.getProdDiscountPrice() > 0) {
						%>
						<span class="newRibbon">DISCOUNT</span> $CAD
						<%=product.getProdDiscountPrice()%>

						<%
						} else {
						%>
						<span class="ribbon">NEW</span> $CAD
						<%=product.getProdPrice()%>
						<%
						}
						;
						%>

						<%
						if (product.getProdUsedQuantity() > 0) {
						%>
						&nbsp;&nbsp;&nbsp; <span class="ribbon">USED</span> $CAD
						<%=product.getProdUsedPrice()%>
						<%
						}
						%>
					</p>

					<form method="post">
						<%
						if (product.getProdUsedQuantity() > 0) {
						%>
						<%
						if ((cartQty > 0 && cartUsedQty == 0)) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
							class="btn btn-danger"
							style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
							From Cart</button>

						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
							class="btn btn-primary"
							style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
							Used to Cart</button>
						<%
						} else if ((cartQty == 0 && cartUsedQty > 0)) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
							class="btn btn-success"
							style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
							to Cart</button>

						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
							class="btn btn-danger"
							style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
							From Cart</button>

						<%
						} else if ((cartQty > 0 && cartUsedQty > 0)) {
						%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
							class="btn btn-danger"
							style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
							From Cart</button>

						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
							class="btn btn-danger"
							style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
							From Cart</button>
						<%
						} else {
						%>

						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
							class="btn btn-success"
							style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
							to Cart</button>

						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
							class="btn btn-primary"
							style="background-color: #D1940F; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
							Used to Cart</button>

						<%
							}
							%>
						<%
						}else{	
						%>
						<%
							if (cartQty == 0) {
							%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
							class="btn btn-success"
							style="background-color: #912238; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add
							to Cart</button>
						<%
							} else {
							%>
						<button type="submit"
							formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
							class="btn btn-danger"
							style="background-color: #A9A9A9; border-color: black; border-radius: 100px; font-weight: 500; box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove
							From Cart</button>

						<%
							}
							%>
						<%
						}
						%>

					</form>
					<br />
				</div>
			</div>

			<%
			}
			%>

		</div>
	</div>
	<!-- ENd of Product Items List -->


	<%@ include file="footer.html"%>

</body>
</html>
