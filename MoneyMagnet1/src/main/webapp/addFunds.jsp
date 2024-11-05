<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Funds</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <style>
        /* General Styles */
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            color: #fff;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 400px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 600;
        }

        .input-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 12px;
            color: #888;
            font-size: 18px;
        }

        input[type="text"],
        input[type="number"],
        input[type="password"] {
            width: 100%;
            padding: 12px 12px 12px 40px; /* Space for the icon */
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border 0.3s ease;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="password"]:focus {
            border-color: #3498db;
            outline: none;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-top: 10px;
            justify-content: flex-start;
            color: #fff;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 5px; /* Space between checkbox and label */
            width: auto; /* Make checkbox size standard */
        }

        button {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: background-color 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        button:hover {
            background-color: #218838;
        }

        button i {
            margin-right: 8px;
        }

        .back-dashboard {
            margin-top: 20px;
            text-align: left;
        }

        .back-dashboard a {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            display: inline-flex;
            align-items: center;
        }

        .back-dashboard a i {
            margin-right: 8px;
            font-size: 18px;
        }

        @media (max-width: 500px) {
            .container {
                width: 90%;
                padding: 20px;
            }
        }

        /* Hover effects for better interactivity */
        input:hover, input:focus {
            border-color: #8e44ad;
        }

        .input-group i:hover {
            color: #3498db;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Transfer Funds</h2>

        <form id="transferForm" action="TransferFundsServlet" method="post">
            <input type="hidden" name="userId" value="<%= session.getAttribute("userId") %>">
            
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" id="recipientAccount" name="recipientAccount" placeholder="Enter recipient's account number" >
            </div>

            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" id="password" placeholder="Password"  />
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="showPassword"> 
                <label for="showPassword">Show Password</label>
            </div>

            <div class="input-group">
                <i class="fas fa-dollar-sign"></i>
                <input type="number" id="amount" name="amount" min="0.01" step="0.01" placeholder="Enter amount to transfer" >
            </div>

            <div class="input-group">
                <i class="fas fa-comment-dots"></i>
                <input type="text" id="description" name="description" placeholder="Enter transaction description" >
            </div>

            <button type="submit">
                <i class="fas fa-paper-plane"></i> Transfer
            </button>
        </form>

        <!-- Back to Dashboard link -->
        <div class="back-dashboard">
            <a href="index.jsp"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
        </div>
    </div>

    <script>
        // Function to toggle the password visibility
        document.getElementById('showPassword').addEventListener('change', function () {
            var passwordField = document.getElementById('password');
            passwordField.type = this.checked ? 'text' : 'password'; // Toggle password visibility
        });

        // SweetAlert for success/error messages
        $(document).ready(function () {
            const success = '<%= request.getAttribute("success") != null ? request.getAttribute("success") : "" %>';
            const message = '<%= request.getAttribute("message") != null ? request.getAttribute("message") : "" %>';

            if (message) {
                Swal.fire({
                    icon: success === 'true' ? 'success' : 'error',
                    title: success === 'true' ? 'Success!' : 'Error!',
                    text: message,
                    confirmButtonText: 'Okay',
                });
            }
        });
    </script>
</body>
</html>
