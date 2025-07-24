
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/GroupProject584", "app", "app");

            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String dbPassword = rs.getString("password");
                String userType = rs.getString("user_type");
                String userName = rs.getString("name");

                if (password.equals(dbPassword)) {
                    HttpSession session = request.getSession();
                    session.setAttribute("userEmail", email);
                    session.setAttribute("userType", userType);
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", userName);

                    // ✅ Ensure proper redirect for system admin
                    switch (userType) {
                        case "student":
                            response.sendRedirect("student/dashboard.jsp");
                            break;
                        case "club_admin":
                            response.sendRedirect("Club_Admin/club_dashboard.jsp");
                            break;
                        case "system_admin":
                            response.sendRedirect("admin/admin_dashboard.jsp");
                            break;
                        default:
                            response.getWriter().println("Unknown user type.");
                    }
                } else {
                    response.getWriter().println("Invalid password.");
                }

            } else {
                response.getWriter().println("User not found.");
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}