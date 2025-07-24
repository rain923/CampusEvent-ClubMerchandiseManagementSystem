<%-- 
    Document   : delete_club
    Created on : Jul 22, 2025, 9:25:21?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    // ? Check system admin session
    if (session == null || !"system_admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String clubId = request.getParameter("id");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "DELETE FROM clubs WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(clubId));

        int rows = ps.executeUpdate();

        ps.close();
        conn.close();

        if (rows > 0) {
            response.sendRedirect("admin_manage_clubs.jsp?message=Club deleted successfully");
        } else {
            response.sendRedirect("admin_manage_clubs.jsp?message=Delete failed");
        }

    } catch (Exception e) {
        response.sendRedirect("admin_manage_clubs.jsp?message=Error: " + e.getMessage());
    }
%>