package com.shopsphere.network;

import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Product;

import java.io.*;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Multi-threaded TCP Socket Server for inventory queries with Object Serialization.
 */
public class InventorySocketServer {

    public static final int PORT = 8888;

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println(" ShopSphere TCP Networking Server Starting...");
        System.out.println(" Listening on port: " + PORT);
        System.out.println("=================================================");

        try (ServerSocket serverSocket = new ServerSocket(PORT)) {
            while (true) {
                Socket clientSocket = serverSocket.accept();
                System.out.println("[Server] Accepted connection from: " + clientSocket.getRemoteSocketAddress());
                // Handle each client in a separate thread
                new Thread(new ClientHandler(clientSocket)).start();
            }
        } catch (IOException e) {
            System.err.println("[Server] Error on socket port " + PORT + ": " + e.getMessage());
        }
    }

    private static class ClientHandler implements Runnable {
        private final Socket socket;
        private final ProductDAO productDAO = new ProductDAO();

        public ClientHandler(Socket socket) {
            this.socket = socket;
        }

        @Override
        public void run() {
            try (
                BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                PrintWriter writer = new PrintWriter(socket.getOutputStream(), true);
                OutputStream rawOut = socket.getOutputStream()
            ) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    System.out.println("[Server] Received command: " + line);

                    if ("QUIT".equalsIgnoreCase(line)) {
                        writer.println("BYE");
                        break;
                    }

                    String[] parts = line.split("\\s+");
                    String command = parts[0].toUpperCase();

                    switch (command) {
                        case "GET_STOCK":
                            if (parts.length > 1) {
                                int id = Integer.parseInt(parts[1]);
                                int stock = productDAO.getStock(id);
                                writer.println("STOCK:" + stock);
                            } else {
                                writer.println("ERROR: Missing Product ID");
                            }
                            break;

                        case "UPDATE_STOCK":
                            if (parts.length > 2) {
                                int id = Integer.parseInt(parts[1]);
                                int delta = Integer.parseInt(parts[2]);
                                boolean ok = productDAO.updateStock(id, delta);
                                writer.println(ok ? "SUCCESS" : "FAILED");
                            } else {
                                writer.println("ERROR: Usage UPDATE_STOCK <productId> <delta>");
                            }
                            break;

                        case "GET_PRODUCT":
                            if (parts.length > 1) {
                                int id = Integer.parseInt(parts[1]);
                                Product p = productDAO.findById(id);
                                if (p != null) {
                                    writer.println("OBJECT_FOLLOWS");
                                    // Serialize product object to stream
                                    ObjectOutputStream oos = new ObjectOutputStream(rawOut);
                                    oos.writeObject(p);
                                    oos.flush();
                                } else {
                                    writer.println("NOT_FOUND");
                                }
                            } else {
                                writer.println("ERROR: Missing Product ID");
                            }
                            break;

                        default:
                            writer.println("UNKNOWN_COMMAND");
                    }
                }
            } catch (Exception e) {
                System.err.println("[Server] Connection handler exception: " + e.getMessage());
            } finally {
                try {
                    socket.close();
                } catch (IOException ignored) {}
            }
        }
    }
}
