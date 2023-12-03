package com.shashi.service.impl;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Iterator;
import java.util.List;

import org.junit.jupiter.api.Test;

import com.shashi.beans.CartBean;

class CartServiceImplTest
{

	@Test
	void testAddProductToCart()
	{
		CartServiceImpl csi = new CartServiceImpl();
		int before = csi.getCartItemCount("guest@gmail.com", "P20230423082243", true);
		csi.addProductToCart("guest@gmail.com", "P20230423082243", 2, true);
		int after = csi.getCartItemCount("guest@gmail.com", "P20230423082243", true);
		assertTrue(after == before + 2);
	}

	@Test
	void testUpdateProductToCart()
	{
		CartServiceImpl csi = new CartServiceImpl();
		csi.updateProductToCart("guest@gmail.com", "P20230423083830", 7, false);
		int after = csi.getProductCount("guest@gmail.com", "P20230423083830", false);
		assertTrue(after == 7);
		csi.updateProductToCart("guest@gmail.com", "P20230423083830", 0, false);
		List<CartBean> l = csi.getAllCartItems("guest@gmail.com");
		Iterator<CartBean> i = l.iterator();
		while (i.hasNext())
		{
			CartBean cb = i.next();
			if (cb.prodId.equals("P20230423083830"))
				assertTrue(false);
		}
	}
}
