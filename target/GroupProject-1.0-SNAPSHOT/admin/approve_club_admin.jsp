<%-- 
    Document   : approve_club_admin
    Created on : Jul 22, 2025, 8:53:30?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    // Check admin session
    if (session == null || session.getAttribute("userEmail") == null || 
        !"system_admin".equals(session.getAttribute("userType"))) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String id = request.getParameter("id");

    if (id != null) {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            Connection conn = DriverManager.getConnection(
                "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
            );

            String sql = "UPDATE users SET status = 'active' WHERE id = ? AND user_type = 'club_admin'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(id));

            int rows = ps.executeUpdate();

            if (rows > 0) {
                out.println("<script>alert('Club admin approved successfully.');window.location='admin_dashboard.jsp';</script>");
            } else {
                out.println("<script>alert('Approval failed.');window.location='admin_dashboard.jsp';</script>");
            }

            ps.close();
            conn.close();

        } catch (Exception e) {
            out.println("<script>alert('Error: " + e.getMessage() + "');window.location='admin_dashboard.jsp';</script>");
        }
    } else {
        out.println("<script>alert('No ID provided.');window.location='admin_dashboard.jsp';</script>");
    }
%>