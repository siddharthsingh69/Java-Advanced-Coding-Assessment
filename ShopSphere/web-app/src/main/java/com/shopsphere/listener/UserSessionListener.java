package com.shopsphere.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class UserSessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        AtomicInteger active = (AtomicInteger) context.getAttribute("activeUsers");
        if (active != null) {
            int current = active.incrementAndGet();
            System.out.println("[ShopSphere] Session created: " + se.getSession().getId() + " | Active sessions: " + current);
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        AtomicInteger active = (AtomicInteger) context.getAttribute("activeUsers");
        if (active != null) {
            int current = active.decrementAndGet();
            System.out.println("[ShopSphere] Session destroyed: " + se.getSession().getId() + " | Active sessions: " + current);
        }
    }
}
