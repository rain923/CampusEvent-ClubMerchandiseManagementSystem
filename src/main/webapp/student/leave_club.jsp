<%-- 
    Document   : leave_club
    Created on : Jul 22, 2025, 7:49:50?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "DELETE FROM club_members WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("clubs.jsp");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>