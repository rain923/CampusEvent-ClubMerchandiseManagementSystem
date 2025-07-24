<%-- 
    Document   : edit_event_process
    Created on : Jul 22, 2025, 6:03:26?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int eventId = Integer.parseInt(request.getParameter("eventId"));
    String eventName = request.getParameter("eventName");
    String eventDate = request.getParameter("eventDate");
    String location = request.getParameter("location");
    double fee = Double.parseDouble(request.getParameter("fee")); // ? changed to fee input
    String description = request.getParameter("description");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "UPDATE events SET event_name = ?, event_date = ?, location = ?, payment = ?, description = ? WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, eventName);
        ps.setDate(2, Date.valueOf(eventDate));
        ps.setString(3, location);
        ps.setDouble(4, fee); // ? uses payment column
        ps.setString(5, description);
        ps.setInt(6, eventId);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("club_events.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>