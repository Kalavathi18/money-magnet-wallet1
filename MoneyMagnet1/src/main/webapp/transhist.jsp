<%@ page import="java.sql.*, javax.sql.*, java.util.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login1.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    List<Map<String, Object>> transactionList = new ArrayList<>();

    try {
        // Get the user ID from the session
        int userId = (Integer) session.getAttribute("userId");

        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moneymagnet1", "root", "kala");

        // Query the transactions2 table for the user's transaction history
        String query = "SELECT * FROM transactions2 WHERE user_id = ? ORDER BY transaction_date DESC LIMIT 7";
        ps = conn.prepareStatement(query);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        // Process the result set
        while (rs.next()) {
            Map<String, Object> transactionData = new HashMap<>();
            transactionData.put("transaction_id", rs.getInt("transaction_id"));
            transactionData.put("amount", rs.getBigDecimal("amount"));
            transactionData.put("transaction_type", rs.getString("transaction_type"));
            transactionData.put("description", rs.getString("description"));
            transactionData.put("transaction_date", rs.getTimestamp("transaction_date"));
            transactionData.put("status", rs.getString("status"));
            transactionData.put("account_number", rs.getString("account_number"));
            transactionList.add(transactionData);
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction History</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            margin: 0;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.8); /* Semi-transparent background */
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.5s ease-in-out; /* Animation effect */
            width: 80%;
            max-width: 800px; /* Responsive max width */
        }

        h1 {
            text-align: center;
            color: #34495e;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #8e44ad;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #3498db;
            font-weight: bold;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Transaction History</h1>
        
        <table border="1">
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>Amount</th>
                    <th>Transaction Type</th>
                    <th>Description</th>
                    <th>Transaction Date</th>
                    <th>Status</th>
                    <th>Account Number</th>
                </tr>
            </thead>
            <tbody>
                <% if (transactionList.isEmpty()) { %>
                    <tr>
                        <td colspan="7">No transactions available.</td>
                    </tr>
                <% } else { 
                    for (Map<String, Object> transactionData : transactionList) { %>
                        <tr>
                            <td><%= transactionData.get("transaction_id") %></td>
                            <td>₹<%= transactionData.get("amount") %></td>
                            <td><%= transactionData.get("transaction_type") %></td>
                            <td><%= transactionData.get("description") %></td>
                            <td><%= transactionData.get("transaction_date") %></td>
                            <td><%= transactionData.get("status") %></td>
                            <td><%= transactionData.get("account_number") %></td>
                        </tr>
                <%  } 
                } %>
            </tbody>
        </table>

        <a href="index.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
