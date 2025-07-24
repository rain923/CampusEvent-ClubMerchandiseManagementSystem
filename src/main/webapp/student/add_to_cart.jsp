<%-- 
    Document   : add_to_cart
    Created on : Jul 22, 2025, 4:32:09?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    String merchId = request.getParameter("merch_id");
    String userEmail = request.getParameter("user_email");
    String quantityStr = request.getParameter("quantity");
    int quantity = Integer.parseInt(quantityStr);

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String sql = "INSERT INTO cart (user_email, merch_id, quantity) VALUES (?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);
        ps.setInt(2, Integer.parseInt(merchId));
        ps.setInt(3, quantity);

        ps.executeUpdate();

        ps.close();
        conn.close();

        out.println("<script>alert('Item added to cart successfully!'); window.history.back();</script>");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>