package com.shashi.service.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.shashi.beans.CartBean;
import com.shashi.beans.OrderBean;
import com.shashi.beans.OrderDetails;
import com.shashi.beans.ProductBean;
import com.shashi.beans.TransactionBean;
import com.shashi.service.OrderService;
import com.shashi.utility.DBUtil;
import com.shashi.utility.MailMessage;

public class OrderServiceImpl implements OrderService {

	@Override
	public String paymentSuccess(String userName, double paidAmount) {
		String status = "Order Placement Failed!";

		List<CartBean> cartItems = new ArrayList<CartBean>();
		cartItems = new CartServiceImpl().getAllCartItems(userName);

		if (cartItems.size() == 0)
			return status;

		TransactionBean transaction = new TransactionBean(userName, paidAmount);
		boolean ordered = false;

		String transactionId = transaction.getTransactionId();

		// System.out.println("Transaction: "+transaction.getTransactionId()+"
		// "+transaction.getTransAmount()+" "+transaction.getUserName()+"
		// "+transaction.getTransDateTime());

		for (CartBean item : cartItems) {

			ProductBean product = new ProductServiceImpl().getProductDetails(item.getProdId());
			boolean used = item.isUsed();			
			double discount =  product.getProdDiscountPrice();
			
			double pprice;
			
			if (used){
				pprice = product.getProdUsedPrice();
			} else if (discount > 0){
				pprice = discount;
			} else {
				pprice = product.getProdPrice() ;
			}
			
			double amount = pprice * item.getQuantity();

			OrderBean order = new OrderBean(transactionId, item.getProdId(), item.getQuantity(), amount, 0, used);

			ordered = addOrder(order);
			if (!ordered)
				break;
			else {
				ordered = new CartServiceImpl().removeAProduct(item.getUserId(), item.getProdId(), used);
			}

			if (!ordered)
				break;
			else
				if (used) {
					ordered = new ProductServiceImpl().sellNUsedProduct(item.getProdId(), item.getQuantity());
				}else {
					ordered = new ProductServiceImpl().sellNProduct(item.getProdId(), item.getQuantity());
				}
			if (!ordered)
				break;
		}

		if (ordered) {
			ordered = new OrderServiceImpl().addTransaction(transaction);
			if (ordered) {

				MailMessage.transactionSuccess(userName, new UserServiceImpl().getFName(userName),
						transaction.getTransactionId(), transaction.getTransAmount());

				status = "Order Placed Successfully!";
			}
		}

		return status;
	}

	@Override
	public boolean addOrder(OrderBean order) {
		boolean flag = false;

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;

		try {
			ps = con.prepareStatement("insert into orders values(?,?,?,?,?,?)");

			ps.setString(1, order.getTransactionId());
			ps.setString(2, order.getProductId());
			ps.setInt(3, order.getQuantity());
			ps.setDouble(4, order.getAmount());
			ps.setInt(5, 0);
			ps.setBoolean(6, order.isUsed());

			int k = ps.executeUpdate();

			if (k > 0)
				flag = true;

		} catch (SQLException e) {
			flag = false;
			e.printStackTrace();
		}

		return flag;
	}

	@Override
	public boolean addTransaction(TransactionBean transaction) {
		boolean flag = false;

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;

		try {
			ps = con.prepareStatement("insert into transactions values(?,?,?,?)");

			ps.setString(1, transaction.getTransactionId());
			ps.setString(2, transaction.getUserName());
			ps.setTimestamp(3, transaction.getTransDateTime());
			ps.setDouble(4, transaction.getTransAmount());

			int k = ps.executeUpdate();

			if (k > 0)
				flag = true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return flag;
	}

	@Override
	public int countSoldItem(String prodId) {
		int count = 0;

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;

		ResultSet rs = null;

		try {
			ps = con.prepareStatement("select sum(quantity) from orders where prodid=?");

			ps.setString(1, prodId);

			rs = ps.executeQuery();

			if (rs.next())
				count = rs.getInt(1);

		} catch (SQLException e) {
			count = 0;
			e.printStackTrace();
		}

		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);
		DBUtil.closeConnection(rs);

		return count;
	}

