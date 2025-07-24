<%-- 
    Document   : update_club_profile
    Created on : Jul 22, 2025, 5:45:55?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    // Check if user is logged in
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // Retrieve updated data from form
    request.setCharacterEncoding("UTF-8"); // to support special characters
    int clubId = Integer.parseInt(request.getParameter("clubId"));
    String clubName = request.getParameter("clubName");
    String clubDescription = request.getParameter("clubDescription");
    String clubCategory = request.getParameter("clubCategory");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        // Update club details
        String sql = "UPDATE clubs SET club_name = ?, description = ?, category = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, clubName);
        ps.setString(2, clubDescription);
        ps.setString(3, clubCategory);
        ps.setInt(4, clubId);

        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            out.println("<script>alert('Club profile updated successfully.');location='manage_club_profile.jsp';</script>");
        } else {
            out.println("<script>alert('Update failed. Please try again.');location='manage_club_profile.jsp';</script>");
        }

        ps.close();
        conn.close();

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>