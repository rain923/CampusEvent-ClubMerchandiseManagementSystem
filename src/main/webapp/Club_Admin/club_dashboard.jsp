<%-- 
    Document   : club_dashboard
    Created on : Jul 22, 2025, 5:25:16?PM
    Author     : User
--%>
<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    int userId = (Integer) session.getAttribute("userId");

    boolean hasClubProfile = false;
    String clubName = "";
    int clubId = -1;

    int upcomingEvents = 0;
    int activeMembers = 0;
    int pendingRequests = 0;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        // Get club info
        String sql = "SELECT * FROM clubs WHERE admin_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            hasClubProfile = true;
            clubId = rs.getInt("id");
            clubName = rs.getString("club_name");
        }

        rs.close();
        ps.close();

        if (hasClubProfile) {
            // Count upcoming events
            sql = "SELECT COUNT(*) AS count FROM events WHERE club_id = ? AND event_date >= CURRENT_DATE";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, clubId);
            rs = ps.executeQuery();
            if (rs.next()) {
                upcomingEvents = rs.getInt("count");
            }
            rs.close();
            ps.close();

            // Count active members
            sql = "SELECT COUNT(*) AS count FROM club_members WHERE club_id = ? AND status = 'active'";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, clubId);
            rs = ps.executeQuery();
            if (rs.next()) {
                activeMembers = rs.getInt("count");
            }
            rs.close();
            ps.close();

            // Count pending member requests
            sql = "SELECT COUNT(*) AS count FROM club_members WHERE club_id = ? AND status = 'pending'";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, clubId);
            rs = ps.executeQuery();
            if (rs.next()) {
                pendingRequests = rs.getInt("count");
            }
            rs.close();
            ps.close();
        }

        conn.close();

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Club Admin Dashboard</title>
    <link rel="stylesheet" href="club_style.css" />
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f9f4;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #2b7a0b;
            color: white;
            padding: 20px;
            text-align: center;
        }

        nav {
            background-color: #1f5f06;
            padding: 10px;
            text-align: center;
        }

        nav a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: bold;
        }

        nav a:hover {
            text-decoration: underline;
        }

        main {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }

        section {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2b7a0b;
        }

        .stats {
            display: flex;
            justify-content: space-around;
            margin-top: 15px;
        }

        .stats div {
            background-color: #daf5dc;
            padding: 15px;
            border-radius: 6px;
            flex: 1;
            margin: 5px;
            text-align: center;
            font-weight: bold;
            color: #1f5f06;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        ul li {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        ul li:last-child {
            border-bottom: none;
        }

        .no-club {
            text-align: center;
            padding: 30px;
        }

        .create-btn {
            display: inline-block;
            background-color: #007acc;
            color: white;
            padding: 10px 20px;
            margin-top: 15px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }

        .create-btn:hover {
            background-color: #005f99;
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome, <%= (userName != null ? userName : "Club Admin") %>!</h1>
        <h2>Club Admin Dashboard</h2>
    </header>
    <nav>
        <a href="manage_club_profile.jsp">Manage Club Profile</a> |
        <a href="club_events.jsp">Manage Events</a> |
        <a href="club_manage_member.jsp">Manage Members</a> |
        <a href="club_merchandise.jsp">Manage Merchandise</a> |
        <a href="../logout">Logout</a>
    </nav>
    <main>

        <section>
            <h2>Club Profile Status</h2>
            <% if (hasClubProfile) { %>
                <p>Your club profile is active: <strong><%= clubName %></strong></p>
            <% } else { %>
                <div class="no-club">
                    <p>No club profile found for your account.</p>
                    <a class="create-btn" href="create_club.jsp">Create Club Profile</a>
                </div>
            <% } %>
        </section>

        <section>
            <h2>Quick Stats</h2>
            <div class="stats">
                <div>
                    <h3>Upcoming Events</h3>
                    <p><%= upcomingEvents %></p>
                </div>
                <div>
                    <h3>Active Members</h3>
                    <p><%= activeMembers %></p>
                </div>
                <div>
                    <h3>Pending Member Requests</h3>
                    <p><%= pendingRequests %></p>
                </div>
            </div>
        </section>

        <section>
            <h2>Recent Activities</h2>
            <ul>
                <li>Event "Spring Gala" created on 2025-05-10</li>
                <li>Member "John Doe" approved</li>
                <li>Event "Tech Talk" updated</li>
                <!-- Replace with dynamic activities later -->
            </ul>
        </section>
    </main>
</body>
</html>