	@Override
	public List<OrderBean> getAllOrders() {
		List<OrderBean> orderList = new ArrayList<OrderBean>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement("select * from orders");

			rs = ps.executeQuery();

			while (rs.next()) {

				OrderBean order = new OrderBean(rs.getString("orderid"), rs.getString("prodid"), rs.getInt("quantity"),
						rs.getDouble("amount"), rs.getInt("shipped"), rs.getBoolean("used"));

				orderList.add(order);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return orderList;
	}

	@Override
	public List<OrderBean> getOrdersByUserId(String emailId) {
		List<OrderBean> orderList = new ArrayList<OrderBean>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT * FROM orders o inner join transactions t on o.orderid = t.transid where username=?");
			ps.setString(1, emailId);
			rs = ps.executeQuery();

			while (rs.next()) {

				OrderBean order = new OrderBean(rs.getString("t.transid"), rs.getString("t.prodid"),
						rs.getInt("quantity"), rs.getDouble("t.amount"), rs.getInt("shipped"), rs.getBoolean("used"));

				orderList.add(order);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return orderList;
	}

	@Override
	public List<OrderDetails> getAllOrderDetails(String userEmailId) {
		List<OrderDetails> orderList = new ArrayList<OrderDetails>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT  p.pid as prodid, o.orderid as orderid, o.shipped as shipped, o.used as used, p.image as image, p.pname as pname, o.quantity as qty, o.amount as amount, t.time as time FROM orders o, product p, transactions t where o.orderid=t.transid and o.orderid = t.transid and p.pid=o.prodid and t.username=?");
			ps.setString(1, userEmailId);
			rs = ps.executeQuery();

			while (rs.next()) {

				OrderDetails order = new OrderDetails();
				order.setOrderId(rs.getString("orderid"));
				order.setProdImage(rs.getAsciiStream("image"));
				order.setProdName(rs.getString("pname"));
				order.setQty(rs.getString("qty"));
				order.setAmount(rs.getString("amount"));
				order.setTime(rs.getTimestamp("time"));
				order.setProductId(rs.getString("prodid"));
				order.setShipped(rs.getInt("shipped"));
				order.setUsed(rs.getBoolean("used"));
				orderList.add(order);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}

		return orderList;
	}

	@Override
	public String shipNow(String orderId, String prodId) {
		String status = "FAILURE";

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;

		try {
			ps = con.prepareStatement("update orders set shipped=1 where orderid=? and prodid=? and shipped=0");

			ps.setString(1, orderId);
			ps.setString(2, prodId);

			int k = ps.executeUpdate();

			if (k > 0) {
				status = "Order Has been shipped successfully!!";
			}

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);

		return status;
	}
	
	public String getPreferenceByUser(String emailId) {
		String type = "";

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT SUM(o.quantity) AS qty, p.ptype FROM orders o INNER JOIN  transactions t ON o.orderid = t.transid INNER JOIN product p ON p.pid = o.prodid WHERE t.username=? GROUP BY p.ptype ORDER BY qty DESC LIMIT 1");
			ps.setString(1, emailId);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				type = rs.getString("p.ptype");
			}
			

		} catch (SQLException e) {

			e.printStackTrace();
		}
		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);
		
