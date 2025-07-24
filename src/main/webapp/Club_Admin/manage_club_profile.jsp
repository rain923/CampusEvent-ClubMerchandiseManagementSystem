<%-- 
    Document   : manage_club_profile
    Created on : Jul 22, 2025, 5:32:22?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
    int clubId = 0;
    String clubName = "";
    String clubDescription = "";
    String clubCategory = "";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        // Get club details based on club admin email
        String sql = "SELECT c.id, c.club_name, c.description, c.category "
                   + "FROM clubs c JOIN users u ON c.admin_id = u.id "
                   + "WHERE u.email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, userEmail);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            clubId = rs.getInt("id");
            clubName = rs.getString("club_name");
            clubDescription = rs.getString("description");
            clubCategory = rs.getString("category");
        } else {
            out.println("<p>No club profile found for your account.</p>");
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
    <meta charset="UTF-8" />
    <title>Manage Club Profile</title>
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
            text-align: center;
            background-color: #d4ecd1;
            padding: 10px 0;
        }

        nav a {
            color: #2b7a0b;
            text-decoration: none;
            margin: 0 15px;
            font-weight: bold;
        }

        nav a:hover {
            text-decoration: underline;
        }

        main {
            max-width: 600px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        h2 {
            color: #2b7a0b;
            text-align: center;
        }

        form div {
            margin-bottom: 15px;
        }

        label {
            display: block;
            margin-bottom: 5px;
            color: #1f5f06;
            font-weight: bold;
        }

        input[type="text"],
        textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            background-color: #2b7a0b;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
            width: 100%;
        }

        button:hover {
            background-color: #1f5f06;
        }
    </style>
</head>
<body>
    <header>
        <h1>Manage Club Profile</h1>
    </header>

    <nav>
        <a href="club_dashboard.jsp">Back to Dashboard</a>
    </nav>

    <main>
        <h2>Edit Club Details</h2>
        <form action="update_club_profile.jsp" method="post">
            <input type="hidden" name="clubId" value="<%= clubId %>">

            <div>
                <label>Club Name:</label>
                <input type="text" name="clubName" value="<%= clubName %>" required>
            </div>

            <div>
                <label>Description:</label>
                <textarea name="clubDescription" rows="4" required><%= clubDescription %></textarea>
            </div>

            <div>
                <label>Category:</label>
                <input type="text" name="clubCategory" value="<%= clubCategory %>" required>
            </div>

            <button type="submit">Update Profile</button>
        </form>
    </main>
</body>
</html>