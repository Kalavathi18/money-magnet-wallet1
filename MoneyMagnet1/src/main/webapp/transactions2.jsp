<%@ page import="java.sql.*, java.util.*" %> 
<%@ page import="com.tap.util.DBUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transaction List</title>
    <link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"> <!-- Font Awesome -->

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 800px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            margin-top: 20px;
            animation: fadeIn 1s ease-in-out;
            overflow-x: auto; /* Enable horizontal scrolling */
        }

        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
            font-size: 28px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 10px;
            overflow: hidden;
            table-layout: auto; /* Auto layout for better visibility */
        }

        table thead {
            background-color: #3498db;
            color: white;
        }

        table th, table td {
            padding: 10px;
            text-align: center;
            font-size: 14px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        table th {
            background-color: #5d9cec;
            color: #ffffff;
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        table tr:nth-child(odd) {
            background-color: #f1f1f1;
        }

        table td {
            border-bottom: 1px solid #ddd;
        }

        .delete-button {
            background-color: #f44336;
            border: none;
            color: white;
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .delete-button:hover {
            background-color: #c62828;
        }

        .back-button {
            display: inline-block;
            background-color: #007bff;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
            transition: background-color 0.3s ease;
        }

        .back-button:hover {
            background-color: #0056b3;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
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
        <h2>Transaction Details</h2>

        <table>
            <thead>
                <tr>
                    <th>Transaction ID</th>
                    <th>User ID</th>
                    <th>Amount</th>
                    <th>Transaction Type</th>
                    <th>Description</th>
                    <th>Transaction Date</th>
                    <th>Status</th>
                    <th>Account Number</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DBUtil.getConnection();
                        String query = "SELECT * FROM transactions2";
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int transactionId = rs.getInt("transaction_id");
                            int userId = rs.getInt("user_id");
                            double amount = rs.getDouble("amount");
                            String transactionType = rs.getString("transaction_type");
                            String description = rs.getString("description");
                            Timestamp transactionDate = rs.getTimestamp("transaction_date");
                            String status = rs.getString("status");
                            String accountNumber = rs.getString("account_number");
                %>
                <tr>
                    <td><%= transactionId %></td>
                    <td><%= userId %></td>
                    <td><%= String.format("%.2f", amount) %></td> <!-- Format amount -->
                    <td><%= transactionType %></td>
                    <td><%= description %></td>
                    <td><%= transactionDate %></td>
                    <td><%= status %></td>
                    <td><%= accountNumber %></td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>

        <a href="admin-dashboard.jsp" class="back-button">Back to Dashboard</a>
    </div>
</body>
</html>
