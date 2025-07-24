<%-- 
    Document   : edit_merchandise
    Created on : Jul 22, 2025, 6:58:16?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    int merchId = Integer.parseInt(request.getParameter("id"));
    String name = "", description = "";
    double price = 0.0;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:derby://localhost:1527/GroupProject584", "app", "app"
        );

        String sql = "SELECT * FROM merchandise WHERE id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, merchId);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            name = rs.getString("name");
            price = rs.getDouble("price");
            description = rs.getString("description");
        }

        rs.close();
        ps.close();
        conn.close();

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Edit Merchandise</title>
    <style>
        body { font-family: Arial; background: #f0f9f4; margin: 0; padding: 0; }
        header { background: #2b7a0b; color: white; padding: 20px; text-align: center; }
        main { max-width: 600px; margin: 30px auto; background: white; padding: 20px; border-radius: 8px; }
        label { font-weight: bold; color: #1f5f06; }
        input, textarea { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 4px; }
        button { background: #2b7a0b; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
        button:hover { background: #1f5f06; }
    </style>
</head>
<body>
    <header>
        <h1>Edit Merchandise</h1>
    </header>
    <main>
        <form action="edit_merchandise_process.jsp" method="post">
            <input type="hidden" name="id" value="<%= merchId %>">

            <label>Name:</label>
            <input type="text" name="name" value="<%= name %>" required>

            <label>Price (RM):</label>
            <input type="number" name="price" step="0.01" value="<%= price %>" required>

            <label>Description:</label>
            <textarea name="description" rows="4" required><%= description %></textarea>

            <button type="submit">Update Merchandise</button>
        </form>
        <p><a href="club_merchandise.jsp">Back to Merchandise</a></p>
    </main>
</body>
</html>