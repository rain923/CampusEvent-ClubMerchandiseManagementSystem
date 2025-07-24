<%-- 
    Document   : join_club
    Created on : Jul 22, 2025, 7:48:43?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) session.getAttribute("userId");
    int clubId = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        // Insert into club_members table
        String sql = "INSERT INTO club_members (user_id, club_id, status) VALUES (?, ?, 'pending')";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ps.setInt(2, clubId);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("clubs.jsp");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

