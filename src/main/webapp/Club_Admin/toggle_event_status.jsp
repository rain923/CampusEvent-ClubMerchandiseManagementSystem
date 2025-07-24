<%-- 
    Document   : toggle_event_status
    Created on : Jul 22, 2025, 10:00:31?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String newStatus = request.getParameter("status");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "UPDATE events SET status = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, newStatus);
        ps.setInt(2, id);

        int updated = ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("club_events.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>