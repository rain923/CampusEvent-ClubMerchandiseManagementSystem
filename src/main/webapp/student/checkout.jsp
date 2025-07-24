<%-- 
    Document   : checkout
    Created on : Jul 22, 2025, 4:35:57?PM
    Author     : User
--%>

<%@ page import="java.sql.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String qrCode = null;

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/GroupProject584", "app", "app");

        String qrSql = "SELECT qr_code FROM clubs WHERE qr_code IS NOT NULL FETCH FIRST ROW ONLY";
        PreparedStatement qrPs = conn.prepareStatement(qrSql);
        ResultSet qrRs = qrPs.executeQuery();

        if (qrRs.next()) {
            qrCode = qrRs.getString("qr_code");
        }

        qrRs.close();
        qrPs.close();
        conn.close();

    } catch (Exception e) {
        out.println("Error fetching QR code: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f8fc; text-align: center; padding: 50px; }
        form { background: white; display: inline-block; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h2 { color: #005f99; }
        input[type="text"], input[type="file"] {
            display: block; width: 80%; margin: 10px auto; padding: 8px;
        }
        button {
            background: #007acc; color: white; padding: 10px 20px; border: none;
            border-radius: 4px; font-size: 16px; cursor: pointer;
        }
        button:hover { background: #005f99; }
        .qr-box { margin: 20px; }
        .qr-box img { max-width: 200px; }
    </style>
</head>
<body>

    <form action="<%=request.getContextPath()%>/SavePostageServlet" method="post" enctype="multipart/form-data">
        <h2>Postage Information</h2>
        <input type="text" name="name" placeholder="Recipient Name" required>
        <input type="text" name="phone" placeholder="Phone Number" required>
        <input type="text" name="address" placeholder="Address" required>
        <input type="text" name="postcode" placeholder="Postcode" required>
        <input type="text" name="city" placeholder="City" required>
        <input type="text" name="state" placeholder="State" required>

        <div class="qr-box">
            <h3>Pay using QR Code:</h3>
            <% if (qrCode != null) { %>
                <img src="<%=request.getContextPath()%>/GetQRServlet?file=<%= qrCode %>" alt="QR Code">
            <% } else { %>
                <p>No QR code uploaded yet.</p>
            <% } %>
        </div>

        <h3>Upload Your Payment Receipt:</h3>
        <input type="file" name="receipt" accept="image/*" required>

        <button type="submit">Submit Order</button>
    </form>

</body>
</html>