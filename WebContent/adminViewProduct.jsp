<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>View Products</title>
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

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

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
	<!-- Start of Product Items List -->
	<div class="container" style="background-color: #FFFFFF;">
		<div class="row text-center">

			
<div class="container1">
    <!--The row displaying most popular items -->
    <div class="row">
        <div class="col-md-12">
            <% 
            String category = request.getParameter("type");

            if (category == null) { %>
                <h2>Most and Least Selling Products</h2>
                <div class="row">
                <h3>Most Popular Items</h3>
                    <% 
                    OrderServiceImpl orderService = new OrderServiceImpl();
                    List<ProductBean> mostSelling = orderService.getMostSellingItems();
                    
                    for (ProductBean product : mostSelling) { %>
                        <div class="col-sm-4" style="height: 350px; overflow-y:auto">
                            <div class="thumbnail">
                                <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                                <p class="productname" style="font-family:Arial, Helvetica, sans-serif;color:black;font-weight:bold"><%=product.getProdName()%> (<%=product.getProdId()%>)</p>
                                <p class="productinfo"><%=product.getProdInfo()%></p>
                                <p class="price" style="color:black; font-size: 15px">$CAD <%=product.getProdPrice()%></p>
                                <form style="background-color:#FFFFFF;" method="post">
                                    <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger"
                                    style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove Product</button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary"
                                    style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Update Product</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>
                <!-- The row displaying least popular items -->
                <div class="row">
                <h3>Least Popular Items</h3>
                    <% 
                    List<ProductBean> leastSelling = orderService.getLeastSellingItems();
                    
                    for (ProductBean product : leastSelling) { %>
                        <div class="col-sm-4" style="height: 350px; overflow-y:auto">
                            <div class="thumbnail">
                                <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                                <p class="productname" style="font-family:Arial, Helvetica, sans-serif;color:black;font-weight:bold"><%=product.getProdName()%> (<%=product.getProdId()%>)</p>
                                <p class="productinfo"><%=product.getProdInfo()%></p>
                                <p class="price" style="color:black; font-size: 15px">$CAD <%=product.getProdPrice()%></p>
                                <form style="background-color:#FFFFFF;" method="post">
                                    <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger"
                                    style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove Product</button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary"
                                    style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Update Product</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } %>
        </div>
    </div>

    <!-- most and least popular selling items by Category -->
    <div class="container">
        <div class="row">
            <% 
            String category4 = request.getParameter("type");

            if (category != null) {
                OrderServiceImpl orderService = new OrderServiceImpl();

                List<ProductBean> mostPopular = orderService.getMostSellingItems(category);
                List<ProductBean> leastPopular = orderService.getLeastSellingItems(category);
            %>

            <h3>Best Selling Items for <%= category %></h3>
            <div class="row">
                <% for (ProductBean product : mostPopular) { %>
                    <div class="col-sm-4" style="height: 350px;">
                        <div class="thumbnail">
                            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                            <p class="productname" style="font-family:Arial, Helvetica, sans-serif;color:black;font-weight:bold"><%=product.getProdName()%> (<%=product.getProdId()%>)</p>
                            <p class="productinfo"><%=product.getProdInfo()%></p>
                            <p class="price" style="color:black; font-size: 15px">$CAD <%=product.getProdPrice()%></p>
                            <form style="background-color:#FFFFFF;" method="post">
                                <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger"
                                style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove Product</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary"
                                style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Update Product</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>

            <h3>Least Selling Items for <%= category %></h3>
            <div class="row">
                <% for (ProductBean product : leastPopular) { %>
                    <div class="col-sm-4" style="height: 350px;">
                        <div class="thumbnail">
                            <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                            <p class="productname" style="font-family:Arial, Helvetica, sans-serif;color:black;font-weight:bold"><%=product.getProdName()%> (<%=product.getProdId()%>)</p>
                            <p class="productinfo"><%=product.getProdInfo()%></p>
                            <p class="price" style="color:black; font-size: 15px">$CAD <%=product.getProdPrice()%></p>
                            <form style="background-color:#FFFFFF;" method="post">
                                <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger"
                                style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove Product</button>
                                &nbsp;&nbsp;&nbsp;
                                <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary"
                                style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Update Product</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
            <% } %>
        </div>
    </div>
</div>
			
			<h3>All products</h3>
			
			<%
			for (ProductBean product : products) {
			%>
			<div class="col-sm-4" style='height: 350px;'>
				<div class="thumbnail">
					<img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product"
						style="height: 150px; max-width: 180px;">
					<p class="productname" style="font-family:Arial,Helvetica,sans-serif;color:black;font-weight:bold"><%=product.getProdName()%>
						(
						<%=product.getProdId()%>
						)
					</p>
					<p class="productinfo"><%=product.getProdInfo()%></p>
					<p class="price" style="color:black; font-size: 15px">
						$CAD
						<%=product.getProdPrice()%>
					</p>
					<form style="background-color:#FFFFFF;" method="post">
						<button type="submit"
							formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>"
							class="btn btn-danger" style="background-color:#CC2A2E;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Remove Product</button>
						&nbsp;&nbsp;&nbsp;
						<button type="submit"
							formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>"
							class="btn btn-primary" style="background-color:#D1940F;border-color:black;border-radius:100px;font-weight:500;box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2);">Update Product</button>
					</form>
				</div>
			</div>

			<%
			}
			%>

		</div>
	</div>
	</div>
	<!-- ENd of Product Items List -->

	<%@ include file="footer.html"%>

</body>
</html>