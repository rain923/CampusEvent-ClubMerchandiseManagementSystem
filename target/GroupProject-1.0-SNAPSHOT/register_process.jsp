<%-- 
    Document   : register_process
    Created on : Jun 29, 2025, 7:51:57?PM
    Author     : User
--%>

<%@ page import="java.sql.*, java.security.*" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm_password");
    String userType = request.getParameter("user_type");

    if (!password.equals(confirmPassword)) {
        out.println("Passwords do not match.");
        return;
    }

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String status;

        if (userType.equals("club_admin")) {
            // For club admin, set status to pending for approval
            status = "pending";
        } else {
            // For students, set status to active immediately
            status = "active";
        }

        String sql = "INSERT INTO users (name, email, password, user_type, status) VALUES (?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, password); // Replace with hashed password in production
        ps.setString(4, userType);
        ps.setString(5, status);

        int rows = ps.executeUpdate();

        if (rows > 0) {
            if (userType.equals("club_admin")) {
                out.println("Your registration as Club Admin has been submitted. Please wait for system admin approval.");
            } else {
                response.sendRedirect("login.jsp");
            }
        } else {
            out.println("Registration failed.");
        }

        ps.close();
        conn.close();

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>