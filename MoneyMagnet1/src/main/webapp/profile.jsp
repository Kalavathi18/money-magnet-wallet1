<%@ page session="true" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.tap.model.User" %>
<%
    // Fetch user details from session
    User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - MoneyMagnet</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        /* Base styles */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            background-size: 200% 200%;
            animation: backgroundMove 6s ease infinite alternate;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        @keyframes backgroundMove {
            0% {
                background-position: 0 0;
            }
            100% {
                background-position: 100% 100%;
            }
        }

        .container {
            width: 100%;
            max-width: 800px;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.1); /* Transparent container */
            backdrop-filter: blur(10px); /* Glass effect */
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); /* Soft shadow */
            text-align: center;
            transition: transform 0.3s ease, background-color 0.3s ease;
            box-sizing: border-box;
        }

        .container:hover {
            transform: translateY(-5px);
            background-color: rgba(255, 255, 255, 0.2); /* Slight change on hover */
        }

        .header {
            background-color: rgba(76, 99, 182, 0.8); /* Semi-transparent header */
            color: #fff;
            padding: 20px;
            border-radius: 10px 10px 0 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .header i {
            margin-right: 10px;
        }

        .profile-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        .profile-table th, .profile-table td {
            padding: 12px;
            text-align: left;
            border: 1px solid rgba(255, 255, 255, 0.2); /* Transparent borders */
        }

        .profile-table th {
            background-color: rgba(76, 99, 182, 0.8); /* Same as header */
            color: #fff;
        }

        .profile-table td {
            background-color: rgba(255, 255, 255, 0.2); /* Slightly transparent cells */
            color: #fff;
        }

        .button {
            display: inline-block;
            margin: 20px;
            padding: 12px 25px;
            background-color: rgba(76, 175, 80, 0.8); /* Semi-transparent button */
            color: white;
            text-align: center;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .button:hover {
            background-color: rgba(76, 175, 80, 1); /* Fully opaque on hover */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        @media (max-width: 600px) {
            .container {
                width: 90%;
                padding: 15px;
            }

            .profile-table {
                font-size: 14px;
            }

            .button {
                padding: 10px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header with Profile Icon -->
        <div class="header">
            <i class="fas fa-user-circle fa-2x"></i>
            <h1 style="display: inline;">My Profile</h1>
        </div>

        <!-- Profile Details Table -->
        <table class="profile-table">
            <tr>
                <th>Field</th>
                <th>Details</th>
            </tr>
            <tr>
                <td><strong>Username</strong></td>
                <td><%= user.getUsername() %></td>
            </tr>
            <tr>
                <td><strong>Email</strong></td>
                <td><%= user.getEmail() %></td>
            </tr>
            <tr>
                <td><strong>Balance</strong></td>
                <td>₹<%= session.getAttribute("bankBalance") != null ? session.getAttribute("bankBalance") : "0.00" %></td>
            </tr>
            <tr>
                <td><strong>Account Number</strong></td>
                <td><%= user.getAccountNumber() %></td>
            </tr>
            <tr>
                <td><strong>Account Type</strong></td>
                <td><%= user.getAccountType() %></td>
            </tr>
            <tr>
                <td><strong>IFSC Code</strong></td>
                <td><%= user.getIfscCode() %></td>
            </tr>
            <tr>
                <td><strong>Bank Name</strong></td>
                <td><%= user.getBankName() %></td>
            </tr>
            <tr>
                <td><strong>MICR Code</strong></td>
                <td><%= user.getMicrCode() %></td>
            </tr>
            <tr>
                <td><strong>Branch Code</strong></td>
                <td><%= user.getBranchCode() %></td>
            </tr>
            <tr>
                <td><strong>Phone Number</strong></td>
                <td><%= user.getPhoneNumber() %></td>
            </tr>
        </table>

        <!-- Back to Dashboard Button -->
        <div>
            <a href="index.jsp" class="button">Back to Dashboard</a>
        </div>
    </div>
</body>
</html>
