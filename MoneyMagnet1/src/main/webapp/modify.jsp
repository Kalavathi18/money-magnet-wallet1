<%@ page import="java.sql.*,com.tap.util.DBUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Modify Transaction</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 80%;
            margin: auto;
            overflow: hidden;
            padding: 20px;
            background: #fff;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
        }
        form {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], input[type="date"] {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 4px;
        }
        .back-button {
            background-color: #f44336;
            margin-top: 20px;
        }
        .back-button:hover {
            background-color: #c62828;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Modify Transaction</h2>

        <%
            int transactionId = Integer.parseInt(request.getParameter("transactionId"));
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                conn = DBUtil.getConnection();
                String query = "SELECT t.transaction_id, u1.username, u1.email, u1.balance AS account_number, t.amount, t.transaction_type, t.description " +
                               "FROM transaction t " +
                               "JOIN users1 u1 ON t.user_id = u1.user_id " +
                               "WHERE t.transaction_id = ?";
                stmt = conn.prepareStatement(query);
                stmt.setInt(1, transactionId);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    String username = rs.getString("username");
                    String email = rs.getString("email");
                    double accountNumber = rs.getDouble("account_number");
                    double amount = rs.getDouble("amount");
                    String transactionType = rs.getString("transaction_type");
                    String description = rs.getString("description");
        %>

        <form action="transferServlet" method="post">
            <input type="hidden" name="action" value="modify">
            <input type="hidden" name="transactionId" value="<%= transactionId %>">

            <label>Username:</label>
            <input type="text" name="username" value="<%= username %>" readonly><br>

            <label>Email:</label>
            <input type="text" name="email" value="<%= email %>" readonly><br>

            <label>Account Number:</label>
            <input type="text" name="accountNumber" value="<%= accountNumber %>" readonly><br>

            <label>Amount:</label>
            <input type="number" step="0.01" name="amount" value="<%= amount %>" required><br>

            <label>Transaction Type:</label>
            <input type="text" name="transactionType" value="<%= transactionType %>" required><br>

            <label>Description:</label>
            <input type="text" name="description" value="<%= description %>" required><br>

            <button type="submit">Update</button>
        </form>

        <form action="admin-dashboard.jsp" method="get">
            <button type="submit" class="back-button">Back to Dashboard</button>
        </form>

        <%
                } else {
                    out.println("<p>Error retrieving transaction details.</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error retrieving transaction details: " + e.getMessage() + "</p>");
            } finally {
                DBUtil.close(rs, stmt, conn);
            }
        %>
    </div>
</body>
</html>
