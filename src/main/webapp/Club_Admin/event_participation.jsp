<%-- 
    Document   : event_participants
    Created on : Jul 22, 2025, 6:42:40?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    // Check login
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Get event ID from URL
    int eventId = Integer.parseInt(request.getParameter("id"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Event Participants</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        table { width: 80%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #d9f2e6; }
        a.button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #1f5f06; }
    </style>
</head>
<body>
    <header>
        <h1>Event Participants</h1>
        <nav><a href="club_events.jsp" style="color:white;">Back to Events</a></nav>
    </header>

    <main>
        <table>
            <tr>
                <th>No</th>
                <th>Participant Name</th>
                <th>Email</th>
            </tr>
            <%
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection conn = DriverManager.getConnection(
                        "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                    );

                    String sql = "SELECT u.name, u.email " +
                                 "FROM event_participants ep " +
                                 "JOIN users u ON ep.user_id = u.id " +
                                 "WHERE ep.event_id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, eventId);
                    ResultSet rs = ps.executeQuery();

                    int count = 1;
                    while (rs.next()) {
                        String name = rs.getString("name");
                        String email = rs.getString("email");

                        out.println("<tr>");
                        out.println("<td>" + count++ + "</td>");
                        out.println("<td>" + name + "</td>");
                        out.println("<td>" + email + "</td>");
                        out.println("</tr>");
                    }

                    rs.close();
                    ps.close();
                    conn.close();

                } catch (Exception e) {
                    out.println("<tr><td colspan='3'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>
    </main>
</body>
</html>