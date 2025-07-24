<%-- 
    Document   : club_upload_qr
    Created on : Jul 23, 2025, 11:33:18?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload QR Code</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; }
        form { margin: 50px auto; width: 300px; padding: 20px; background: white; border-radius: 8px; }
        input[type="file"], input[type="submit"] { display: block; width: 100%; margin: 10px 0; }
    </style>
</head>
<body>
    <form action="ClubUploadQRServlet" method="post" enctype="multipart/form-data">
        <h2>Upload QR Code</h2>
        <input type="file" name="qr_code" accept="image/*" required>
        <input type="submit" value="Upload">
    </form>
</body>
</html>