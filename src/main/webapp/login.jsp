<%-- 
    Document   : login
    Created on : Jul 22, 2025, 12:07:11?AM
    Author     : User
--%>

<%@ page language="java" %>
<html>
<head>
    <title>Login - Campus System</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f8fc; margin: 0; padding: 0; }
        header { background-color: #005f99; color: white; padding: 20px 0; text-align: center; }
        form { background-color: white; max-width: 400px; margin: 40px auto; padding: 30px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        form div { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; color: #005f99; font-weight: bold; }
        input[type="email"], input[type="password"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; }
        button { background-color: #007acc; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; width: 100%; }
        button:hover { background-color: #005f99; }
        p { text-align: center; margin-top: 20px; }
        a { color: #007acc; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <header>
        <h1>User Login</h1>
    </header>

    <% 
        String reason = request.getParameter("reason");
        if("session_expired".equals(reason)){
    %>
        <p style="color:red; text-align:center;">Your session has expired. Please login again.</p>
    <% } %>

    <form action="login" method="post">
        <div>
            <label>Email:</label>
            <input type="email" name="email" required>
        </div>
        <div>
            <label>Password:</label>
            <input type="password" name="password" required>
        </div>
        <button type="submit">Login</button>
    </form>

    <p>Don't have an account? <a href="register.jsp">Register here</a></p>
</body>
</html>