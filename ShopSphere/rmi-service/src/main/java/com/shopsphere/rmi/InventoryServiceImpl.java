package com.shopsphere.rmi;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

/**
 * Remote implementation of InventoryService backed by ProductDAO.
 */
public class InventoryServiceImpl extends UnicastRemoteObject implements InventoryService {

    private static final long serialVersionUID = 1L;
    private final ProductDAO productDAO;

    public InventoryServiceImpl() throws RemoteException {
        super();
        this.productDAO = new ProductDAO();
    }

    @Override
    public Product getProduct(int productId) throws RemoteException {
        System.out.println("[RMI Server] Remote call received: getProduct(" + productId + ")");
        return productDAO.findById(productId);
    }

    @Override
    public int getStock(int productId) throws RemoteException {
        System.out.println("[RMI Server] Remote call received: getStock(" + productId + ")");
        return productDAO.getStock(productId);
    }

    @Override
    public boolean updateStock(int productId, int quantityDelta) throws RemoteException {
        System.out.println("[RMI Server] Remote call received: updateStock(" + productId + ", " + quantityDelta + ")");
        return productDAO.updateStock(productId, quantityDelta);
    }
}
