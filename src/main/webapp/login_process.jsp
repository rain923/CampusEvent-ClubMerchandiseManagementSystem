<%-- 
    Document   : login_process
    Created on : Jun 29, 2025, 7:58:03?PM
    Author     : User
--%>

<%@ page import="java.sql.*, java.security.*" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "SELECT * FROM users WHERE email = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, email);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            String dbPassword = rs.getString("password");
            String userType = rs.getString("user_type");
            int userId = rs.getInt("id");
            String userName = rs.getString("name"); 

            if (password.equals(dbPassword)) {

            
                session.setAttribute("userId", userId);
                session.setAttribute("userEmail", email);
                session.setAttribute("userName", userName); 
                session.setAttribute("userType", userType);

                
                if (userType.equals("student")) {
                    response.sendRedirect("student/dashboard.jsp"); 
                } else if (userType.equals("club_admin")) {
                    response.sendRedirect("Club_Admin/club_dashboard.jsp");
                } else if (userType.equals("system_admin")) {
                    response.sendRedirect("admin/admin_dashboard.jsp");
                }

            } else {
                out.println("<script>alert('Invalid password.');location='login.jsp';</script>");
            }

        } else {
            out.println("<script>alert('User not found.');location='login.jsp';</script>");
        }

        rs.close();
        ps.close();
        conn.close();

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>