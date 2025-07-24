<%-- 
    Document   : edit_profile
    Created on : Jul 22, 2025, 12:52:20?AM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    // Use existing implicit session object
    String email = (session != null) ? (String) session.getAttribute("userEmail") : null;

    String name = "";
    String userType = "";

    if (email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String sql = "SELECT name, user_type FROM users WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            userType = rs.getString("user_type");
        }

        rs.close();
        ps.close();
        conn.close();

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
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
            font-weight: bold;
        }
        nav a:hover {
            text-decoration: underline;
        }
        main {
            max-width: 600px;
            margin: 40px auto;
            padding: 0 20px;
        }
        form {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        label {
            display: block;
            margin: 15px 0 5px;
            color: #333;
        }
        input[type="text"], input[type="email"] {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .submit-btn {
            margin-top: 20px;
            background-color: #007acc;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
        }
        .submit-btn:hover {
            background-color: #005f99;
        }
    </style>
</head>
<body>
    <header>
        <h1>Edit Profile</h1>
        <nav>
            <a href="profile.jsp">Back to Profile</a>
        </nav>
    </header>
    <main>
        <form action="update_profile.jsp" method="post">
            <label for="name">Name:</label>
            <input type="text" name="name" value="<%= name %>" required>

            <label for="email">Email:</label>
            <input type="email" name="email" value="<%= email %>" readonly>

            <label for="userType">User Type:</label>
            <input type="text" name="userType" value="<%= userType %>" readonly>

            <button type="submit" class="submit-btn">Update Profile</button>
        </form>
    </main>
</body>
</html>