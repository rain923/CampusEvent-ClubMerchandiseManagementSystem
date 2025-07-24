<%-- 
    Document   : club_merchandise
    Created on : Jul 22, 2025, 6:55:09?PM
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
    <title>Manage Merchandise</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #d9f2e6; }
        a.button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #1f5f06; }
        section { width: 90%; margin: 20px auto; }
        h2 { text-align: center; color: #2b7a0b; }
    </style>
</head>
<body>
    <header>
        <h1>Manage Merchandise</h1>
        <nav>
            <a href="club_dashboard.jsp" style="color:white;">Back to Dashboard</a> |
            <a href="club_order_history.jsp" style="color:white;">View Full Order History</a> |
            <a href="upload_qr.jsp" style="color:white;">Upload QR Code</a>
        </nav>
    </header>

    <main>
        <table>
            <tr>
                <th>Name</th>
                <th>Price (RM)</th>
                <th>Description</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                    );

                    String sql = "SELECT * FROM merchandise WHERE club_id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, clubId);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        String description = rs.getString("description");

                        out.println("<tr>");
                        out.println("<td>" + name + "</td>");
                        out.println("<td>" + price + "</td>");
                        out.println("<td>" + description + "</td>");
                        out.println("<td>");
                        out.println("<a class='button' href='edit_merchandise.jsp?id=" + id + "'>Edit</a> ");
                        out.println("<a class='button' href='delete_merchandise.jsp?id=" + id + "' onclick=\"return confirm('Are you sure?');\">Delete</a>");
                        out.println("</td>");
                        out.println("</tr>");
                    }

                    rs.close();
                    ps.close();
                    conn.close();

                } catch (Exception e) {
                    out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>

        <div style="text-align:center;">
            <a class="button" href="add_merchandise.jsp">Add New Merchandise</a>
        </div>

        <section>
            <h2>New Orders</h2>
            <table>
                <tr>
                    <th>Order ID</th>
                    <th>Student Name</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
                <%
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection(
                            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                        );

                        String orderSql = "SELECT o.id, u.name, u.email "
                                        + "FROM orders o "
                                        + "JOIN users u ON o.user_email = u.email "
                                        + "JOIN merchandise m ON o.merch_id = m.id "
                                        + "WHERE m.club_id = ? AND o.status = 'Pending'";

                        PreparedStatement orderPs = conn.prepareStatement(orderSql);
                        orderPs.setInt(1, clubId);
                        ResultSet orderRs = orderPs.executeQuery();

                        boolean hasOrder = false;
                        while (orderRs.next()) {
                            hasOrder = true;
                            int orderId = orderRs.getInt("id");
                            String studentName = orderRs.getString("name");
                            String email = orderRs.getString("email");

                            out.println("<tr>");
                            out.println("<td>" + orderId + "</td>");
                            out.println("<td>" + studentName + "</td>");
                            out.println("<td>" + email + "</td>");
                            out.println("<td><a class='button' href='view_order.jsp?id=" + orderId + "'>View</a></td>");
                            out.println("</tr>");
                        }

                        if (!hasOrder) {
                            out.println("<tr><td colspan='4'>No new orders found.</td></tr>");
                        }

                        orderRs.close();
                        orderPs.close();
                        conn.close();

                    } catch (Exception e) {
                        out.println("<tr><td colspan='4'>Error retrieving orders: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </section>
    </main>
</body>
</html>