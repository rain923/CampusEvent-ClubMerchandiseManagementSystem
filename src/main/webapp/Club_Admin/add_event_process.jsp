<%-- 
    Document   : add_event_process
    Created on : Jul 22, 2025, 6:02:24?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    String eventName = request.getParameter("eventName");
    String eventDate = request.getParameter("eventDate");
    String location = request.getParameter("location");
    double fee = Double.parseDouble(request.getParameter("fee"));
    String description = request.getParameter("description");
    int clubId = Integer.parseInt(request.getParameter("clubId")); // ? read from form

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "INSERT INTO events (event_name, event_date, location, payment, description, club_id) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, eventName);
        ps.setDate(2, Date.valueOf(eventDate));
        ps.setString(3, location);
        ps.setDouble(4, fee);
        ps.setString(5, description);
        ps.setInt(6, clubId);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("club_events.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>