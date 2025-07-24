<%-- 
    Document   : orders
    Created on : Jul 23, 2025, 9:20:01?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String sql = "SELECT * FROM orders WHERE user_email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Orders</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f8fc;
            margin: 0;
            padding: 0;
        }
        header {
            background: #005f99;
            color: white;
            padding: 20px;
            text-align: center;
        }
        nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            margin: 0 10px;
        }
        nav a:hover {
            text-decoration: underline;
        }
        table {
            width: 90%;
            margin: 30px auto;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: center;
        }
        th {
            background: #e6f0fa;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
        }
        h2 {
            text-align: center;
            margin-top: 30px;
            color: #005f99;
        }
        .receipt-link a {
            color: #007acc;
            text-decoration: none;
        }
        .receipt-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <header>
        <h1>My Orders</h1>
        <nav>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="cart.jsp">Cart</a>
            <a href="clubs.jsp">Clubs</a>
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <h2>Order History</h2>

    <table>
        <tr>
            <th>Order ID</th>
            <th>Recipient</th>
            <th>Phone</th>
            <th>Address</th>
            <th>Status</th>
            <th>Receipt</th>
        </tr>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("address") %>, <%= rs.getString("postcode") %>, <%= rs.getString("city") %>, <%= rs.getString("state") %></td>
            <td><%= rs.getString("status") %></td>
            <td class="receipt-link">
                <a href="<%=request.getContextPath()%>/GetReceiptServlet?file=<%= rs.getString("receipt_image") %>" target="_blank">View Receipt</a>
            </td>
        </tr>
        <%
            }
            rs.close();
            ps.close();
            conn.close();
        %>
    </table>
</body>
</html>

<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>