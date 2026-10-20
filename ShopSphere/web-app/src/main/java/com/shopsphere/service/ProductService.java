package com.shopsphere.service;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Product;

import java.util.List;

public class ProductService {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    public List<Product> getAllActiveProducts() {
        return productDAO.findAllActive();
    }

    public List<Category> getActiveCategories() {
        return categoryDAO.findAllActive();
    }

    public Product getProductById(int productId) {
        return productDAO.findById(productId);
    }

    public List<Product> searchProducts(Integer categoryId, String keyword, String sortBy) {
        return productDAO.searchAndFilter(categoryId, keyword, sortBy);
    }

    public boolean updateStock(int productId, int quantityDelta) {
        return productDAO.updateStock(productId, quantityDelta);
    }
}
