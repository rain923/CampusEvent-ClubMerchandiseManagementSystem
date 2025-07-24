/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import java.io.*;
import java.sql.*;
import java.util.UUID;
import java.util.logging.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/SavePostageServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 10,      // 10 MB
    maxRequestSize = 1024 * 1024 * 15    // 15 MB
)
public class SavePostageServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(SavePostageServlet.class.getName());
    private String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    private String jdbcUsername = "app";
    private String jdbcPassword = "app";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Derby Driver not found", e);
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        System.out.println("================== DEBUG START ==================");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            System.out.println("Session or userEmail is NULL");
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        System.out.println("userEmail: " + userEmail);

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String postcode = request.getParameter("postcode");
        String city = request.getParameter("city");
        String state = request.getParameter("state");

        System.out.println("Received data: " + name + ", " + phone + ", " + address + ", " + postcode + ", " + city + ", " + state);

        // === Save receipt image ===
        Part filePart = request.getPart("receipt");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            System.out.println("Submitted File Name: " + filePart.getSubmittedFileName());

            String uploadsDir = "C:/receipt_uploads/";
            System.out.println("uploadsDir: " + uploadsDir);

            File uploadsFolder = new File(uploadsDir);
            if (!uploadsFolder.exists()) uploadsFolder.mkdirs();

            String submittedFileName = filePart.getSubmittedFileName();
            String extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + extension;

            try (InputStream input = filePart.getInputStream();
                 FileOutputStream output = new FileOutputStream(new File(uploadsDir + fileName))) {

                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            System.out.println("File saved as: " + fileName);
        } else {
            System.out.println("No file uploaded.");
        }

        try (Connection conn = getConnection()) {
            System.out.println("Database connected.");

            // === Retrieve cart items ===
            String cartSql = "SELECT merch_id, quantity FROM cart WHERE user_email = ?";
            PreparedStatement cartPs = conn.prepareStatement(cartSql);
            cartPs.setString(1, userEmail);
            ResultSet cartRs = cartPs.executeQuery();

            String insertSql = "INSERT INTO orders (user_email, name, phone, address, postcode, city, state, receipt_image, status, merch_id) "
                             + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement insertPs = conn.prepareStatement(insertSql);

            while (cartRs.next()) {
                int merchId = cartRs.getInt("merch_id");

                insertPs.setString(1, userEmail);
                insertPs.setString(2, name);
                insertPs.setString(3, phone);
                insertPs.setString(4, address);
                insertPs.setString(5, postcode);
                insertPs.setString(6, city);
                insertPs.setString(7, state);
                insertPs.setString(8, fileName);
                insertPs.setString(9, "Pending");
                insertPs.setInt(10, merchId);

                insertPs.executeUpdate();
                System.out.println("Inserted order for merch_id: " + merchId);
            }

            cartRs.close();
            cartPs.close();
            insertPs.close();

            // === Clear cart ===
            String clearSql = "DELETE FROM cart WHERE user_email = ?";
            PreparedStatement clearPs = conn.prepareStatement(clearSql);
            clearPs.setString(1, userEmail);
            int rowsDeleted = clearPs.executeUpdate();
            System.out.println("Cart cleared rows: " + rowsDeleted);
            clearPs.close();

            response.sendRedirect("student/checkout_success.jsp");

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error saving order", e);
            response.getWriter().println("Database error: " + e.getMessage());
        }

        System.out.println("================== DEBUG END ==================");
    }
}