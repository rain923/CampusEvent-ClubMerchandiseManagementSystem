/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.campus.dao;

import java.sql.*;
import java.util.logging.*;

public class OrderDAO {
    private static final Logger logger = Logger.getLogger(OrderDAO.class.getName());
    private String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    private String jdbcUsername = "app";
    private String jdbcPassword = "app";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "JDBC Driver not found", e);
            throw new SQLException("JDBC Driver not found", e);
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public boolean placeOrder(int studentId, int merchandiseId, int quantity, String postageInfo) {
        String sql = "INSERT INTO orders (student_id, merchandise_id, quantity, postage_info) VALUES (?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, studentId);
            stmt.setInt(2, merchandiseId);
            stmt.setInt(3, quantity);
            stmt.setString(4, postageInfo);

            int rowsInserted = stmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Order placement failed", e);
            return false;
        }
    }
}