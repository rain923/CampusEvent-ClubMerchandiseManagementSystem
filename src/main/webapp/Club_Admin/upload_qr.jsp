<%-- 
    Document   : upload_qr
    Created on : Jul 23, 2025, 11:48:06?PM
    Author     : User
--%>

<%@ page import="java.sql.*, jakarta.servlet.http.HttpSession" %>
<%
    if (session == null || session.getAttribute("userEmail") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userEmail = (String) session.getAttribute("userEmail");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Upload QR Code</title>
    <style>
        body { font-family: Arial; background: #f0f9f4; text-align: center; padding: 50px; }
        form { background: white; display: inline-block; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h2 { color: #2b7a0b; }
        input[type="file"] { margin: 20px auto; }
        button {
            background: #2b7a0b; color: white; padding: 10px 20px; border: none;
            border-radius: 4px; font-size: 16px; cursor: pointer;
        }
        button:hover { background: #1f5f06; }
    </style>
</head>
<body>

    <form action="<%=request.getContextPath()%>/UploadQRServlet" method="post" enctype="multipart/form-data">
        <h2>Upload Club QR Code</h2>
        <input type="file" name="qr" accept="image/*" required>
        <br>
        <button type="submit">Upload</button>
    </form>

    <p><a href="club_merchandise.jsp">Back to Merchandise Management</a></p>

</body>
</html>