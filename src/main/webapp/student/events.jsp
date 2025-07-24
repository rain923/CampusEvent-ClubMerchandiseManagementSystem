<%-- 
    Document   : events
    Created on : Jun 29, 2025, 8:41:16?PM
    Author     : User
--%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.campus.models.Event" %>
<%
    ArrayList<Event> eventList = (ArrayList<Event>) request.getAttribute("eventList");
    ArrayList<Event> joinedEvents = (ArrayList<Event>) request.getAttribute("joinedEvents");
    Integer userId = (Integer) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>List Events</title>
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

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        table th, table td {
            padding: 12px 15px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        table th {
            background-color: #005f99;
            color: white;
        }

        table tr:hover {
            background-color: #f1f1f1;
        }

        button {
            background-color: #005f99;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
        }

        button:hover {
            background-color: #003f66;
        }

        a.button-link {
            background-color: #e6f0fa;
            padding: 6px 12px;
            border-radius: 4px;
            text-decoration: none;
            color: #003f66;
            font-weight: bold;
        }

        a.button-link:hover {
            background-color: #cce0f5;
        }

        .my-events {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .my-events h2 {
            color: #005f99;
            margin-top: 0;
        }

        .no-events {
            color: #666;
            font-style: italic;
        }
    </style>
</head>
<body>
    <header>
        <h1>List Events</h1>
        <nav>
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp">Back to Dashboard</a>
        </nav>
    </header>
    <main>
        <table>
            <thead>
                <tr>
                    <th>Event Name</th>
                    <th>Date</th>
                    <th>Location</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (eventList != null && !eventList.isEmpty()) { 
                    for (Event e : eventList) { 
                        boolean isJoined = joinedEvents != null && joinedEvents.stream().anyMatch(je -> je.getId() == e.getId());
                %>
                <tr>
                    <td><%= e.getName() %></td>
                    <td><%= e.getDate() %></td>
                    <td><%= e.getLocation() %></td>
                    <td>
                        <a class="button-link" href="${pageContext.request.contextPath}/student/view_event.jsp?id=<%= e.getId() %>">View</a>
                        <button onclick="joinEvent(<%= e.getId() %>, <%= userId %>)" <%= isJoined ? "disabled" : "" %>>
                            <%= isJoined ? "Joined" : "Join" %>
                        </button>
                    </td>
                </tr>
                <% } 
                } else { %>
                <tr>
                    <td colspan="4">No events found.</td>
                </tr>
                <% } %>
            </tbody>
        </table>

        <div class="my-events">
            <h2>My Event Participation</h2>
            <% if (joinedEvents != null && !joinedEvents.isEmpty()) { %>
                <table>
                    <thead>
                        <tr>
                            <th>Event Name</th>
                            <th>Date</th>
                            <th>Location</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Event e : joinedEvents) { %>
                        <tr>
                            <td><%= e.getName() %></td>
                            <td><%= e.getDate() %></td>
                            <td><%= e.getLocation() %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } else { %>
                <p class="no-events">You haven't joined any events yet.</p>
            <% } %>
        </div>
    </main>

    <script>
        function joinEvent(eventId) {
    if (!confirm("Join this event?")) return;
    
    fetch('EventServlet?action=join&eventId=' + eventId, {
        credentials: 'include' // Important for session cookies
    })
    .then(response => {
        if (response.status === 401) {
            window.location.href = '${pageContext.request.contextPath}/login.jsp?reason=session_expired';
            return Promise.reject('Unauthorized');
        }
        return response.text();
    })
    .then(text => {
        switch(text) {
            case 'success':
                location.reload();
                break;
            case 'already_joined':
                alert('You have already joined this event');
                location.reload();
                break;
            case 'invalid_event':
                alert('Invalid event selection');
                break;
            default:
                alert('Error: ' + text);
        }
    })
    .catch(error => {
        console.error('Error:', error);
    });
}
    </script>
</body>
</html>