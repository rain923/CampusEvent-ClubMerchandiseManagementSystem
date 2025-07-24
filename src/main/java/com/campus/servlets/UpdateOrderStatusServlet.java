/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateOrderStatusServlet")
public class UpdateOrderStatusServlet extends HttpServlet {
    private String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    private String jdbcUsername = "app";
    private String jdbcPassword = "app";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        if (orderId == null || status == null) {
            response.getWriter().println("Invalid request.");
            return;
        }

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

            String sql = "UPDATE orders SET status = ? WHERE id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, Integer.parseInt(orderId));

            int rowsUpdated = ps.executeUpdate();
            ps.close();
            conn.close();

            if (rowsUpdated > 0) {
                response.sendRedirect("Club_Admin/club_merchandise.jsp");
            } else {
                response.getWriter().println("Failed to update status.");
            }

        } catch (Exception e) {
            response.getWriter().println("Database error: " + e.getMessage());
        }
    }
}