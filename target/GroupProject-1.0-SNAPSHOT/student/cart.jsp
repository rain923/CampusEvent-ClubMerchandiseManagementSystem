<%-- 
    Document   : cart
    Created on : Jul 22, 2025, 4:35:29?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%
    // Get session and user email
    String userEmail = (String) session.getAttribute("userEmail");

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    BigDecimal grandTotal = new BigDecimal("0.00");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String sql = "SELECT c.id, m.name, m.price, c.quantity, (m.price * c.quantity) AS total "
                   + "FROM cart c JOIN merchandise m ON c.merch_id = m.id WHERE c.user_email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);

        ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f8fc; margin: 0; padding: 0; }
        header { background: #005f99; color: white; padding: 20px; text-align: center; }
        nav a { color: white; text-decoration: none; font-weight: bold; margin: 0 10px; }
        nav a:hover { text-decoration: underline; }
        table { width: 80%; margin: 30px auto; border-collapse: collapse; background: white; }
        th, td { padding: 12px; border: 1px solid #ccc; text-align: center; }
        th { background: #e6f0fa; }
        .total-row { font-weight: bold; }
        .checkout-btn {
            display: block; width: 200px; margin: 20px auto;
            background: #007acc; color: white; padding: 10px;
            text-align: center; border-radius: 4px; text-decoration: none;
        }
        .checkout-btn:hover { background: #005f99; }
    </style>
</head>
<body>
    <header>
        <h1>Your Cart</h1>
        <nav>
            <a href="clubs.jsp">Back to Clubs</a>
        </nav>
    </header>

    <table>
        <tr>
            <th>Merchandise</th>
            <th>Price (RM)</th>
            <th>Quantity</th>
            <th>Total (RM)</th>
        </tr>
<%
        while (rs.next()) {
            grandTotal = grandTotal.add(rs.getBigDecimal("total"));
%>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getBigDecimal("price") %></td>
            <td><%= rs.getInt("quantity") %></td>
            <td><%= rs.getBigDecimal("total") %></td>
        </tr>
<%
        }
%>
        <tr class="total-row">
            <td colspan="3">Grand Total</td>
            <td>RM <%= grandTotal %></td>
        </tr>
    </table>

    <a href="checkout.jsp" class="checkout-btn">Proceed to Checkout</a>

</body>
</html>

<%
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>