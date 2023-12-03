package com.shashi.service.impl;

import static org.junit.jupiter.api.Assertions.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import org.junit.jupiter.api.Test;
import com.shashi.beans.ProductBean;
import com.shashi.utility.DBUtil;

class ProductServiceImplTest
{
	@Test
	void testSellNUsedProduct()
	{
		ProductServiceImpl psi = new ProductServiceImpl();
		String pid = "P20230423082243";
		int old_quantity = psi.getUsedProductQuantity(pid);
		psi.sellNUsedProduct(pid, 3); // Remove 3
		int new_quantity = psi.getUsedProductQuantity(pid);
		System.out.println(old_quantity);
		System.out.println(new_quantity);
		assertTrue(new_quantity == old_quantity - 3);
	}

	@Test
	void testGetLowStockProducts()
	{
		ProductServiceImpl psi = new ProductServiceImpl();
        List<ProductBean> l = psi.getLowStockProducts();
        Iterator<ProductBean> i = l.iterator();
        while (i.hasNext())
        {
            assertTrue((i.next()).getProdQuantity() <= 3);
        }
	}
}
