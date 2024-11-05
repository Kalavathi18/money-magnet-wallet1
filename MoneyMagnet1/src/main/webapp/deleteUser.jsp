<%@ page import="java.sql.*, java.util.*, com.tap.util.DBUtil, com.tap.util.EmailUtil" %>
<%
    int userId = Integer.parseInt(request.getParameter("userId"));
    Connection conn = null;
    PreparedStatement stmt = null;
    String verificationCode = UUID.randomUUID().toString(); // Generate verification code
    String userEmail = ""; // Retrieve user email from the database

    try {
        conn = DBUtil.getConnection();

        // Get user's email
        String emailQuery = "SELECT email FROM users2 WHERE user_id = ?";
        stmt = conn.prepareStatement(emailQuery);
        stmt.setInt(1, userId);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            userEmail = rs.getString("email");
        }

        // Send email with verification code
        EmailUtil.sendEmail(userEmail, "Verification Code", "Your verification code is: " + verificationCode);
        
        // Store the verification code in the session
        session.setAttribute("verificationCode", verificationCode);
        session.setAttribute("userIdToDelete", userId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verification Code Sent</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #8e44ad, #3498db);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
            transform: translateY(-20px);
            animation: slideIn 0.5s forwards;
        }

        @keyframes slideIn {
            from {
                transform: translateY(-20px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        h2 {
            color: #333;
            margin-bottom: 10px;
            font-size: 24px;
            transition: color 0.3s ease;
        }

        h2:hover {
            color: #8e44ad;
        }

        p {
            margin: 10px 0;
            font-size: 16px;
            color: #555;
            transition: color 0.3s ease;
        }

        p:hover {
            color: #333;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 15px;
            background-color: #5cb85c;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease, transform 0.2s ease;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        a:hover {
            background-color: #4cae4c;
            transform: translateY(-2px);
        }

        .back-button {
            background-color: #007bff;
            margin-top: 10px;
        }

        .back-button:hover {
            background-color: #0069d9;
        }

        .error {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Verification Code Sent</h2>
        <p>A verification code has been sent to your email: <strong><%= userEmail %></strong></p>
        <p>Please check your inbox and enter the verification code to proceed with deletion.</p>
        <a href='verifyCode.jsp'>Enter Verification Code</a>
        <a class="back-button" href='users2.jsp'>Back to Users</a>
    </div>
</body>
</html>
<%
    } catch (SQLException e) {
        out.println("<div class='error'><h2>Error occurred: " + e.getMessage() + "</h2></div>");
    } finally {
        DBUtil.close(null, stmt, conn);
    }
%>
