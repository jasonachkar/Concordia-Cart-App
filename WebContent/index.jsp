<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Concordia Cart Home Page</title>
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
	String userType = (String) session.getAttribute("usertype");

	boolean isValidUser = true;

	if (userType == null || userName == null || password == null || !userType.equals("customer")) {

		isValidUser = false;
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
	<div class="text-center" id="message"
		style="color: black; font-size: 14px; font-weight: bold;"></div>
	<!-- Start of Product Items List -->
				<div class="container">
					<div class="row text-center">
					<h3>All products</h3>
		
			<%
			for (ProductBean product : products) {
				int cartQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), false);
				int cartUsedQty = new CartServiceImpl().getCartItemCount(userName, product.getProdId(), true);
			%>
			<div class="col-sm-4" style='height: 350px;'>
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px">

					<p style="color:black;font-family:Arial,Helvetica,sans-serif; font-weight:bold;" class="productname"><%=product.getProdName()%>

					</p>
					<%
					String description = product.getProdInfo();
					description = description.substring(0, Math.min(description.length(), 100));
					%>
					<p class="productinfo"><%=description%>..
					</p>

					<p style="color: black; font-size: 15px;" class="price">
				
						<%
							if(product.getProdDiscountPrice() > 0)  {
							%>
							<span class="newRibbon">DISCOUNT</span> $CAD
							<%=product.getProdDiscountPrice()%>
							
							<%
							}else{
							%>
								<span class="ribbon">NEW</span> $CAD
								<%=product.getProdPrice()%>
							<%	
							};
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
						if (product.getProdUsedQuantity()>0) {
						%>
							<%
							if((cartQty > 0 && cartUsedQty == 0)){
							%>
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
								class="btn btn-danger" style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove From Cart</button>

								&nbsp;&nbsp;&nbsp;
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
								class="btn btn-primary" style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add Used to Cart</button>
							<%
							}else if((cartQty == 0 && cartUsedQty > 0)){
							%>
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
								class="btn btn-success" style="background-color:#912238;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add to Cart</button>

								&nbsp;&nbsp;&nbsp;
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
								class="btn btn-danger" style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove From Cart</button>

							<%
							}else if((cartQty > 0 && cartUsedQty > 0)){
							%>
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
								class="btn btn-danger" style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove From Cart</button>

								&nbsp;&nbsp;&nbsp;
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=true"
								class="btn btn-danger" style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove From Cart</button>
							<%
							}else  {
							%>
							
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=false"
								class="btn btn-success" style="background-color:#912238;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add to Cart</button>

								&nbsp;&nbsp;&nbsp;
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=1&used=true"
								class="btn btn-primary" style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add Used to Cart</button>

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
								class="btn btn-success" style="background-color:#912238;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Add to Cart</button>
							<%
							} else {
							%>
								<button type="submit"
								formaction="./AddtoCart?uid=<%=userName%>&pid=<%=product.getProdId()%>&pqty=0&used=false"
								class="btn btn-danger" style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove From Cart</button>

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
