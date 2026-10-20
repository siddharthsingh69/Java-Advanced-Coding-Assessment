package com.shopsphere.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        context.setAttribute("appName", "ShopSphere");
        context.setAttribute("activeUsers", new AtomicInteger(0));
        System.out.println("[ShopSphere] Web Application context initialized successfully on Apache Tomcat.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[ShopSphere] Web Application context destroyed.");
    }
}
