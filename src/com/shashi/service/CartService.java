package com.shashi.service;

import java.util.List;

import com.shashi.beans.CartBean;

public interface CartService {

	public String addProductToCart(String userId, String prodId, int prodQty, boolean used);

	public String updateProductToCart(String userId, String prodId, int prodQty, boolean used);

	public List<CartBean> getAllCartItems(String userId);

	public int getCartCount(String userId);

	public int getCartItemCount(String userId, String itemId, boolean used);

	public String removeProductFromCart(String userId, String prodId, boolean used);

	public boolean removeAProduct(String userId, String prodId, boolean used);

}
