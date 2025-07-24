<%-- 
    Document   : delete_merchandise
    Created on : Jul 22, 2025, 6:59:06?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int merchId = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "DELETE FROM merchandise WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, merchId);

        ps.executeUpdate();
        ps.close();
        conn.close();

        response.sendRedirect("club_merchandise.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>