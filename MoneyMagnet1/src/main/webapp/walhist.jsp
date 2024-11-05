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
    List<Map<String, Object>> walletList = new ArrayList<>();

    try {
        // Get the user ID from the session
        int userId = (Integer) session.getAttribute("userId");

        // Connect to the database
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moneymagnet1", "root", "kala");

        // Query the wallet2 table for the user's wallet information
        String query = "SELECT * FROM wallet2 WHERE user_id = ?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        // Process the result set
        while (rs.next()) {
            Map<String, Object> walletData = new HashMap<>();
            walletData.put("wallet_id", rs.getInt("wallet_id"));
            walletData.put("balance", rs.getBigDecimal("balance"));
            walletData.put("account_number", rs.getString("account_number"));
            walletList.add(walletData);
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
    <title>Wallet History</title>
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
            max-width: 600px; /* Responsive max width */
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
        <h1>Wallet History</h1>
        <table border="1">
            <thead>
                <tr>
                    <th>Wallet ID</th>
                    <th>Balance</th>
                    <th>Account Number</th>
                </tr>
            </thead>
            <tbody>
                <% if (walletList.isEmpty()) { %>
                    <tr>
                        <td colspan="3">No wallet data available.</td>
                    </tr>
                <% } else { 
                    for (Map<String, Object> walletData : walletList) { %>
                        <tr>
                            <td><%= walletData.get("wallet_id") %></td>
                            <td>₹<%= walletData.get("balance") %></td>
                            <td><%= walletData.get("account_number") %></td>
                        </tr>
                <%  } 
                } %>
            </tbody>
        </table>
        <a href="index.jsp">Back to Dashboard</a>
    </div>
</body>
</html>
