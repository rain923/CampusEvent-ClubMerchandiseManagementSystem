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

@WebServlet("/UploadQRServlet")
@MultipartConfig
public class UploadQRServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(UploadQRServlet.class.getName());
    private String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    private String jdbcUsername = "app";
    private String jdbcPassword = "app";
    private static final String QR_UPLOADS_DIR = "C:/qr_uploads/";

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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        Part filePart = request.getPart("qr");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            File uploadsFolder = new File(QR_UPLOADS_DIR);
            if (!uploadsFolder.exists()) uploadsFolder.mkdirs();

            String submittedFileName = filePart.getSubmittedFileName();
            String extension = submittedFileName.substring(submittedFileName.lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + extension;

            // Save the file
            try (InputStream input = filePart.getInputStream()) {
                File targetFile = new File(QR_UPLOADS_DIR + fileName);
                try (FileOutputStream output = new FileOutputStream(targetFile)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        output.write(buffer, 0, bytesRead);
                    }
                }
            }

            // Update database
            try (Connection conn = getConnection()) {
                String updateSql = "UPDATE clubs SET qr_code = ? WHERE admin_id = (SELECT id FROM users WHERE email = ?)";
                PreparedStatement ps = conn.prepareStatement(updateSql);
                ps.setString(1, fileName);
                ps.setString(2, userEmail);

                int rowsUpdated = ps.executeUpdate();
                ps.close();

                System.out.println("QR code updated rows: " + rowsUpdated);
            } catch (SQLException e) {
                logger.log(Level.SEVERE, "Database error saving QR code", e);
            }
        }

        response.sendRedirect("Club_Admin/club_merchandise.jsp");
    }
}