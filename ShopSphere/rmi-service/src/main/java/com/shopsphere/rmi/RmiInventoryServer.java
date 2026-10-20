package com.shopsphere.rmi;

import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

/**
 * Starts the RMI registry and exports the InventoryService.
 */
public class RmiInventoryServer {

    public static final int REGISTRY_PORT = 1099;
    public static final String SERVICE_NAME = "InventoryService";

    public static void main(String[] args) {
        try {
            System.out.println("[RMI Server] Initializing RMI Registry on port " + REGISTRY_PORT + "...");
            Registry registry;
            try {
                registry = LocateRegistry.createRegistry(REGISTRY_PORT);
                System.out.println("[RMI Server] Created new RMI Registry.");
            } catch (Exception e) {
                registry = LocateRegistry.getRegistry(REGISTRY_PORT);
                System.out.println("[RMI Server] Reusing existing RMI Registry.");
            }

            InventoryService service = new InventoryServiceImpl();
            registry.rebind(SERVICE_NAME, service);

            System.out.println("=================================================");
            System.out.println(" ShopSphere RMI Inventory Server is ONLINE!");
            System.out.println(" Service bound to: rmi://localhost:" + REGISTRY_PORT + "/" + SERVICE_NAME);
            System.out.println(" Waiting for remote client invocations...");
            System.out.println("=================================================");

            // Keep server alive
            Thread.currentThread().join();
        } catch (Exception e) {
            System.err.println("[RMI Server] Startup failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
