<%-- 
    Document   : add_merchandise
    Created on : Jul 22, 2025, 6:55:46?PM
    Author     : User
--%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Add Merchandise</title>
    <style>
        body { font-family: Arial; background-color: #f0f9f4; margin: 0; }
        header { background-color: #2b7a0b; color: white; padding: 20px; text-align: center; }
        form { max-width: 600px; margin: 20px auto; background: white; padding: 20px; border-radius: 8px; }
        div { margin-bottom: 10px; }
        label { display: block; font-weight: bold; margin-bottom: 5px; }
        input, textarea { width: 100%; padding: 8px; }
        button { background-color: #2b7a0b; color: white; padding: 10px; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background-color: #1f5f06; }
        .back-link { display: block; text-align: center; margin-top: 20px; }
        .back-link a { color: #2b7a0b; text-decoration: none; font-weight: bold; }
        .back-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <header><h1>Add Merchandise</h1></header>

    <form action="add_merchandise_process.jsp" method="post">
        <div>
            <label>Name:</label>
            <input type="text" name="name" required>
        </div>
        <div>
            <label>Price (RM):</label>
            <input type="number" name="price" step="0.01" required>
        </div>
        <div>
            <label>Description:</label>
            <textarea name="description" rows="4" required></textarea>
        </div>
        <button type="submit">Add Merchandise</button>
    </form>

    <div class="back-link">
        <a href="club_merchandise.jsp">&larr; Back to Merchandise List</a>
    </div>
</body>
</html>
