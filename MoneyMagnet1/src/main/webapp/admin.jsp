<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Admin Login</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- SweetAlert CSS -->
    <link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">
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
            max-width: 380px;
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

        .form-group {
            position: relative;
            margin-bottom: 20px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 12px 12px 40px; /* Adjusted padding */
            font-size: 16px;
            border: none;
            border-radius: 6px;
            background-color: rgba(255, 255, 255, 0.2); /* Transparent input fields */
            color: #fff;
            transition: background-color 0.3s ease;
            box-sizing: border-box; /* Ensures padding is included within the input width */
        }

        .form-group input:focus {
            background-color: rgba(255, 255, 255, 0.5); /* Lighten the input background on focus */
            outline: none;
        }

        .form-group i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #ccc;
        }

        .form-submit {
            width: 100%;
            padding: 12px;
            background-color: rgba(255, 255, 255, 0.3);
            color: #fff;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            cursor: pointer;
            text-transform: uppercase;
            transition: background-color 0.3s ease;
        }

        .form-submit:hover {
            background-color: rgba(255, 255, 255, 0.5); /* Change button background on hover */
        }

        .back-dashboard {
            margin-top: 15px;
            text-align: center;
        }

        .back-dashboard a {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
        }

        .back-dashboard a i {
            margin-right: 6px;
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
    <div class="main">
        <!-- Admin Login Form -->
        <h2 class="form-title">Admin Login</h2>
        <form id="adminLoginForm">
            <div class="form-group">
                <i class="fas fa-user"></i>
                <input type="text" name="username" id="username" placeholder="Username" required />
            </div>
            <div class="form-group">
                <i class="fas fa-lock"></i>
                <input type="password" name="password" id="password" placeholder="Password" required />
            </div>
            <div class="form-group">
                <input type="button" name="signin" id="signin" class="form-submit" value="Login" onclick="validateAdmin()" />
            </div>
        </form>
        <!-- Back to Dashboard Link -->
        <div class="back-dashboard">
            <a href="login1.jsp"><i class="fas fa-arrow-left"></i>Return to Login </a>
        </div>
    </div>

    <!-- JS -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script>
        // Predefined admin credentials
        const adminUsername = "admin";
        const adminPassword = "admin123";

        function validateAdmin() {
            const username = document.getElementById("username").value;
            const password = document.getElementById("password").value;

            if (username === adminUsername && password === adminPassword) {
                // Show success message
                swal("Success!", "Admin login successfully!", "success").then(() => {
                    // Redirect to admin dashboard after clicking OK on the popup
                    window.location.href = "admin-dashboard.jsp";
                });
            } else {
                // Show error message
                swal("Invalid Credentials", "Please enter correct username and password", "error");
            }
        }
    </script>
</body>
</html>
