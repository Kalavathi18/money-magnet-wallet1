<%@ page import="java.sql.*, java.util.*, com.tap.util.DBUtil, com.tap.util.EmailUtil" %>
<%
    String inputCode = request.getParameter("verificationCode");
    String sessionCode = (String) session.getAttribute("verificationCode");
    Integer userId = (Integer) session.getAttribute("userIdToDelete");

    String message = null; // Message to be displayed in the pop-up

    if (inputCode != null && sessionCode != null) {
        if (inputCode.equals(sessionCode)) {
            // Proceed with deletion
            Connection conn = null;
            PreparedStatement stmt = null;
            String userEmail = ""; // Variable to store user email

            try {
                conn = DBUtil.getConnection();
                conn.setAutoCommit(false); // Start transaction

                // Get user's email
                String emailQuery = "SELECT email FROM users2 WHERE user_id = ?";
                stmt = conn.prepareStatement(emailQuery);
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    userEmail = rs.getString("email");
                }

                // Send thank you email
                EmailUtil.sendEmail(userEmail, "Thank You for Using MoneyWallet", "Thank you for using MoneyWallet. We are sorry to see you go!");

                // Delete related records from wallet2
                String deleteWalletQuery = "DELETE FROM wallet2 WHERE user_id = ?";
                stmt = conn.prepareStatement(deleteWalletQuery);
                stmt.setInt(1, userId);
                stmt.executeUpdate();

                // Delete related transactions from transactions2
                String deleteTransactionsQuery = "DELETE FROM transactions2 WHERE user_id = ?";
                stmt = conn.prepareStatement(deleteTransactionsQuery);
                stmt.setInt(1, userId);
                stmt.executeUpdate();

                // Now delete the user
                String deleteUserQuery = "DELETE FROM users2 WHERE user_id = ?";
                stmt = conn.prepareStatement(deleteUserQuery);
                stmt.setInt(1, userId);
                stmt.executeUpdate();

                conn.commit(); // Commit transaction
                message = "User deleted successfully!";
                
            } catch (SQLException e) {
                if (conn != null) {
                    try {
                        conn.rollback(); // Rollback transaction in case of error
                    } catch (SQLException rollbackEx) {
                        rollbackEx.printStackTrace();
                    }
                }
                message = "Error occurred: " + e.getMessage();
            } finally {
                DBUtil.close(null, stmt, conn);
            }
        } else {
            message = "Invalid verification code!";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Code</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.js"></script>
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
            color: #333;
        }
        .container {
            max-width: 400px;
            width: 100%;
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .container:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.3);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 26px;
            color: #6c757d;
        }
        #timer {
            font-size: 20px;
            color: #e74c3c;
            margin-bottom: 20px;
            text-align: center;
        }
        label {
            display: block;
            margin-bottom: 10px;
            font-weight: 500;
            color: #495057;
        }
        input[type="text"] {
            width: 100%;
            padding: 14px;
            margin-bottom: 20px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        input[type="text"]:focus {
            border-color: #6c757d;
            outline: none;
            box-shadow: 0 0 5px rgba(108, 117, 125, 0.5);
        }
        button {
            width: 100%;
            padding: 14px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s, transform 0.3s;
        }
        button:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }
        button:hover:not(:disabled) {
            background-color: #218838;
            transform: translateY(-2px);
        }
        .back-button {
            background-color: #007bff;
            margin-top: 10px;
        }
        .back-button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Verify Your Code</h2>
        <div id="timer">20 seconds remaining</div>
        <form method="post" id="verificationForm">
            <label for="verificationCode">Enter Verification Code:</label>
            <input type="text" name="verificationCode" >
            <button type="submit">Verify</button>
            <button type="button" class="back-button" onclick="window.location.href='users2.jsp';">Go Back</button>
        </form>
    </div>

   <script>
        let timeLeft = 20;
        const timerDisplay = document.getElementById("timer");
        const verificationForm = document.getElementById("verificationForm");

        const countdown = setInterval(() => {
            timeLeft--;
            timerDisplay.innerText = timeLeft + " seconds remaining";

            if (timeLeft <= 0) {
                clearInterval(countdown);
                timerDisplay.innerText = "Verification code expired!";
                verificationForm.querySelector("input[name='verificationCode']").disabled = true;
                verificationForm.querySelector("button").disabled = true;
            }
        }, 1000);

        verificationForm.onsubmit = function(event) {
            const verificationCodeInput = verificationForm.querySelector("input[name='verificationCode']");
            if (verificationCodeInput.value.trim() === "") {
                event.preventDefault(); // Prevent form submission
                swal("Oops!", "Please enter the verification code.", "error");
            }
        };

     // Check if there's a message from the server
        <% if (message != null) { %>
            let isSuccess = "<%= message %>".includes("successfully");
            swal("Success", "<%= message %>", isSuccess ? "success" : "error").then(() => {
                if (isSuccess) {
                    // Redirect to users2.jsp after a delay
                    setTimeout(() => {
                        window.location.href = "users2.jsp"; 
                    }, 1000); // Redirect after 2 seconds
                }
            });
        <% } %>
    </script>
</body>
</html>
