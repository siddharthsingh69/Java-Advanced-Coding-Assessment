package com.shopsphere.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * Singleton database connection manager for MySQL / JDBC.
 */
public class DBConnection {

    private static String url = "jdbc:mysql://localhost:3306/shopsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static String username = "root";
    private static String password = "";
    private static String driver = "com.mysql.cj.jdbc.Driver";

    static {
        try (InputStream in = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            if (in != null) {
                Properties props = new Properties();
                props.load(in);
                if (props.containsKey("db.url")) url = props.getProperty("db.url");
                if (props.containsKey("db.user")) username = props.getProperty("db.user");
                if (props.containsKey("db.password")) password = props.getProperty("db.password");
                if (props.containsKey("db.driver")) driver = props.getProperty("db.driver");
            }
        } catch (Exception e) {
            System.err.println("[DBConnection] Could not load db.properties, using fallback defaults: " + e.getMessage());
        }

        // Allow system environment variable overrides
        if (System.getenv("SHOPSPHERE_DB_URL") != null) {
            url = System.getenv("SHOPSPHERE_DB_URL");
        }
        if (System.getenv("SHOPSPHERE_DB_USER") != null) {
            username = System.getenv("SHOPSPHERE_DB_USER");
        }
        if (System.getenv("SHOPSPHERE_DB_PASSWORD") != null) {
            password = System.getenv("SHOPSPHERE_DB_PASSWORD");
        }

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found in classpath: " + driver, e);
        }
    }

    private DBConnection() {
        // Prevent direct instantiation
    }

    /**
     * Obtains a new database connection.
     *
     * @return java.sql.Connection
     * @throws SQLException if a connection failure occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }

    /**
     * Safely closes auto-closeable JDBC resources (Connection, Statement, ResultSet).
     */
    public static void close(AutoCloseable... resources) {
        for (AutoCloseable res : resources) {
            if (res != null) {
                try {
                    res.close();
                } catch (Exception ignored) {
                }
            }
        }
    }
}
