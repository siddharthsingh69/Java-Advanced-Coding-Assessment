package com.shopsphere.rmi;

import com.shopsphere.model.Product;

import java.rmi.Naming;

/**
 * Demonstrates looking up the RMI service from the registry and executing remote methods.
 */
public class RmiInventoryClient {

    public static void main(String[] args) {
        String serviceUrl = "rmi://localhost:1099/InventoryService";
        try {
            System.out.println("[RMI Client] Looking up remote service at: " + serviceUrl);
            InventoryService service = (InventoryService) Naming.lookup(serviceUrl);

            System.out.println("[RMI Client] Successfully obtained remote stub reference!");

            // Test 1: Fetch product
            int testProductId = 1;
            System.out.println("\n[RMI Client] Calling remote method: getProduct(" + testProductId + ")...");
            Product p = service.getProduct(testProductId);
            if (p != null) {
                System.out.println(">>> Remote Result: Found Product -> " + p.getName() + " | Price: ₹" + p.getPrice() + " | Stock: " + p.getStock());
            } else {
                System.out.println(">>> Remote Result: Product not found.");
            }

            // Test 2: Fetch stock
            System.out.println("\n[RMI Client] Calling remote method: getStock(" + testProductId + ")...");
            int stock = service.getStock(testProductId);
            System.out.println(">>> Remote Result: Current Stock -> " + stock);

            // Test 3: Update stock (e.g., add 5)
            System.out.println("\n[RMI Client] Calling remote method: updateStock(" + testProductId + ", +5)...");
            boolean updated = service.updateStock(testProductId, 5);
            System.out.println(">>> Remote Result: Stock update success -> " + updated);

            int newStock = service.getStock(testProductId);
            System.out.println(">>> Remote Result: Verified New Stock -> " + newStock);

            System.out.println("\n[RMI Client] All remote method invocations completed successfully!");

        } catch (Exception e) {
            System.err.println("[RMI Client] Remote call failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
