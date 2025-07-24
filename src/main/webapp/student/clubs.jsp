<%-- 
    Document   : clubs
    Created on : Jul 22, 2025, 12:21:40?AM
    Author     : User
--%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.campus.dao.ClubDAO" %>
<%@ page import="com.campus.models.Club" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    HttpSession s = request.getSession(false);
    if (s == null || s.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = (int) s.getAttribute("userId");

    ClubDAO clubDAO = new ClubDAO();
    Club myClub = clubDAO.getClubByUserId(userId);
    ArrayList<Club> clubList = clubDAO.getAllClubs();

    // Remove joined club from all clubs list
    if (myClub != null) {
        clubList.removeIf(c -> c.getId() == myClub.getId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Clubs</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f8fc; margin: 0; padding: 0; }
        header { background-color: #005f99; color: white; padding: 20px 0; text-align: center; }
        nav { margin-top: 10px; }
        nav a { color: white; text-decoration: none; font-weight: bold; margin: 0 10px; }
        nav a:hover { text-decoration: underline; }
        main { max-width: 1000px; margin: 30px auto; padding: 0 20px; }
        h2 { border-bottom: 2px solid #ccc; padding-bottom: 5px; color: #005f99; }
        .club { background-color: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .club h3 { color: #005f99; margin-top: 0; }
        .club p { margin: 10px 0; }
        .club a { color: #007acc; text-decoration: none; font-weight: bold; }
        .club a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <header>
        <h1>Campus Clubs</h1>
        <nav>
            <a href="dashboard.jsp">Back to Dashboard</a>
        </nav>
    </header>

    <main>
        <!-- My Club Section -->
        <section>
            <h2>My Club</h2>
            <% if (myClub != null) { %>
                <div class="club">
                    <h3><%= myClub.getName() %></h3>
                    <p><%= myClub.getDescription() %></p>
                    <a href="view_club.jsp?id=<%= myClub.getId() %>">View Club</a>
                    <br>
                    <a href="leave_club.jsp" style="color:red; font-weight:bold;">Leave Club</a>
                </div>
            <% } else { %>
                <p>You have not joined any club yet.</p>
            <% } %>
        </section>

        <!-- All Clubs Section -->
        <section>
            <h2>All Clubs</h2>
            <% if (clubList != null && !clubList.isEmpty()) {
                for (Club c : clubList) { %>
                    <div class="club">
                        <h3><%= c.getName() %></h3>
                        <p><%= c.getDescription() %></p>
                        <a href="view_club.jsp?id=<%= c.getId() %>">View Club</a>
                        <br>
                        <a href="join_club.jsp?id=<%= c.getId() %>" style="color:green; font-weight:bold;">Join Club</a>
                    </div>
            <%  }
            } else { %>
                <p>No other clubs available.</p>
            <% } %>
        </section>

    </main>
</body>
</html>