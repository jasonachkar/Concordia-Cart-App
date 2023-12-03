<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page
	import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Admin Home</title>
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
<body style="background-color: #E6F9E6;">
	<%
	/* Checking the user credentials */
	String userType = (String) session.getAttribute("usertype");
	String userName = (String) session.getAttribute("username");
	String password = (String) session.getAttribute("password");

	if (userType == null || !userType.equals("admin")) {

		response.sendRedirect("login.jsp?message=Access Denied, Login as admin!!");

	}

	else if (userName == null || password == null) {

		response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");

	}
	%>
	<jsp:include page="header.jsp" />
	
		<div class="container1">
    <h2>Most and Least Selling Products</h2>
    <!--The row displaying most selling items -->
    <div class="row">
        <div class="col-md-12">
            <h3>Most popular Items</h3>
            <div class="row">
                <% 
                    OrderServiceImpl orderService = new OrderServiceImpl();
                    List<ProductBean> mostSelling = orderService.getMostSellingItems();
                    
                    for (ProductBean product : mostSelling) { %>
                        <div class="col-sm-4" style="height: 350px;">
                            <div class="thumbnail">
                                <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                                <p style="color: black; font-family: Arial, Helvetica, sans-serif; font-weight: bold;" class="productname"><%=product.getProdName()%></p>
                                <%
                                    String desc = product.getProdInfo();
                                    desc = desc.substring(0, Math.min(desc.length(), 100));
                                %>
                                <p class="productinfo"><%=desc%>..</p>
                                <p style="color: black; font-size: 15px;" class="price">$CAD <%=product.getProdPrice()%></p>
                                
                                <!-- Buttons for removing and updating products -->
                                <form style="background-color:#FFFFFF;" method="post">
                                    <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger">Remove Product</button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary">Update Product</button>
                                </form>
                            </div>
                        </div>
                <% 
                } 
                %>
            </div>
        </div>
    </div>

    <!-- The row displaying least selling products -->
    <div class="row">
        <div class="col-md-12">
            <h3>Least popular Items</h3>
            <div class="row">
                <% 
                    List<ProductBean> leastSelling = orderService.getLeastSellingItems();
                    
                    for (ProductBean product : leastSelling) { %>
                        <div class="col-sm-4" style="height: 350px;">
                            <div class="thumbnail">
                                <img src="./ShowImage?pid=<%=product.getProdId()%>" alt="Product" style="height: 150px; max-width: 180px;">
                                <p style="color: black; font-family: Arial, Helvetica, sans-serif; font-weight: bold;" class="productname"><%=product.getProdName()%></p>
                                <%
                                    String desc = product.getProdInfo();
                                    desc = desc.substring(0, Math.min(desc.length(), 100));
                                %>
                                <p class="productinfo"><%=desc%>..</p>
                                <p style="color: black; font-size: 15px;" class="price">$CAD <%=product.getProdPrice()%></p>
                                
                                <!-- Buttons for removing and updating products -->
                                <form style="background-color:#FFFFFF;" method="post">
                                    <button type="submit" formaction="./RemoveProductSrv?prodid=<%=product.getProdId()%>" class="btn btn-danger">Remove Product</button>
                                    &nbsp;&nbsp;&nbsp;
                                    <button type="submit" formaction="updateProduct.jsp?prodid=<%=product.getProdId()%>" class="btn btn-primary">Update Product</button>
                                </form>
                            </div>
                        </div>
                <% 
                } 
                %>
            </div>
        </div>
    </div>
</div>
		
			
			
			<h3>All products available</h3>

	<div class="products" style="background-color: #E6F9E6;">

		<div class="tab" align="center">
			<form>
				<button type="submit" formaction="adminViewProduct.jsp">View
					products</button>
				<br>
				<br>
				<button type="submit" formaction="addProduct.jsp">Add
					products</button>
				<br>
				<br>
				<button type="submit" formaction="removeProduct.jsp">Remove
					Products</button>
				<br>
				<br>
				<button type="submit" formaction="updateProductById.jsp">Update
					Products</button>
				<br>
				<br>
			</form>
		</div>
	</div>

	<%@ include file="footer.html"%>
</body>
</html>