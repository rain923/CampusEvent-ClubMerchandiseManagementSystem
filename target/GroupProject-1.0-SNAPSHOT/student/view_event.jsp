<%-- 
    Document   : view_event
    Created on : Jun 29, 2025, 9:44:33?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.campus.models.Event" %>
<%
    String id = request.getParameter("id");
    Event event = null;
    String clubName = "N/A";
    
    if (id == null || id.isEmpty()) {
        out.println("<p class='error'>Error: No event ID provided.</p>");
    } else {
        Connection conn = null;
        PreparedStatement ps = null;
        PreparedStatement psClub = null;
        ResultSet rs = null;
        ResultSet rsClub = null;
        
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/GroupProject584", 
                "app", 
                "app"
            );

            String sql = "SELECT * FROM events WHERE id = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));
            rs = ps.executeQuery();

            if (rs.next()) {
                event = new Event();
                event.setId(rs.getInt("ID"));
                event.setName(rs.getString("EVENT_NAME"));
                
                Date eventDate = rs.getDate("EVENT_DATE");
                event.setDate(eventDate != null ? eventDate.toString() : "N/A");
                
                event.setLocation(rs.getString("LOCATION"));
                event.setDescription(rs.getString("DESCRIPTION"));
                event.setPayment(rs.getDouble("PAYMENT"));
                
                int clubId = rs.getInt("CLUB_ID");
                String clubSql = "SELECT CLUB_NAME FROM clubs WHERE ID = ?";
                psClub = conn.prepareStatement(clubSql);
                psClub.setInt(1, clubId);
                rsClub = psClub.executeQuery();
                
                if (rsClub.next()) {
                    clubName = rsClub.getString("CLUB_NAME");
                }
            }
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            out.println("<p class='error'>Could not load event details.</p>");
        } finally {
            if (rs != null) rs.close();
            if (rsClub != null) rsClub.close();
            if (ps != null) ps.close();
            if (psClub != null) psClub.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Event Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f8fc;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #005f99;
            color: white;
            padding: 20px 0;
            text-align: center;
        }

        nav {
            margin-top: 10px;
        }

        nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        nav a:hover {
            text-decoration: underline;
        }

        main {
            max-width: 700px;
            margin: 40px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h2 {
            color: #005f99;
        }

        .info {
            margin: 15px 0;
        }

        .info strong {
            display: inline-block;
            width: 140px;
            color: #333;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            background-color: #007acc;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }

        .back-link:hover {
            background-color: #005f99;
        }

        .error {
            color: red;
            font-weight: bold;
        }

        /* New payment styling */
        .fee-free {
            color: green;
            font-weight: bold;
        }

        .fee-paid {
            color: #005f99;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <header>
        <h1>Event Details</h1>
        <nav>
            <a href="events.jsp">Back to Events</a>
        </nav>
    </header>
    <main>
        <% if (event != null) { %>
            <h2><%= event.getName() %></h2>
            <div class="info"><strong>Date:</strong> <%= event.getDate() %></div>
            <div class="info"><strong>Location:</strong> <%= event.getLocation() %></div>
            <div class="info"><strong>Hosted By:</strong> <%= clubName %></div>
            <div class="info"><strong>Description:</strong> 
                <%= event.getDescription() != null && !event.getDescription().isEmpty() ? 
                    event.getDescription() : "No description provided" %>
            </div>
            <div class="info"><strong>Fee:</strong> 
                <% if (event.getPayment() > 0) { %>
                    <span class="fee-paid">RM <%= String.format("%.2f", event.getPayment()) %></span>
                <% } else { %>
                    <span class="fee-free">FREE</span>
                <% } %>
            </div>
        <% } else { %>
            <p>Event not found.</p>
        <% } %>

        <a class="back-link" href="../EventServlet">Back to Events</a>
    </main>
</body>
</html>