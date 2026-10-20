package com.shopsphere.network;

import com.shopsphere.model.Product;

import java.io.*;
import java.net.Socket;

/**
 * Socket client demonstrating java.net communication and Java Object Deserialization.
 */
public class InventorySocketClient {

    public static final String HOST = "localhost";
    public static final int PORT = 8888;

    public static void main(String[] args) {
        System.out.println("[Client] Connecting to ShopSphere Inventory Server at " + HOST + ":" + PORT + "...");

        try (Socket socket = new Socket(HOST, PORT);
             BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
             PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
             InputStream rawIn = socket.getInputStream()) {

            System.out.println("[Client] Connected to server successfully!\n");

            // 1. Query stock
            int testId = 1;
            System.out.println("[Client] Sending command: GET_STOCK " + testId);
            writer.println("GET_STOCK " + testId);
            String stockResponse = reader.readLine();
            System.out.println(">>> Server Response: " + stockResponse);

            // 2. Fetch serialized object
            System.out.println("\n[Client] Sending command: GET_PRODUCT " + testId);
            writer.println("GET_PRODUCT " + testId);
            String status = reader.readLine();
            System.out.println(">>> Server Header Response: " + status);

            if ("OBJECT_FOLLOWS".equals(status)) {
                // Deserialize the transmitted Product object
                ObjectInputStream ois = new ObjectInputStream(rawIn);
                Product product = (Product) ois.readObject();
                System.out.println(">>> Deserialized Product Object:");
                System.out.println("    Name: " + product.getName());
                System.out.println("    Brand: " + product.getBrand());
                System.out.println("    Price: ₹" + product.getPrice());
                System.out.println("    Discount: " + product.getDiscount() + "%");
                System.out.println("    Final Price: ₹" + product.getFinalPrice());
                System.out.println("    Stock in DB: " + product.getStock());
            }

            // 3. Update stock
            System.out.println("\n[Client] Sending command: UPDATE_STOCK " + testId + " +10");
            writer.println("UPDATE_STOCK " + testId + " 10");
            String updateResponse = reader.readLine();
            System.out.println(">>> Server Response: " + updateResponse);

            // 4. Verify updated stock
            writer.println("GET_STOCK " + testId);
            System.out.println(">>> Verified Updated Stock: " + reader.readLine());

            // 5. Terminate
            writer.println("QUIT");
            System.out.println("\n[Client] Finished session cleanly: " + reader.readLine());

        } catch (Exception e) {
            System.err.println("[Client] Socket communication error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
