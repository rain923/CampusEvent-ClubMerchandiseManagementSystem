<%-- 
    Document   : view_order
    Created on : Jul 23, 2025, 10:52:06?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Session validation
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String orderId = request.getParameter("id");
    if (orderId == null) {
        out.println("<p>Invalid order ID.</p>");
        return;
    }

    String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    String jdbcUsername = "app";
    String jdbcPassword = "app";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);

        String sql = "SELECT o.*, u.name AS student_name, u.email AS student_email, "
                   + "m.name AS merchandise_name "
                   + "FROM orders o "
                   + "JOIN users u ON o.user_email = u.email "
                   + "JOIN merchandise m ON o.merch_id = m.id "
                   + "WHERE o.id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(orderId));
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String studentName = rs.getString("student_name");
            String studentEmail = rs.getString("student_email");
            String phone = rs.getString("phone");
            String address = rs.getString("address");
            String postcode = rs.getString("postcode");
            String city = rs.getString("city");
            String state = rs.getString("state");
            String merchName = rs.getString("merchandise_name");
            String receiptImage = rs.getString("receipt_image");
            String status = rs.getString("status");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Order</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; padding: 20px; }
        h2 { color: #2b7a0b; }
        table { width: 50%; margin: auto; border-collapse: collapse; }
        th, td { text-align: left; padding: 10px; }
        th { background-color: #d9f2e6; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        .button:hover { background-color: #1f5f06; }
        .action-buttons { text-align: center; margin-top: 20px; }
    </style>
</head>
<body>
    <h2>Order Details</h2>
    <table>
        <tr><th>Order ID</th><td><%= orderId %></td></tr>
        <tr><th>Student Name</th><td><%= studentName %></td></tr>
        <tr><th>Email</th><td><%= studentEmail %></td></tr>
        <tr><th>Phone</th><td><%= phone %></td></tr>
        <tr><th>Address</th><td><%= address %></td></tr>
        <tr><th>Postcode</th><td><%= postcode %></td></tr>
        <tr><th>City</th><td><%= city %></td></tr>
        <tr><th>State</th><td><%= state %></td></tr>
        <tr><th>Merchandise</th><td><%= merchName %></td></tr>
        <tr><th>Status</th><td><%= status %></td></tr>
        <tr>
            <th>Receipt</th>
            <td>
                <% if (receiptImage != null) { %>
                    <a href="../GetReceiptServlet?file=<%= receiptImage %>" target="_blank">View Receipt</a>
                <% } else { %>
                    No receipt uploaded.
                <% } %>
            </td>
        </tr>
    </table>

    <div class="action-buttons">
        <form method="post" action="<%= request.getContextPath() %>/UpdateOrderStatusServlet">
            <input type="hidden" name="orderId" value="<%= orderId %>">
            <button type="submit" name="status" value="Approved" class="button">Approve</button>
            <button type="submit" name="status" value="Rejected" class="button" style="background-color: red;">Reject</button>
        </form>
    </div>

    <div style="text-align:center; margin-top:20px;">
        <a class="button" href="club_merchandise.jsp">Back</a>
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
        out.println("<p>Error retrieving order: " + e.getMessage() + "</p>");
    }
%>