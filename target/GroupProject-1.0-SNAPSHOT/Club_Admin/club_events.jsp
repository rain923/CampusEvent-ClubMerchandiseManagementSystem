<%-- 
    Document   : club_events
    Created on : Jul 22, 2025, 5:59:42?PM
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

        String sql = "SELECT c.id FROM clubs c JOIN users u ON c.admin_id = u.id WHERE u.email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            clubId = rs.getInt("id");
        } else {
            out.println("<p>Error: Club not found for this user.</p>");
            return;
        }

        rs.close();
        ps.close();
        conn.close();

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Events</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #d9f2e6; }
        a.button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #1f5f06; }
        .status-active { color: green; font-weight: bold; }
        .status-unavailable { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <header>
        <h1>Manage Events</h1>
        <nav><a href="club_dashboard.jsp" style="color:white;">Back to Dashboard</a></nav>
    </header>

    <main>
        <table>
            <tr>
                <th>Name</th>
                <th>Date</th>
                <th>Location</th>
                <th>Fee (RM)</th>
                <th>Description</th>
                <th>Status</th>
                <th>Participation</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                    );

                    String sql = "SELECT * FROM events WHERE club_id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, clubId);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String name = rs.getString("event_name");
                        Date date = rs.getDate("event_date");
                        String location = rs.getString("location");
                        double fee = rs.getDouble("payment");
                        String description = rs.getString("description");
                        String status = rs.getString("status");

                        out.println("<tr>");
                        out.println("<td>" + name + "</td>");
                        out.println("<td>" + date + "</td>");
                        out.println("<td>" + location + "</td>");
                        out.println("<td>" + fee + "</td>");
                        out.println("<td>" + description + "</td>");

                        out.println("<td class='status-" + (status.equals("active") ? "active" : "unavailable") + "'>" + status + "</td>");

                        out.println("<td><a class='button' href='event_participation.jsp?id=" + id + "'>View</a></td>");

                        out.println("<td>");
                        out.println("<div class='action-buttons'>");

                        // Toggle status button
                        String toggleAction = status.equals("active") ? "Disable" : "Enable";
                        String newStatus = status.equals("active") ? "unavailable" : "active";
                        out.println("<a class='button' href='toggle_event_status.jsp?id=" + id + "&status=" + newStatus + "'>" + toggleAction + "</a> ");

                        // Edit & Delete
                        out.println("<a class='button' href='edit_event.jsp?id=" + id + "'>Edit</a> ");
                        out.println("<a class='button' href='delete_event.jsp?id=" + id + "' onclick=\"return confirm('Are you sure?');\">Delete</a>");

                        out.println("</div>");
                        out.println("</td>");

                        out.println("</tr>");
                    }
                    rs.close();
                    ps.close();
                    conn.close();

                } catch (Exception e) {
                    out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>

        <div style="text-align:center;">
            <a class="button" href="add_event.jsp">Add New Event</a>
        </div>
    </main>
</body>
</html>