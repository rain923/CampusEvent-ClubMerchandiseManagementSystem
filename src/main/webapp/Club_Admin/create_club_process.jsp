<%-- 
    Document   : create_club_process
    Created on : Jul 22, 2025, 9:07:00?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    if (session == null || !"club_admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String clubName = request.getParameter("club_name");
    String category = request.getParameter("category");
    String foundedYear = request.getParameter("founded_year");
    String description = request.getParameter("description");

    int adminId = (Integer) session.getAttribute("userId"); // ensure userId stored in session

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "INSERT INTO clubs (club_name, category, founded_year, description, admin_id, members_count) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, clubName);
        ps.setString(2, category);
        ps.setString(3, foundedYear);
        ps.setString(4, description);
        ps.setInt(5, adminId);
        ps.setInt(6, 0); // default members count = 0

        int rows = ps.executeUpdate();

        ps.close();
        conn.close();

        if (rows > 0) {
            // ? Success ? redirect back to club dashboard with success message
            response.sendRedirect("club_dashboard.jsp?message=Club profile created successfully");
        } else {
            // ? Insert failed ? redirect back to create page with error
            response.sendRedirect("create_club.jsp?message=Creation failed. Please try again.");
        }

    } catch (Exception e) {
        // Handle DB errors by redirecting back to create page with error message
        response.sendRedirect("create_club.jsp?message=Error: " + e.getMessage());
    }
%>