<%-- 
    Document   : admin_manage_clubs
    Created on : Jul 22, 2025, 9:21:13?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    // ? Check system admin session
    if (session == null || !"system_admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String message = request.getParameter("message");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Clubs</title>
    <style>
        body { font-family: Arial; background-color: #f4f8fc; margin: 0; }
        header { background-color: #333; color: white; padding: 20px; text-align: center; }
        table { width: 90%; margin: 30px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #ddd; }
        .button { background-color: #c0392b; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; }
        .button:hover { background-color: #e74c3c; }
        .message { text-align: center; color: green; font-weight: bold; }
    </style>
</head>
<body>
    <header>
        <h1>System Admin - Manage Clubs</h1>
        <nav>
            <a href="admin_dashboard.jsp" style="color:white;">Dashboard</a> |
            <a href="../logout" style="color:white;">Logout</a>
        </nav>
    </header>

    <% if (message != null) { %>
        <p class="message"><%= message %></p>
    <% } %>

    <table>
        <tr>
            <th>ID</th>
            <th>Club Name</th>
            <th>Category</th>
            <th>Founded Year</th>
            <th>Admin ID</th>
            <th>Actions</th>
        </tr>

        <%
            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                );

                String sql = "SELECT * FROM clubs";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String name = rs.getString("club_name");
                    String category = rs.getString("category");
                    String founded = rs.getString("founded_year");
                    int adminId = rs.getInt("admin_id");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= category %></td>
            <td><%= founded %></td>
            <td><%= adminId %></td>
            <td>
                <a class="button" href="delete_club.jsp?id=<%= id %>" onclick="return confirm('Are you sure you want to delete this club?');">Delete</a>
            </td>
        </tr>
        <%
                }

                rs.close();
                ps.close();
                conn.close();

            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>
</body>
</html>