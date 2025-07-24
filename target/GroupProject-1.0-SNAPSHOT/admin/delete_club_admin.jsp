<%-- 
    Document   : delete_club_admin
    Created on : Jul 22, 2025, 9:36:48?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    String id = request.getParameter("id");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String sql = "DELETE FROM users WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(id));

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("admin_dashboard.jsp");
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>