<%-- 
    Document   : profile
    Created on : Jul 22, 2025, 12:48:22?AM
    Author     : User
--%>
<%@ page import="java.sql.*" %>
<%
    // Retrieve session email without redeclaring session
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
    <title>Your Profile</title>
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
        .profile-box {
            background-color: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .profile-box h2 {
            color: #005f99;
        }
        .profile-info {
            margin: 15px 0;
        }
        .profile-info strong {
            display: inline-block;
            width: 120px;
            color: #333;
        }
        .edit-btn {
            display: inline-block;
            margin-top: 20px;
            background-color: #007acc;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: bold;
        }
        .edit-btn:hover {
            background-color: #005f99;
        }
    </style>
</head>
<body>
    <header>
        <h1>Your Profile</h1>
        <nav>
            <a href="dashboard.jsp">Back to Dashboard</a>
        </nav>
    </header>
    <main>
        <div class="profile-box">
            <h2>Profile Details</h2>
            <div class="profile-info">
                <strong>Name:</strong> <%= name %>
            </div>
            <div class="profile-info">
                <strong>Email:</strong> <%= email %>
            </div>
            <div class="profile-info">
                <strong>User Type:</strong> <%= userType %>
            </div>
            <a href="edit_profile.jsp" class="edit-btn">Edit Profile</a>
        </div>
    </main>
</body>
</html>