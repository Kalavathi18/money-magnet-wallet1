<%@ page import="java.sql.*,java.util.*" %>
<%@ page import="com.tap.util.DBUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Users List</title>
    <link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            width: 90%;
            max-width: 800px;
            background-color: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            margin-top: 20px;
            animation: fadeIn 1s ease-in-out;
            overflow: auto; /* Allow scrolling if content overflows */
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
            overflow: hidden;
            table-layout: auto; /* Automatically adjust column widths */
        }

        table thead {
            background-color: #3498db;
            color: white;
        }

        table th, table td {
            padding: 10px; /* Reduced padding for better fit */
            text-align: center;
            word-wrap: break-word; /* Allow word wrapping in cells */
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

        .modify-button {
            background-color: #007bff;
            border: none;
            color: white;
            padding: 8px 12px;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .modify-button:hover {
            background-color: #0056b3;
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
        <h2>Users Details</h2>

        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Balance</th>
                    <th>Created At</th>
                    <th>Account Number</th>
                    <th>Account Type</th>
                    <th>IFSC Code</th>
                    <th>Bank Name</th>
                    <th>MICR Code</th>
                    <th>Branch Code</th>
                    <th>Phone Number</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        conn = DBUtil.getConnection();
                        String query = "SELECT * FROM users2";
                        stmt = conn.prepareStatement(query);
                        rs = stmt.executeQuery();
                        
                        while (rs.next()) {
                            int userId = rs.getInt("user_id");
                            String username = rs.getString("username");
                            String email = rs.getString("email");
                            double balance = rs.getDouble("balance");
                            Timestamp createdAt = rs.getTimestamp("created_at");
                            String accountNumber = rs.getString("account_number");
                            String accountType = rs.getString("account_type");
                            String ifscCode = rs.getString("ifsc_code");
                            String bankName = rs.getString("bank_name");
                            String micrCode = rs.getString("micr_code");
                            String branchCode = rs.getString("branch_code");
                            String phoneNumber = rs.getString("phone_number");
                            String status = rs.getString("status");
                %>
                <tr>
                    <td><%= userId %></td>
                    <td><%= username %></td>
                    <td><%= email %></td>
                    <td><%= balance %></td>
                    <td><%= createdAt %></td>
                    <td><%= accountNumber %></td>
                    <td><%= accountType %></td>
                    <td><%= ifscCode %></td>
                    <td><%= bankName %></td>
                    <td><%= micrCode %></td>
                    <td><%= branchCode %></td>
                    <td><%= phoneNumber %></td>
                    <td><%= status %></td>
                    <td>
                        <form action="deleteUser.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="userId" value="<%=userId%>">
                            <input type="hidden" name="verificationCode" value="<%=UUID.randomUUID().toString()%>">
                            <button type="button" class="delete-button" onclick="confirmDelete(this);">
                                <i class="fas fa-trash"></i>
                            </button>
                        </form>
                        <button type="button" class="modify-button" onclick="confirmModify(<%= userId %>);">
                            <i class="fas fa-edit"></i>
                        </button>
                    </td>
                </tr>
                <%
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        DBUtil.close(rs, stmt, conn);
                    }
                %>
            </tbody>
        </table>
        
        <button class="back-button" onclick="window.location.href='admin-dashboard.jsp';">
            Back to Dashboard
        </button>

        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
        <script>
        function confirmDelete(button) {
            const form = button.parentElement;
            swal({
                title: "Are you sure?",
                text: "Once deleted, you will not be able to recover this user!",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            }).then((willDelete) => {
                if (willDelete) {
                    form.submit();
                } else {
                    swal("User is safe!");
                }
            });
        }

        function confirmModify(userId) {
            console.log("User ID to modify:", userId); // Debugging line
            swal({
                title: "Are you sure?",
                text: "You are about to modify this user's details.",
                icon: "warning",
                buttons: true,
                dangerMode: true,
            }).then((willModify) => {
                if (willModify) {
                    window.location.href = `userEdit.jsp?userId=${userId}`;
                } else {
                    swal("Modification cancelled!");
                }
            });
        }

        </script>
    </div>
</body>
</html>
