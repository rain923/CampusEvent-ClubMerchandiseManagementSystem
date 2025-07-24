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

@WebServlet("/ClubUploadQRServlet")
@MultipartConfig
public class ClubUploadQRServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(ClubUploadQRServlet.class.getName());
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

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");

        Part filePart = request.getPart("qr_code");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {
            String uploadsDir = "C:/qr_uploads/";
            File uploadsFolder = new File(uploadsDir);
            if (!uploadsFolder.exists()) uploadsFolder.mkdirs();

            String extension = filePart.getSubmittedFileName().substring(filePart.getSubmittedFileName().lastIndexOf("."));
            fileName = UUID.randomUUID().toString() + extension;

            try (InputStream input = filePart.getInputStream()) {
                File targetFile = new File(uploadsDir + fileName);
                try (FileOutputStream output = new FileOutputStream(targetFile)) {
                    byte[] buffer = new byte[1024];
                    int bytesRead;
                    while ((bytesRead = input.read(buffer)) != -1) {
                        output.write(buffer, 0, bytesRead);
                    }
                }
            }
        }

        try (Connection conn = getConnection()) {
            String sql = "UPDATE clubs SET qr_code = ? WHERE admin_id = (SELECT id FROM users WHERE email = ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, fileName);
            ps.setString(2, userEmail);
            ps.executeUpdate();
            ps.close();

            response.sendRedirect("club_merchandise.jsp");

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Database error saving QR code", e);
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}