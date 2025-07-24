<%-- 
    Document   : add_event
    Created on : Jul 22, 2025, 6:01:48?PM
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
    <title>Add Event</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        form { max-width: 600px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; }
        div { margin-bottom: 10px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input, textarea { width: 100%; padding: 8px; }
        button { background-color: #2b7a0b; color: white; padding: 10px; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #1f5f06; }
    </style>
</head>
<body>
    <header><h1>Add New Event</h1>
        <nav><a href="club_dashboard.jsp" style="color:white;">Back to Dashboard</a></nav>
    </header>
    

    <form action="add_event_process.jsp" method="post">
        <!-- ? Include hidden clubId -->
        <input type="hidden" name="clubId" value="<%= clubId %>">

        <div>
            <label>Event Name:</label>
            <input type="text" name="eventName" required>
        </div>
        <div>
            <label>Date:</label>
            <input type="date" name="eventDate" required>
        </div>
        <div>
            <label>Location:</label>
            <input type="text" name="location" required>
        </div>
        <div>
            <label>Fee (RM):</label>
            <input type="number" name="fee" step="0.01" required>
        </div>
        <div>
            <label>Description:</label>
            <textarea name="description" rows="4" required></textarea>
        </div>
        <button type="submit">Add Event</button>
    </form>
</body>
</html>