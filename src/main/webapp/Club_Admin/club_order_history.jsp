<%-- 
    Document   : club_order_history
    Created on : Jul 23, 2025, 11:19:54?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    int clubId = 0;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        // Get clubId based on user email
        String clubSql = "SELECT c.id FROM clubs c JOIN users u ON c.admin_id = u.id WHERE u.email = ?";
        PreparedStatement clubPs = conn.prepareStatement(clubSql);
        clubPs.setString(1, userEmail);
        ResultSet clubRs = clubPs.executeQuery();

        if (clubRs.next()) {
            clubId = clubRs.getInt("id");
        } else {
            out.println("<p>No club found for your account.</p>");
            return;
        }

        clubRs.close();
        clubPs.close();
        conn.close();

    } catch(Exception e) {
        out.println("<p>Error retrieving club: " + e.getMessage() + "</p>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Order History</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #d9f2e6; }
        a.button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #1f5f06; }
        h2 { text-align: center; color: #2b7a0b; }
    </style>
</head>
<body>
    <header>
        <h1>Order History</h1>
        <nav><a href="club_dashboard.jsp" style="color:white;">Back to Dashboard</a></nav>
    </header>

    <main>
        <h2>All Orders</h2>
        <table>
            <tr>
                <th>Order ID</th>
                <th>Merchandise</th>
                <th>Student Name</th>
                <th>Status</th>
                <th>Receipt</th>
                <th>Action</th>
            </tr>
            <%
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                    );

                    String orderSql = "SELECT o.id, m.name AS merch_name, u.name AS student_name, o.status, o.receipt_image "
                                    + "FROM orders o "
                                    + "JOIN merchandise m ON o.merch_id = m.id "
                                    + "JOIN users u ON o.user_email = u.email "
                                    + "WHERE m.club_id = ? "
                                    + "ORDER BY o.id DESC";

                    PreparedStatement orderPs = conn.prepareStatement(orderSql);
                    orderPs.setInt(1, clubId);
                    ResultSet orderRs = orderPs.executeQuery();

                    boolean hasOrder = false;
                    while (orderRs.next()) {
                        hasOrder = true;
                        int orderId = orderRs.getInt("id");
                        String merchName = orderRs.getString("merch_name");
                        String studentName = orderRs.getString("student_name");
                        String status = orderRs.getString("status");
                        String receipt = orderRs.getString("receipt_image");

                        out.println("<tr>");
                        out.println("<td>" + orderId + "</td>");
                        out.println("<td>" + merchName + "</td>");
                        out.println("<td>" + studentName + "</td>");
                        out.println("<td>" + status + "</td>");

                        if (receipt != null && !receipt.isEmpty()) {
                            out.println("<td><a href='../GetReceiptServlet?file=" + receipt + "' target='_blank'>View</a></td>");
                        } else {
                            out.println("<td>No Receipt</td>");
                        }

                        // View button to see full order details
                        out.println("<td><a class='button' href='view_order_details.jsp?id=" + orderId + "'>View</a></td>");

                        out.println("</tr>");
                    }

                    if (!hasOrder) {
                        out.println("<tr><td colspan='6'>No orders found.</td></tr>");
                    }

                    orderRs.close();
                    orderPs.close();
                    conn.close();

                } catch (Exception e) {
                    out.println("<tr><td colspan='6'>Error retrieving orders: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </main>
</body>
</html>