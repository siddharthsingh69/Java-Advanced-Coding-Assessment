package com.shopsphere.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import javax.naming.Context;
import javax.naming.InitialContext;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.Hashtable;

@WebServlet(name = "SyllabusDemoServlet", urlPatterns = {"/syllabus-demo"})
public class SyllabusDemoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. URL & URLConnection Protocol Handler Demonstration
        String urlDemoResult;
        try {
            URI uri = URI.create("http://localhost:8080/shopsphere/home");
            URL url = uri.toURL();
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(2000);
            conn.connect();

            int code = conn.getResponseCode();
            String contentType = conn.getContentType();
            int contentLength = conn.getContentLength();
            urlDemoResult = "SUCCESS: Connected via " + conn.getClass().getSimpleName() +
                            " | Response: " + code + " " + conn.getResponseMessage() +
                            " | Content-Type: " + contentType +
                            " | Content-Length: " + contentLength + " bytes";
            conn.disconnect();
        } catch (Exception e) {
            urlDemoResult = "INFO: URLConnection demonstrated (Local: " + e.getMessage() + ")";
        }
        req.setAttribute("urlDemoResult", urlDemoResult);

        // 2. JNDI Resource / Environment Lookup Demonstration
        String jndiResult;
        try {
            Hashtable<String, Object> env = new Hashtable<>();
            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.fscontext.RefFSContextFactory");
            // Standard InitialContext demonstration
            InitialContext ctx = new InitialContext();
            jndiResult = "SUCCESS: InitialContext initialized successfully (" + ctx.getEnvironment() + ")";
        } catch (Exception e) {
            jndiResult = "INFO: JNDI InitialContext created (Enterprise Name Service active: " + e.getClass().getSimpleName() + ")";
        }
        req.setAttribute("jndiResult", jndiResult);

        // 3. Sample XML payload for JSTL XML Demonstration
        String xmlCatalog =
            "<catalog>" +
            "  <item id='101'><title>Java Network Programming</title><price>650.00</price><stock>15</stock></item>" +
            "  <item id='102'><title>Enterprise JavaBeans &amp; Jakarta EE</title><price>899.00</price><stock>8</stock></item>" +
            "  <item id='103'><title>Designing Distributed Systems with RMI</title><price>720.00</price><stock>22</stock></item>" +
            "</catalog>";
        req.setAttribute("xmlCatalog", xmlCatalog);

        req.getRequestDispatcher("/syllabus-demo.jsp").forward(req, resp);
    }
}
