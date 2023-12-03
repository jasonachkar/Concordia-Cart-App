package com.shashi.service.impl;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Iterator;
import java.util.List;

import org.junit.jupiter.api.Test;

import com.shashi.beans.ProductBean;

class OrderServiceImplTest
{
	@Test
	void testGetPreferenceByUser()
	{
		String[] types = {"mobile", "laptop", "tv", "camera", "speaker", "tablet", "fan", "cooler"};
        OrderServiceImpl osi = new OrderServiceImpl();
        String type_guest = osi.getPreferenceByUser("guest@gmail.com");
        boolean flag = false;
        for (String s : types)
        {
        	if (s.equals(type_guest))
        		flag = true;
        }
        
        assertTrue(flag);
	}

	@Test
	void testGetMostSellingItems()
	{
		OrderServiceImpl osi = new OrderServiceImpl();
        List<ProductBean> l = osi.getMostSellingItems();
        assertTrue(l.size() > 0);
	}

	@Test
	void testGetMostSellingItemsString()
	{
		OrderServiceImpl osi = new OrderServiceImpl();
        List<ProductBean> l = osi.getMostSellingItems("mobile");
        Iterator<ProductBean> i = l.iterator();
        boolean flag = true;
        while (i.hasNext())
        {
        	if (!((i.next().getProdType()).equals("mobile")))
        	{
        		flag = false;
        	}
        }
        assertTrue(flag && l.size() > 0);
	}

	@Test
	void testGetLeastSellingItems()
	{
		OrderServiceImpl osi = new OrderServiceImpl();
        List<ProductBean> l = osi.getMostSellingItems();
        assertTrue(l.size() > 0);
	}

	@Test
	void testGetLeastSellingItemsString()
	{
		OrderServiceImpl osi = new OrderServiceImpl();
        List<ProductBean> l = osi.getMostSellingItems("mobile");
        Iterator<ProductBean> i = l.iterator();
        boolean flag = true;
        while (i.hasNext())
        {
        	if (!((i.next().getProdType()).equals("mobile")))
        	{
        		flag = false;
        	}
        }
        assertTrue(flag && l.size() > 0);
	}
}
