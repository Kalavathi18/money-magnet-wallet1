<%@ page import="com.tap.model.Transaction"%>
<%@ page import="java.util.List"%>
<%@ page import="java.time.format.DateTimeFormatter"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page contentType="text/html; charset=UTF-8"%>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login1.jsp");
        return;
    }
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - MoneyMagnet</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
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

        .sidebar {
            width: 250px;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            background-color: rgba(44, 62, 80, 0.7); /* Transparent background */
            padding-top: 30px;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            align-items: full;
        }

        .sidebar a {
            padding: 15px 30px;
            margin-bottom: 10px;
            text-decoration: none;
            color: #ecf0f1; /* Initial text color */
            display: block;
            font-size: 18px;
            text-align: center;
            border-radius: 8px;
            transition: background-color 0.3s, color 0.3s; /* Added transition for color change */
            width: 100%;
        }

        .sidebar a:hover {
            background-color: rgba(255, 255, 255, 0.8); /* Change background on hover */
            color: #000; /* Change text color on hover */
        }

        .main-content {
            flex: 1;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-y: auto;
        }

        .header {
            text-align: center;
            padding: 20px;
            color: #fff; /* Changed to white for better contrast */
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .balance-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
        }

        .balance-section {
            background: rgba(255, 255, 255, 0.1); /* Transparent white background */
            backdrop-filter: blur(10px); /* Blur effect for the transparent background */
            border-radius: 12px;
            padding: 20px;
            margin: 10px;
            width: 45%;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); /* Soft shadow */
            text-align: center;
            transition: transform 0.3s ease;
            box-sizing: border-box; /* Ensures padding is included within the section width */
        }

        .balance-section:hover {
            transform: scale(1.05); /* Zoom effect on hover */
        }

        .balance-section img {
            width: 80px;
            height: 80px;
            margin-top: 10px;
        }

        .history-button {
            width: 100%;
            padding: 12px;
            background-color: rgba(255, 255, 255, 0.3); /* Keep the button background color similar */
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.3s ease;
        }

        .history-button:hover {
            background-color: rgba(255, 255, 255, 0.5); /* Change button background on hover */
        }

        .wallet-section {
            background: rgba(255, 255, 255, 0.1); /* Transparent white background */
            backdrop-filter: blur(10px); /* Blur effect for the transparent background */
            border-radius: 12px;
            padding: 20px;
            margin: 10px 0;
            width: 100%;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3); /* Soft shadow */
            text-align: center;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                flex-direction: row;
                justify-content: space-evenly;
            }

            .sidebar a {
                padding: 10px;
                font-size: 14px;
            }

            .balance-section {
                width: 100%; /* Make balance sections full width on small screens */
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <a href="transfer.jsp"><i class="fas fa-exchange-alt"></i> Transfer Money</a>
        <a href="addFunds.jsp"><i class="fas fa-plus-circle"></i> Add Funds</a>
        <a href="createAccount.jsp"><i class="fas fa-user-plus"></i> Create Account</a>
        <a href="profile.jsp"><i class="fas fa-user"></i> View Profile</a>
        <a href="login1.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
        <a href="thankyou.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <h1>Discover Your MoneyMagnet Wallet Experience!</h1>
            <p>User: <%= session.getAttribute("username") %></p>
        </div>

        <!-- Balance Section Container -->
        <div class="balance-container">
            <div class="balance-section">
                <h2>Wallet Balance: ₹<%=(session.getAttribute("walletBalance") != null ? session.getAttribute("walletBalance") : "0.00")%></h2>
                <img src="images/wallet.png" alt="Wallet Logo">
                <form action="walhist.jsp" method="get">
                    <button type="submit" class="history-button">View Wallet History</button>
                </form>
            </div>

            <div class="balance-section">
                <h2>Bank Balance: ₹<%=(session.getAttribute("bankBalance") != null ? session.getAttribute("bankBalance") : "0.00")%></h2>
                <img src="images/bank.png" alt="Bank Logo">
                <form action="transhist.jsp" method="get">
                    <button type="submit" class="history-button">View Transaction History</button>
                </form>
            </div>
        </div>

       <!-- My Wallet Section -->
<div class="wallet-section">
    <h2>Account Overview</h2>
    <p>Welcome to your Account Overview! Here, you can effortlessly manage your wallet and monitor your financial activities at a glance.</p>
    <p>Stay informed about your current balance, review your transaction history, and quickly access essential actions for seamless financial management.</p>
</div>
    </div>
</body>
</html>
