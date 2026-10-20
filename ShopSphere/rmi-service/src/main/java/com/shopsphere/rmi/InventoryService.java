package com.shopsphere.rmi;

import com.shopsphere.model.Product;

import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * Remote interface for ShopSphere inventory operations across distributed nodes.
 */
public interface InventoryService extends Remote {

    Product getProduct(int productId) throws RemoteException;

    int getStock(int productId) throws RemoteException;

    boolean updateStock(int productId, int quantityDelta) throws RemoteException;
}
