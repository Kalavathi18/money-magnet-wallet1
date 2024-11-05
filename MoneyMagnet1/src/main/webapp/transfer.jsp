<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Transfer Funds</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">
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
            animation: backgroundAnimation 8s infinite alternate;
        }

        @keyframes backgroundAnimation {
            0% { background-position: 0% 50%; }
            100% { background-position: 100% 50%; }
        }

        .main {
            width: 100%;
            max-width: 380px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
            padding: 40px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
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
            width: 100%;
        }

        .form-group input {
            width: 100%;
            padding: 12px;
            padding-left: 40px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 6px;
            background-color: #fff;
            color: #333;
            transition: border-color 0.3s ease;
            box-sizing: border-box;
        }

        .form-group input:focus {
            border-color: #3498db;
        }

        .form-group i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 18px;
            color: #ccc;
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

        .checkbox-group {
            display: flex;
            align-items: center; /* Aligns checkbox and label vertically */
            margin-left: 40px; /* Align with input */
            margin-top: 5px; /* Adjust the spacing */
        }

        .checkbox-group input {
            margin-right: 10px; /* Space between checkbox and label */
        }

        .show-password {
            color: #fff; /* Change color to white */
            cursor: pointer;
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="main">
        <h2 class="form-title">Transfer Funds</h2>

        <form id="transferForm" action="transfer" method="post">
            <div class="form-group">
                <i class="fas fa-user"></i>
                <input type="text" name="userId" placeholder="User ID" />
            </div>
            <div class="form-group">
                <i class="fas fa-dollar-sign"></i>
                <input type="text" name="amount" placeholder="Amount" />
            </div>
            <div class="form-group">
                <i class="fas fa-credit-card"></i>
                <input type="text" name="accountNumber" placeholder="Account Number" />
            </div>
        
            <div class="form-group">
                <i class="fas fa-university"></i>
                <input type="text" name="ifscCode" placeholder="IFSC Code" />
            </div>
            <div class="form-group">
                <i class="fas fa-building"></i>
                <input type="text" name="bankName" placeholder="Bank Name" />
            </div>
            <div class="form-group">
                <i class="fas fa-phone"></i>
                <input type="text" name="phoneNumber" placeholder="Phone Number" />
            </div>
            <div class="form-group">
                <i class="fas fa-pencil-alt"></i>
                <input type="text" name="description" placeholder="Description" />
            </div>

            
            <button type="submit">
                <i class="fas fa-paper-plane"></i> Transfer
            </button>
        </form>

        <div class="back-dashboard">
            <a href="index.jsp"><i class="fas fa-arrow-left"></i>Back to Dashboard</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script>
       
        // Check for success message
        var successMessage = "${success}";
        if (successMessage) {
            Swal.fire({
                icon: 'success',
                title: 'Transfer Successful',
                text: successMessage,
            });
        }

        // Check for error message
        var errorMessage = "${error}";
        if (errorMessage) {
            Swal.fire({
                icon: 'error',
                title: 'Transfer Failed',
                text: errorMessage,
            });
        }
    </script>
</body>
</html>
