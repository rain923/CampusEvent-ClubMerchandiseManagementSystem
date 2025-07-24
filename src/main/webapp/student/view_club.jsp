<%-- 
    Document   : view_club
    Created on : Jun 29, 2025, 9:46:37?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    // Get session safely
    String userEmail = (session != null) ? (String) session.getAttribute("userEmail") : null;

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String id = request.getParameter("id");

    String name = "";
    String category = "";
    String founded = "";
    String members = "";
    String description = "";
    String adminName = "";
    String adminEmail = "";

    Connection conn = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        // Retrieve club details
        String sql = "SELECT c.club_name, c.category, c.founded_year, c.members_count, c.description, u.name AS admin_name, u.email AS admin_email "
                   + "FROM clubs c JOIN users u ON c.admin_id = u.id WHERE c.id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(id));

        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("club_name");
            category = rs.getString("category");
            founded = rs.getString("founded_year");
            members = rs.getString("members_count");
            description = rs.getString("description");
            adminName = rs.getString("admin_name");
            adminEmail = rs.getString("admin_email");
        }

        rs.close();
        ps.close();

        // Retrieve merchandise for this club
        String merchSql = "SELECT * FROM merchandise WHERE club_id = ?";
        PreparedStatement merchPs = conn.prepareStatement(merchSql);
        merchPs.setInt(1, Integer.parseInt(id));
        ResultSet merchRs = merchPs.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Club</title>

    <!-- ? Font Awesome CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f8fc;
            margin: 0;
            padding: 0;
        }

        header {
            background-color: #005f99;
            color: white;
            padding: 20px;
            text-align: center;
        }

        nav a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        nav a:hover {
            text-decoration: underline;
        }

        main {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        h2 {
            color: #005f99;
        }

        .info {
            margin: 15px 0;
        }

        .merchandise, .members {
            margin-top: 30px;
        }

        .merch-item, .member-item {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 6px;
        }

        .merch-item h3 {
            margin: 0 0 10px 0;
            color: #333;
        }

        .merch-item p, .member-item p {
            margin: 5px 0;
        }

        .merch-item .price {
            font-weight: bold;
            color: #005f99;
        }

        .merch-item form {
            margin-top: 10px;
        }

        input[type="number"] {
            width: 60px;
            padding: 5px;
        }

        .cart-btn {
            background-color: #007acc;
            color: white;
            border: none;
            padding: 7px 15px;
            border-radius: 4px;
            font-weight: bold;
            cursor: pointer;
        }

        .cart-btn:hover {
            background-color: #005f99;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            background-color: #007acc;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
        }

        .back-link:hover {
            background-color: #005f99;
        }
    </style>
</head>
<body>
    <header>
        <h1>Club Details</h1>
        <nav>
            <a href="clubs.jsp">Back to Clubs</a> |
            <a href="cart.jsp"><i class="fa-solid fa-cart-shopping"></i> Cart</a>
        </nav>
    </header>

    <main>
        <h2><%= name %></h2>
        <div class="info"><strong>Category:</strong> <%= category %></div>
        <div class="info"><strong>Founded:</strong> <%= founded %></div>
        <div class="info"><strong>Members:</strong> <%= members %></div>
        <div class="info"><strong>Description:</strong> <%= description %></div>
        <div class="info"><strong>Club Admin:</strong> <%= adminName %> (<%= adminEmail %>)</div>

        <!-- Merchandise section -->
        <div class="merchandise">
            <h2>Merchandise</h2>

<%
        boolean hasMerch = false;
        while (merchRs.next()) {
            hasMerch = true;
            int merchId = merchRs.getInt("id");
%>
            <div class="merch-item">
                <h3><%= merchRs.getString("name") %></h3>
                <p><%= merchRs.getString("description") %></p>
                <p class="price">RM <%= merchRs.getBigDecimal("price") %></p>

                <form action="add_to_cart.jsp" method="post">
                    <input type="hidden" name="merch_id" value="<%= merchId %>">
                    <input type="hidden" name="user_email" value="<%= userEmail %>">
                    <label>Quantity:
                        <input type="number" name="quantity" value="1" min="1" required>
                    </label>
                    <button type="submit" class="cart-btn">Add to Cart</button>
                </form>
            </div>
<%
        }
        if (!hasMerch) {
%>
            <p>No merchandise available for this club yet.</p>
<%
        }

        merchRs.close();
        merchPs.close();
%>
        </div>

        <!-- Club Members section with numbering -->
        <div class="members">
            <h2>Club Members</h2>
<%
        String memberSql = "SELECT u.name, u.email FROM club_members cm JOIN users u ON cm.user_id = u.id WHERE cm.club_id = ?";
        PreparedStatement memberPs = conn.prepareStatement(memberSql);
        memberPs.setInt(1, Integer.parseInt(id));
        ResultSet memberRs = memberPs.executeQuery();

        boolean hasMembers = false;
        int count = 1;

        while (memberRs.next()) {
            hasMembers = true;
%>
            <div class="member-item">
                <p><strong><%= count %>. <%= memberRs.getString("name") %></strong> (<%= memberRs.getString("email") %>)</p>
            </div>
<%
            count++;
        }
        if (!hasMembers) {
%>
            <p>No members joined this club yet.</p>
<%
        }

        memberRs.close();
        memberPs.close();
        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
        </div>

        <a class="back-link" href="clubs.jsp">Back to Clubs</a>
    </main>
</body>
</html>