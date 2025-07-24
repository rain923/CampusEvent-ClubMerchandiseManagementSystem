<%-- 
    Document   : active_member
    Created on : Jul 22, 2025, 7:27:46?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int memberId = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "UPDATE club_members SET status = 'active' WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, memberId);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("club_manage_member.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
