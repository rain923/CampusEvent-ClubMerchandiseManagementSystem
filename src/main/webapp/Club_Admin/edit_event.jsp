<%-- 
    Document   : edit_event
    Created on : Jul 22, 2025, 6:02:56?PM
    Author     : User
--%>
<%@ page import="java.sql.*" %>
<%
    int eventId = Integer.parseInt(request.getParameter("id"));
    String eventName = "", eventDate = "", location = "", description = "";
    double fee = 0.0;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "SELECT * FROM events WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, eventId);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            eventName = rs.getString("event_name");
            eventDate = rs.getDate("event_date").toString();
            location = rs.getString("location");
            fee = rs.getDouble("payment"); // ? fixed to payment column
            description = rs.getString("description");
        }

        rs.close();
        ps.close();
        conn.close();

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit Event</title>
    <style>
        body { font-family: Arial; background: #f0f9f4; margin: 0; padding: 0; }
        header { background: #2b7a0b; color: white; padding: 20px; text-align: center; }
        main { max-width: 600px; margin: 30px auto; background: white; padding: 20px; border-radius: 8px; }
        label { font-weight: bold; color: #1f5f06; }
        input, textarea { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #2b7a0b; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        button:hover { background: #1f5f06; }
    </style>
</head>
<body>
    <header>
        <h1>Edit Event</h1>
    </header>
    <main>
        <form action="edit_event_process.jsp" method="post">
            <input type="hidden" name="eventId" value="<%= eventId %>">

            <label>Event Name:</label>
            <input type="text" name="eventName" value="<%= eventName %>" required>

            <label>Event Date:</label>
            <input type="date" name="eventDate" value="<%= eventDate %>" required>

            <label>Location:</label>
            <input type="text" name="location" value="<%= location %>" required>

            <label>Fee (RM):</label>
            <input type="number" name="fee" step="0.01" value="<%= fee %>" required>

            <label>Description:</label>
            <textarea name="description" rows="4" required><%= description %></textarea>

            <button type="submit">Update Event</button>
        </form>
        <p><a href="club_events.jsp">Back to Events</a></p>
    </main>
</body>
</html>