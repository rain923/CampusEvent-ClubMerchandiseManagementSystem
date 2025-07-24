<%-- 
    Document   : view_order_details
    Created on : Jul 24, 2025, 12:27:41?AM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String orderIdStr = request.getParameter("id");
    if (orderIdStr == null) {
        out.println("<p>No order selected.</p>");
        return;
    }

    int orderId = Integer.parseInt(orderIdStr);

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "SELECT o.id, m.name AS merch_name, u.name AS student_name, u.email, "
                   + "o.status, o.address, o.phone, o.postcode, o.city, o.state, o.receipt_image "
                   + "FROM orders o "
                   + "JOIN merchandise m ON o.merch_id = m.id "
                   + "JOIN users u ON o.user_email = u.email "
                   + "WHERE o.id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, orderId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>View Order Details</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; padding: 20px; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        table { margin: 20px auto; border-collapse: collapse; width: 50%; }
        td { padding: 10px; border: 1px solid #ccc; }
        td.label { font-weight: bold; background-color: #d9f2e6; }
        .back { text-align: center; margin-top: 20px; }
        a.button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #1f5f06; }
    </style>
</head>
<body>
    <header>
        <h1>Order Details</h1>
    </header>

    <table>
        <tr><td class="label">Order ID</td><td><%= rs.getInt("id") %></td></tr>
        <tr><td class="label">Merchandise</td><td><%= rs.getString("merch_name") %></td></tr>
        <tr><td class="label">Student Name</td><td><%= rs.getString("student_name") %></td></tr>
        <tr><td class="label">Email</td><td><%= rs.getString("email") %></td></tr>
        <tr><td class="label">Status</td><td><%= rs.getString("status") %></td></tr>
        <tr><td class="label">Phone</td><td><%= rs.getString("phone") %></td></tr>
        <tr><td class="label">Address</td><td>
            <%= rs.getString("address") %>, 
            <%= rs.getString("postcode") %>, 
            <%= rs.getString("city") %>, 
            <%= rs.getString("state") %>
        </td></tr>
        <tr><td class="label">Receipt</td>
            <td>
                <% String receipt = rs.getString("receipt_image");
                   if (receipt != null && !receipt.isEmpty()) { %>
                    <a href="../GetReceiptServlet?file=<%= receipt %>" target="_blank">View Receipt</a>
                <% } else { %>
                    No Receipt Uploaded
                <% } %>
            </td>
        </tr>
    </table>

    <div class="back">
        <a class="button" href="club_order_history.jsp">Back to Order History</a>
    </div>
</body>
</html>
<%
        } else {
            out.println("<p>Order not found.</p>");
        }

        rs.close();
        ps.close();
        conn.close();

    } catch (Exception e) {
        out.println("<p>Error retrieving order details: " + e.getMessage() + "</p>");
    }
%>