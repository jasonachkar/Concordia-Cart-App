package com.shashi.beans;

import java.io.Serializable;

@SuppressWarnings("serial")
public class CartBean implements Serializable {

	public CartBean() {
	}

	public String userId;
	public String prodId;
	public int quantity;
	public boolean used;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProdId() {
		return prodId;
	}

	public void setProdId(String prodId) {
		this.prodId = prodId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	
	public boolean isUsed() {
		return used;
	}

	public void setUsed(boolean used) {
		this.used = used;
	}
	
	public CartBean(String userId, String prodId, int quantity) {
		super();
		this.userId = userId;
		this.prodId = prodId;
		this.quantity = quantity;
		this.used = false;
	}
	
	public CartBean(String userId, String prodId, int quantity, boolean used) {
		super();
		this.userId = userId;
		this.prodId = prodId;
		this.quantity = quantity;
		this.used = used;
	}
	


}
