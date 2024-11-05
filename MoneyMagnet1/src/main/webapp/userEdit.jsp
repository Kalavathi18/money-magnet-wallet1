<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Management</title>
    <link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <style>
         /* Body Style */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            background-size: 200% 200%;
            display: flex;
            flex-direction: column; /* Align items vertically */
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            animation: backgroundMove 6s ease infinite alternate;
            color: white; /* Change text color to white for better contrast */
            text-align: center; /* Center text in body */
        }

        /* Table Style */
        table {
            width: 80%; /* Set a width for the table */
            border-collapse: collapse; /* Merge table borders */
            margin: 20px auto; /* Center the table */
            background-color: rgba(255, 255, 255, 0.1); /* Semi-transparent background */
            border-radius: 8px; /* Rounded corners */
            overflow: hidden; /* Ensure rounded corners apply */
        }
        
        th, td {
            padding: 15px; /* Add padding for table cells */
            text-align: left; /* Align text to the left */
            border-bottom: 1px solid rgba(255, 255, 255, 0.2); /* Light border between rows */
        }

        th {
            background-color: rgba(255, 255, 255, 0.2); /* Header background color */
        }

        tr:hover {
            background-color: rgba(255, 255, 255, 0.2); /* Highlight row on hover */
        }

        /* Button Style */
        button {
            background-color: #3498db; /* Button background */
            color: white; /* Button text color */
            border: none; /* Remove border */
            padding: 10px 20px; /* Padding */
            margin: 5px; /* Margin */
            border-radius: 5px; /* Rounded corners */
            cursor: pointer; /* Pointer cursor on hover */
            transition: background-color 0.3s; /* Transition effect */
        }

        button:hover {
            background-color: #2980b9; /* Darker background on hover */
        }

        /* Modal Style */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgba(0, 0, 0, 0.7); /* Dark background with opacity */
        }

        .modal-content {
            background-color: #fefefe;
            margin: 10% auto; /* Center the modal */
            padding: 20px;
            border: 1px solid #888;
            width: 80%; /* Could be more or less, depending on screen size */
            border-radius: 8px; /* Rounded corners */
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        /* Input Style */
        input[type="text"],
        input[type="email"] {
            width: calc(100% - 22px); /* Full width minus padding */
            padding: 10px; /* Padding */
            margin: 10px 0; /* Margin */
            border: none; /* No border */
            border-radius: 5px; /* Rounded corners */
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3); /* Shadow effect */
        }

        /* Animation */
        @keyframes backgroundMove {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }
    </style>
    <script>
        function openEditModal(userId, username, email, phoneNumber) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhoneNumber').value = phoneNumber;
            document.getElementById('editUserModal').style.display = 'block';
        }

        function closeEditModal() {
            document.getElementById('editUserModal').style.display = 'none';
        }
        
        function showSuccessMessage() {
            swal("Success!", "User updated successfully!", "success")
                .then((value) => {
                    window.location.href = 'users2.jsp'; // Redirect to the user list after closing the alert
                });
        }

        function showErrorMessage(message) {
            swal("Error!", message, "error");
        }
    </script>
</head>
<body>
    <h1>User Management</h1>

    <%
        String action = request.getParameter("action");
        
        if ("update".equals(action)) {
            // Retrieve parameters from the request
            String userId = request.getParameter("userId");
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String phoneNumber = request.getParameter("phoneNumber");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Load JDBC driver and establish connection
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moneymagnet1", "root", "kala"); 

                // Update user details in the database
                String sql = "UPDATE users2 SET username=?, email=?, phone_number=? WHERE user_id=?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                pstmt.setString(3, phoneNumber);
                pstmt.setInt(4, Integer.parseInt(userId));

                int rowsAffected = pstmt.executeUpdate();

                if (rowsAffected > 0) {
                    // Successfully updated
                    out.println("<script>showSuccessMessage();</script>");
                } else {
                    // Update failed
                    out.println("<script>showErrorMessage('Error updating user. Please try again.');</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<script>showErrorMessage('Error occurred: " + e.getMessage() + "');</script>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
                if (conn != null) try { conn.close(); } catch (SQLException e) {}
            }
        }
    %>

    <h2>User List</h2>
    <table>
        <thead>
            <tr>
                <th>Username</th>
                <th>Email</th>
                <th>Phone Number</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                Connection conn = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    // Load JDBC driver and establish connection
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moneymagnet1", "root", "kala");
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT user_id, username, email, phone_number FROM users2"); // Ensure correct column names

                    while (rs.next()) {
                        int userId = rs.getInt("user_id");
                        String username = rs.getString("username");
                        String email = rs.getString("email");
                        String phoneNumber = rs.getString("phone_number");
            %>
            <tr>
                <td><%= username %></td>
                <td><%= email %></td>
                <td><%= phoneNumber %></td>
                <td>
                    <button type="button" onclick="openEditModal(<%= userId %>, '<%= username %>', '<%= email %>', '<%= phoneNumber %>');">
                        Edit
                    </button>
                </td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace(); // This will help in debugging
            %>
            <tr>
                <td colspan="4">Error fetching user list: <%= e.getMessage() %></td>
            </tr>
            <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
                    if (conn != null) try { conn.close(); } catch (SQLException e) {}
                }
            %>
        </tbody>
    </table>

    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeEditModal()">&times;</span>
            <h2>Edit User</h2>
            <form action="userEdit.jsp?action=update" method="post"> <!-- Update the action URL -->
                <input type="hidden" name="userId" id="editUserId">
                <label for="editUsername">Username:</label>
                <input type="text" id="editUsername" name="username">
                <label for="editEmail">Email:</label>
                <input type="email" id="editEmail" name="email">
                <label for="editPhoneNumber">Phone Number:</label>
                <input type="text" id="editPhoneNumber" name="phoneNumber">
                <button type="submit">Save Changes</button>
            </form>
        </div>
    </div>

    <button onclick="window.location.href='users2.jsp'">Go Back</button> 
</body>
</html>
