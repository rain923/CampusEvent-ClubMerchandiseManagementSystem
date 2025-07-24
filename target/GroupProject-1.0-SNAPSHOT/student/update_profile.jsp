<%-- 
    Document   : update_profile
    Created on : Jul 22, 2025, 1:00:09?AM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    // Get updated form data
    String newName = request.getParameter("name");
    String newEmail = request.getParameter("email");
    String userType = request.getParameter("userType");

    // Get current session email (logged in user)
    String currentEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

    if (currentEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String sql = "UPDATE users SET name = ?, email = ? WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, newName);
        ps.setString(2, newEmail);
        ps.setString(3, currentEmail);

        int rowsUpdated = ps.executeUpdate();

        ps.close();
        conn.close();

        if (rowsUpdated > 0) {
            // Update session email if user changed email
            session.setAttribute("userEmail", newEmail);
%>
            <script>
                alert('Profile updated successfully.');
                window.location.href = 'profile.jsp';
            </script>
<%
        } else {
%>
            <script>
                alert('Update failed. Please try again.');
                window.location.href = 'edit_profile.jsp';
            </script>
<%
        }

    } catch (Exception e) {
%>
        <p>Error: <%= e.getMessage() %></p>
<%
    }
%>