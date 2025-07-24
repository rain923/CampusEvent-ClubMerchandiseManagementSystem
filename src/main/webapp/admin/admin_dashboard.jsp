<%-- 
    Document   : admin_dashboard
    Created on : Jul 22, 2025, 8:15:02?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    if (session == null || session.getAttribute("userEmail") == null || !"system_admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String adminEmail = (String) session.getAttribute("userEmail");

    String filter = request.getParameter("filter");
    if (filter == null) filter = "all";

    int totalStudents = 0;
    int totalClubAdmins = 0;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        // Total students
        PreparedStatement psStudent = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE user_type='student'");
        ResultSet rsStudent = psStudent.executeQuery();
        if (rsStudent.next()) totalStudents = rsStudent.getInt(1);
        rsStudent.close();
        psStudent.close();

        // Total club admins
        PreparedStatement psClubAdmin = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE user_type='club_admin'");
        ResultSet rsClubAdmin = psClubAdmin.executeQuery();
        if (rsClubAdmin.next()) totalClubAdmins = rsClubAdmin.getInt(1);
        rsClubAdmin.close();
        psClubAdmin.close();

        conn.close();
    } catch (Exception e) {
        out.println("Error counting users: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>System Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f8fc; margin: 0; }
        header { background-color: #333; color: white; padding: 20px; text-align: center; }
        header nav a { color: white; margin: 0 10px; }
        h2 { color: #333; text-align: center; margin-top: 30px; }
        .stats-boxes { display: flex; justify-content: center; margin: 20px 0; }
        .box { background: #fff; padding: 20px; margin: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); width: 200px; text-align: center; }
        .box h3 { margin: 0 0 10px; color: #005f99; }
        .box p { font-size: 24px; margin: 0; }
        form.filter { text-align: center; margin-bottom: 20px; }
        table { width: 90%; margin: 0 auto 30px; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #ddd; }
        a.button { background-color: #333; color: white; padding: 5px 10px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #555; }
    </style>
</head>
<body>
<header>
    <h1>System Admin Dashboard</h1>
    <p>Welcome, <%= adminEmail %></p>
    <nav>
        <a href="admin_manage_clubs.jsp">Manage Clubs</a> |
        <a href="../logout">Logout</a>
    </nav>
</header>

<div class="stats-boxes">
    <div class="box">
        <h3>Total Students</h3>
        <p><%= totalStudents %></p>
    </div>
    <div class="box">
        <h3>Total Club Admins</h3>
        <p><%= totalClubAdmins %></p>
    </div>
</div>

<!-- Pending Club Admin Approvals -->
<h2>Pending Club Admin Approvals</h2>
<table>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <%
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

            String sql = "SELECT * FROM users WHERE user_type = 'club_admin' AND status = 'pending'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String status = rs.getString("status");

                out.println("<tr>");
                out.println("<td>" + name + "</td>");
                out.println("<td>" + email + "</td>");
                out.println("<td>" + status + "</td>");
                out.println("<td>");
                out.println("<a class='button' href='approve_club_admin.jsp?id=" + id + "'>Approve</a> ");
                out.println("<a class='button' href='reject_club_admin.jsp?id=" + id + "'>Reject</a>");
                out.println("</td>");
                out.println("</tr>");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>

<!-- Filter Users -->
<form class="filter" method="get" action="admin_dashboard.jsp">
    <label for="filter">Filter by User Type:</label>
    <select name="filter" id="filter" onchange="this.form.submit()">
        <option value="all" <%= "all".equals(filter) ? "selected" : "" %>>All</option>
        <option value="student" <%= "student".equals(filter) ? "selected" : "" %>>Student</option>
        <option value="club_admin" <%= "club_admin".equals(filter) ? "selected" : "" %>>Club Admin</option>
    </select>
</form>

<h2>All Users</h2>
<table>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>User Type</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <%
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

            String sql = "SELECT * FROM users WHERE user_type != 'system_admin'";
            if (!"all".equals(filter)) {
                sql += " AND user_type = ?";
            }
            PreparedStatement ps = conn.prepareStatement(sql);
            if (!"all".equals(filter)) {
                ps.setString(1, filter);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                String email = rs.getString("email");
                String userType = rs.getString("user_type");
                String status = rs.getString("status");

                out.println("<tr>");
                out.println("<td>" + name + "</td>");
                out.println("<td>" + email + "</td>");
                out.println("<td>" + userType + "</td>");
                out.println("<td>" + status + "</td>");
                out.println("<td>");

                // Delete button for all club admins
                if ("club_admin".equals(userType)) {
                    out.println("<a class='button' href='delete_club_admin.jsp?id=" + id + "' onclick='return confirm(\"Are you sure to delete this club admin?\")'>Delete</a>");
                } else {
                    out.println("-");
                }

                out.println("</td>");
                out.println("</tr>");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
        }
    %>
</table>
</body>
</html>