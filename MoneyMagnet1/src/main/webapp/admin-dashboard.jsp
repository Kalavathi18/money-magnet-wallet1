<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
   <style>
    /* General Styles */
    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #8e44ad, #3498db);
        background-size: 200% 200%;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        animation: backgroundMove 6s ease infinite alternate;
    }

    @keyframes backgroundMove {
        0% {
            background-position: 0 0;
        }
        100% {
            background-position: 100% 100%;
        }
    }

    .main {
        width: 100%;
        max-width: 400px; /* Increased width for better spacing */
        background: rgba(255, 255, 255, 0.1); /* Transparent white background */
        backdrop-filter: blur(10px); /* Blur effect for the transparent background */
        border-radius: 12px;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); /* Soft shadow */
        padding: 40px;
        text-align: center;
        transition: transform 0.3s ease;
        box-sizing: border-box; /* Ensures padding is included within the form width */
    }

    .main:hover {
        transform: scale(1.05); /* Zoom effect on hover */
    }

    .form-title {
        font-size: 28px;
        color: #fff;
        font-weight: 600;
        margin-bottom: 20px;
        text-transform: uppercase;
    }

    .navbar {
        display: flex;
        justify-content: space-around; /* Align buttons evenly */
        margin: 20px 0; /* Space between title and navbar */
    }

    .navbar button {
        color: white;
        padding: 10px 15px; /* Reduced padding for buttons */
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
    }

    /* Button Colors */
    .navbar button:nth-child(1) {
        background-color: #4a89dc; /* Soft Blue for Users List */
    }
    .navbar button:nth-child(1):hover {
        background-color: #6cb2eb; /* Lighter Blue on hover */
    }

    .navbar button:nth-child(2) {
        background-color: #5cb85c; /* Soft Green for Transactions */
    }
    .navbar button:nth-child(2):hover {
        background-color: #66bb6a; /* Lighter Green on hover */
    }

    .navbar button:nth-child(3) {
        background-color: #f0ad4e; /* Soft Orange for Wallet */
    }
    .navbar button:nth-child(3):hover {
        background-color: #f7c35c; /* Lighter Orange on hover */
    }

    .admin-image {
        margin: 20px auto; /* Center image */
        max-width: 200px;
        height: auto;
    }

    .back-button {
        display: inline-block;
        background-color: #d9534f; /* Soft Red for back button */
        color: white;
        padding: 10px 15px;
        text-decoration: none;
        border-radius: 5px;
        margin-top: 20px;
        font-size: 16px;
        transition: background-color 0.3s;
    }

    .back-button:hover {
        background-color: #e57373; /* Lighter Red on hover */
    }

    /* Responsive for smaller screens */
    @media (max-width: 600px) {
        .main {
            padding: 20px;
        }
    }
</style>


</head>
<body>

    <!-- Main Content Area -->
    <div class="main">
        <h1 class="form-title">Welcome, Admin!</h1>
        <p style="color: #fff;">Navigate through the options below.</p>
        <img src="images/admin.jpeg" alt="Admin Image" class="admin-image">
        
        <!-- Top Navigation Bar -->
        <div class="navbar">
            <button onclick="location.href='users2.jsp'">Users List</button>
            <button onclick="location.href='transactions2.jsp'">Transactions</button>
            <button onclick="location.href='wallet2.jsp'">Wallet</button>
        </div>

        <!-- Back to Admin Login Button -->
        <a href="admin.jsp" class="back-button">Go to Admin Login</a>
    </div>

</body>
</html>