		return type;
	}
	
	
	public List<ProductBean> getMostSellingItems() {
		
		List<ProductBean> productList = new ArrayList<ProductBean>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT  p.* FROM product p LEFT JOIN orders o ON p.pid = o.prodid GROUP BY p.pid, p.pname, p.ptype, p.pinfo, p.pprice, p.pquantity, p.image, p.usedpquantity, p.usedpprice, p.discountpprice ORDER BY SUM(o.quantity) DESC LIMIT 3");
			rs = ps.executeQuery();

			while (rs.next()) {

				ProductBean product = new ProductBean();
				product.setProdId(rs.getString("pid"));
				product.setProdName(rs.getString("pname"));
				product.setProdType(rs.getString("ptype"));
				product.setProdInfo(rs.getString("pinfo"));
				product.setProdPrice(rs.getDouble("pprice"));
				product.setProdQuantity(rs.getInt("pquantity"));
				product.setProdImage(rs.getAsciiStream("image"));
				product.setProdUsedQuantity(rs.getInt("usedpquantity"));
				product.setProdUsedPrice(rs.getDouble("usedpprice"));
				product.setProdDiscountPrice(rs.getDouble("discountpprice"));
				productList.add(product);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}
		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);

		return productList;
				
	}
	
	public List<ProductBean> getMostSellingItems(String type){
		
		List<ProductBean> productList = new ArrayList<ProductBean>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT  p.* FROM product p LEFT JOIN orders o ON p.pid = o.prodid WHERE p.ptype=? GROUP BY p.pid, p.pname, p.ptype, p.pinfo, p.pprice, p.pquantity, p.image, p.usedpquantity, p.usedpprice, p.discountpprice ORDER BY SUM(o.quantity) DESC LIMIT 3");
			ps.setString(1, type);
			rs = ps.executeQuery();

			while (rs.next()) {

				ProductBean product = new ProductBean();
				product.setProdId(rs.getString("pid"));
				product.setProdName(rs.getString("pname"));
				product.setProdType(rs.getString("ptype"));
				product.setProdInfo(rs.getString("pinfo"));
				product.setProdPrice(rs.getDouble("pprice"));
				product.setProdQuantity(rs.getInt("pquantity"));
				product.setProdImage(rs.getAsciiStream("image"));
				product.setProdUsedQuantity(rs.getInt("usedpquantity"));
				product.setProdUsedPrice(rs.getDouble("usedpprice"));
				product.setProdDiscountPrice(rs.getDouble("discountpprice"));
				productList.add(product);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}
		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);

		return productList;
	}
	
	public List<ProductBean> getLeastSellingItems(){
		
		List<ProductBean> productList = new ArrayList<ProductBean>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT  p.* FROM product p LEFT JOIN orders o ON p.pid = o.prodid GROUP BY p.pid, p.pname, p.ptype, p.pinfo, p.pprice, p.pquantity, p.image, p.usedpquantity, p.usedpprice, p.discountpprice ORDER BY SUM(o.quantity) LIMIT 3");
			rs = ps.executeQuery();

			while (rs.next()) {

				ProductBean product = new ProductBean();
				product.setProdId(rs.getString("pid"));
				product.setProdName(rs.getString("pname"));
				product.setProdType(rs.getString("ptype"));
				product.setProdInfo(rs.getString("pinfo"));
				product.setProdPrice(rs.getDouble("pprice"));
				product.setProdQuantity(rs.getInt("pquantity"));
				product.setProdImage(rs.getAsciiStream("image"));
				product.setProdUsedQuantity(rs.getInt("usedpquantity"));
				product.setProdUsedPrice(rs.getDouble("usedpprice"));
				product.setProdDiscountPrice(rs.getDouble("discountpprice"));
				productList.add(product);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}
		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);

		return productList;
	}
	
	public List<ProductBean> getLeastSellingItems(String type){
		
		List<ProductBean> productList = new ArrayList<ProductBean>();

		Connection con = DBUtil.provideConnection();

		PreparedStatement ps = null;
		ResultSet rs = null;

		try {

			ps = con.prepareStatement(
					"SELECT  p.* FROM product p LEFT JOIN orders o ON p.pid = o.prodid WHERE p.ptype=? GROUP BY p.pid, p.pname, p.ptype, p.pinfo, p.pprice, p.pquantity, p.image, p.usedpquantity, p.usedpprice, p.discountpprice ORDER BY SUM(o.quantity) LIMIT 3");
			ps.setString(1, type);
			rs = ps.executeQuery();

			while (rs.next()) {

				ProductBean product = new ProductBean();
				product.setProdId(rs.getString("pid"));
				product.setProdName(rs.getString("pname"));
				product.setProdType(rs.getString("ptype"));
				product.setProdInfo(rs.getString("pinfo"));
				product.setProdPrice(rs.getDouble("pprice"));
				product.setProdQuantity(rs.getInt("pquantity"));
				product.setProdImage(rs.getAsciiStream("image"));
				product.setProdUsedQuantity(rs.getInt("usedpquantity"));
				product.setProdUsedPrice(rs.getDouble("usedpprice"));
				product.setProdDiscountPrice(rs.getDouble("discountpprice"));
				productList.add(product);

			}

		} catch (SQLException e) {

			e.printStackTrace();
		}
		DBUtil.closeConnection(con);
		DBUtil.closeConnection(ps);

		return productList; 
	}


}
