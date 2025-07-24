<%-- 
    Document   : manage_members
    Created on : Jul 22, 2025, 7:10:01?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Members</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        table { width: 90%; margin: 20px auto; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background-color: #d9f2e6; }
        a.button { background-color: #2b7a0b; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; }
        a.button:hover { background-color: #1f5f06; }
    </style>
</head>
<body>
    <header>
        <h1>Manage Members</h1>
        <nav><a href="club_dashboard.jsp" style="color:white;">Back to Dashboard</a></nav>
    </header>

    <main>
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
                    Connection conn = DriverManager.getConnection(
                        "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
                    );

                    // Get club_id based on admin email
                    String clubSql = "SELECT c.id FROM clubs c JOIN users u ON c.admin_id = u.id WHERE u.email = ?";
                    PreparedStatement clubPs = conn.prepareStatement(clubSql);
                    clubPs.setString(1, userEmail);
                    ResultSet clubRs = clubPs.executeQuery();

                    int clubId = 0;
                    if (clubRs.next()) {
                        clubId = clubRs.getInt("id");
                    } else {
                        out.println("<tr><td colspan='4'>No club found for your account.</td></tr>");
                    }

                    clubRs.close();
                    clubPs.close();

                    // Retrieve members from club_members joined with users table
                    String sql = "SELECT u.id, u.name, u.email, cm.status " +
                                 "FROM club_members cm " +
                                 "JOIN users u ON cm.user_id = u.id " +
                                 "WHERE cm.club_id = ?";
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, clubId);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        int memberId = rs.getInt("id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String status = rs.getString("status");

                        out.println("<tr>");
                        out.println("<td>" + name + "</td>");
                        out.println("<td>" + email + "</td>");
                        out.println("<td>" + status + "</td>");
                        out.println("<td>");
                        if ("pending".equalsIgnoreCase(status)) {
                            out.println("<a class='button' href='approve_member.jsp?id=" + memberId + "'>Approve</a> ");
                            out.println("<a class='button' href='reject_member.jsp?id=" + memberId + "'>Reject</a> ");
                        } else {
                            if ("active".equalsIgnoreCase(status)) {
                                out.println("<a class='button' href='deactivate_member.jsp?id=" + memberId + "'>Deactivate</a> ");
                            } else if ("inactive".equalsIgnoreCase(status)) {
                                out.println("<a class='button' href='activate_member.jsp?id=" + memberId + "'>Activate</a> ");
                            }
                            out.println("<a class='button' href='delete_member.jsp?id=" + memberId + "' onclick=\"return confirm('Are you sure?');\">Delete</a>");
                        }
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
    </main>
</body>
</html>