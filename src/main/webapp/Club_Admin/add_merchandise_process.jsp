<%-- 
    Document   : add_merchandise_process
    Created on : Jul 22, 2025, 6:56:14?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");

    String name = request.getParameter("name");
    double price = Double.parseDouble(request.getParameter("price"));
    String description = request.getParameter("description");
    int clubId = 0;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        // Get clubId based on user email
        String clubSql = "SELECT c.id FROM clubs c JOIN users u ON c.admin_id = u.id WHERE u.email = ?";
        PreparedStatement clubPs = conn.prepareStatement(clubSql);
        clubPs.setString(1, userEmail);
        ResultSet clubRs = clubPs.executeQuery();

        if (clubRs.next()) {
            clubId = clubRs.getInt("id");
        } else {
            out.println("No club found for your account.");
            return;
        }

        clubRs.close();
        clubPs.close();

        // Insert merchandise with club_id
        String sql = "INSERT INTO merchandise (name, price, description, club_id) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, name);
        ps.setDouble(2, price);
        ps.setString(3, description);
        ps.setInt(4, clubId);

        ps.executeUpdate();

        ps.close();
        conn.close();

        response.sendRedirect("club_merchandise.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>