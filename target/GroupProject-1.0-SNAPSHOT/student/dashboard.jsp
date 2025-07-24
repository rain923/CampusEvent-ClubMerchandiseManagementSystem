<%-- 
    Document   : dashboard
    Created on : Jul 22, 2025, 5:00:52?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%  
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName"); // assuming you store userName in session on login

    // Example placeholders for quick stats (replace with real DB queries later)
    int upcomingEvents = 5;
    int yourClubs = 2;
    int recentAnnouncements = 3;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Campus System</title>

    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.css" rel="stylesheet">

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
            color: #005f99;
        }

        .stats {
            display: flex;
            justify-content: space-around;
            margin-top: 15px;
        }

        .stats div {
            background-color: #e6f0fa;
            padding: 15px;
            border-radius: 6px;
            flex: 1;
            margin: 5px;
            text-align: center;
            font-weight: bold;
            color: #003f66;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }

        .activity-feed {
            list-style-type: none;
            padding: 0;
        }

        .activity-feed li {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .activity-feed li:last-child {
            border-bottom: none;
        }

        .activity-feed .timestamp {
            color: #888;
            font-size: 12px;
            float: right;
        }

        #calendar {
            max-width: 900px;
            margin: 0 auto;
        }
    </style>
</head>
<body>
    <header>
        <h1>Welcome, <%= (userName != null ? userName : "User")%>!</h1>
        <nav>
            <a href="../EventServlet">Events</a> | 
            <a href="clubs.jsp">Clubs</a> |
            <a href="orders.jsp">My Orders</a> |
            <a href="profile.jsp">Profile</a> | 
            <a href="../logout">Logout</a>
        </nav>
    </header>

    <main>
        <section>
            <h2>Quick Stats</h2>
            <div class="stats">
                <div>Upcoming Events: <%= upcomingEvents %></div>
                <div>Your Clubs: <%= yourClubs %></div>
                <div>Recent Announcements: <%= recentAnnouncements %></div>
            </div>
        </section>

        <section>
            <h2>Calendar</h2>
            <div id="calendar"></div>
        </section>

        <section>
            <h2>Recent Activities</h2>
            <ul class="activity-feed">
                <li>Joined Tech Club <span class="timestamp">2 hours ago</span></li>
                <li>Registered for Robotics Workshop <span class="timestamp">Yesterday</span></li>
                <li>Updated profile information <span class="timestamp">3 days ago</span></li>
                <!-- Replace with dynamic activities from DB later -->
            </ul>
        </section>
    </main>

    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@5.11.3/main.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var calendarEl = document.getElementById('calendar');
            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: 'dayGridMonth',
                headerToolbar: {
                    left: 'prev,next today',
                    center: 'title',
                    right: 'dayGridMonth,timeGridWeek,timeGridDay'
                }
            });
            calendar.render();
        });
    </script>
</body>
</html>