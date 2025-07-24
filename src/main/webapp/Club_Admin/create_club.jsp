<%-- 
    Document   : create_club
    Created on : Jul 22, 2025, 9:06:34?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || !"club_admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Club Profile</title>
    <style>
        body { font-family: Arial; background-color: #f4f8fc; }
        form { max-width: 500px; margin: 50px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        div { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #005f99; }
        input[type="text"], textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { background-color: #007acc; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; }
        button:hover { background-color: #005f99; }
        p { color: green; text-align: center; }
    </style>
</head>
<body>

<form action="create_club_process.jsp" method="post">
    <h2>Create Club Profile</h2>
    <% if (message != null) { %>
        <p><%= message %></p>
    <% } %>
    <div>
        <label>Club Name:</label>
        <input type="text" name="club_name" required>
    </div>
    <div>
        <label>Category:</label>
        <input type="text" name="category" required>
    </div>
    <div>
        <label>Founded Year:</label>
        <input type="text" name="founded_year" required>
    </div>
    <div>
        <label>Description:</label>
        <textarea name="description" required></textarea>
    </div>
    <button type="submit">Create Club</button>
</form>

</body>
</html>