package com.shopsphere.controller;

import com.shopsphere.dao.ReviewDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;
import com.shopsphere.model.Review;
import com.shopsphere.model.User;
import com.shopsphere.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/product"})
public class ProductServlet extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();

        if ("/product".equals(servletPath)) {
            // Product Details View
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/products");
                return;
            }

            try {
                int productId = Integer.parseInt(idParam);
                Product product = productService.getProductById(productId);
                if (product == null) {
                    resp.sendRedirect(req.getContextPath() + "/products");
                    return;
                }

                List<Review> reviews = reviewDAO.findByProduct(productId);
                req.setAttribute("product", product);
                req.setAttribute("reviews", reviews);
                req.getRequestDispatcher("/product-details.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/products");
            }
        } else {
            // Products Catalog View
            String catParam = req.getParameter("category");
            String keyword = req.getParameter("q");
            String sort = req.getParameter("sort");

            Integer categoryId = null;
            if (catParam != null && !catParam.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(catParam);
                } catch (NumberFormatException ignored) {}
            }

            List<Product> products = productService.searchProducts(categoryId, keyword, sort);
            List<Category> categories = productService.getActiveCategories();

            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.setAttribute("selectedCategory", categoryId);
            req.setAttribute("searchQuery", keyword);
            req.setAttribute("selectedSort", sort);

            req.getRequestDispatcher("/products.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle Review Submission
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=auth_required");
            return;
        }

        String productIdStr = req.getParameter("productId");
        String ratingStr = req.getParameter("rating");
        String reviewText = req.getParameter("reviewText");

        try {
            int productId = Integer.parseInt(productIdStr);
            int rating = Integer.parseInt(ratingStr);

            Review review = new Review();
            review.setUserId(user.getUserId());
            review.setProductId(productId);
            review.setRating(rating);
            review.setReviewText(reviewText);

            reviewDAO.addReview(review);
            resp.sendRedirect(req.getContextPath() + "/product?id=" + productId + "&review=success");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/products");
        }
    }
}
