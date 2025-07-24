<%-- 
    Document   : edit_merchandise_process
    Created on : Jul 22, 2025, 6:58:41?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int merchId = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    double price = Double.parseDouble(request.getParameter("price"));
    String description = request.getParameter("description");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "UPDATE merchandise SET name = ?, price = ?, description = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setDouble(2, price);
        ps.setString(3, description);
        ps.setInt(4, merchId);

        ps.executeUpdate();
        ps.close();
        conn.close();

        response.sendRedirect("club_merchandise.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>