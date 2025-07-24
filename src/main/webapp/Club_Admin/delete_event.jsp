<%-- 
    Document   : delete_event
    Created on : Jul 22, 2025, 6:03:47?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int eventId = Integer.parseInt(request.getParameter("id"));

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

     
        String deleteParticipation = "DELETE FROM event_participants WHERE event_id = ?";
        PreparedStatement ps1 = conn.prepareStatement(deleteParticipation);
        ps1.setInt(1, eventId);
        ps1.executeUpdate();
        ps1.close();

   
        String deleteEvent = "DELETE FROM events WHERE id = ?";
        PreparedStatement ps2 = conn.prepareStatement(deleteEvent);
        ps2.setInt(1, eventId);
        ps2.executeUpdate();
        ps2.close();

        conn.close();

        response.sendRedirect("club_events.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
