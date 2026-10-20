package com.shopsphere.filter;

import com.shopsphere.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/cart", "/cart/*",
    "/checkout", "/checkout/*",
    "/orders", "/orders/*",
    "/profile", "/profile/*",
    "/wishlist", "/wishlist/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            String target = req.getRequestURI();
            String query = req.getQueryString();
            if (query != null) {
                target += "?" + query;
            }
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=auth_required&redirect=" + java.net.URLEncoder.encode(target, "UTF-8"));
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
