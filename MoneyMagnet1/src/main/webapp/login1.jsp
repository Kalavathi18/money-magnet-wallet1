<%@ page import="com.tap.util.DBUtil" %>
<%@ page import="com.tap.model.User" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    Boolean loginSuccess = (session != null) ? (Boolean) session.getAttribute("loginSuccess") : null;
    if (loginSuccess != null && loginSuccess) {
        session.removeAttribute("loginSuccess"); // Clear the attribute after displaying the popup
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>Sign Up Form for Wallet</title>

<!-- Font Icon -->
<link rel="stylesheet" href="fonts/material-icon/css/material-design-iconic-font.min.css">
<!-- Main CSS -->
<link rel="stylesheet" href="css/style.css">
<!-- SweetAlert CSS -->
<link rel="stylesheet" href="https://unpkg.com/sweetalert/dist/sweetalert.css">
<style>
body {
    font-family: 'Poppins', sans-serif;
    background-color: #f0f4f8;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    margin: 0;
    background: linear-gradient(135deg, #8e44ad, #3498db);
}
.link-container {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-top: 10px;
}

.signup-image-link {
    text-decoration: none;
    color: black;
    font-size: 16px;
    margin: 5px 0;
}

.or-text {
    font-weight: bold;
    color: #333;
    margin: 5px 0;
    font-size: 16px;
}
</style>
<script>
    // Function to display success popup using SweetAlert and redirect
    function showLoginSuccessPopup() {
        swal({
            title: "Login Successful!",
            text: "You have successfully logged in.",
            icon: "success",
            button: false, // Disable the button
            timer: 1000 // Close after 2 seconds
        }).then(() => {
            window.location.href = "index.jsp"; // Redirect after the popup
        });
    }

    // Call this function when login is successful
    <% if (loginSuccess != null && loginSuccess) { %>
        window.onload = showLoginSuccessPopup;
    <% } %>
</script>

</head>
<body>
    <input type="hidden" id="status" value="<%= request.getAttribute("status") %>">

    <div class="main">
        <!-- Sign in Form -->
        <section class="sign-in">
            <div class="container">
                <div class="signin-content">
                  <div class="signin-image">
    <figure>
        <img src="images/digiwallet.jpg" alt="sign up image">
    </figure>
    <div class="link-container">
        <a href="createAccount.jsp" class="signup-image-link">Create an account</a>
        <span class="or-text">or</span>
        <a href="admin.jsp" class="signup-image-link">Admin Login</a>
    </div>
</div>
         <div class="signin-form">
                        <h2 class="form-title">Sign in</h2>
                        <form method="post" action="loginServlet1" class="register-form" id="login-form">
                            <div class="form-group">
                                <label for="username"><i class="zmdi zmdi-email"></i></label> 
                                <input type="text" name="username" id="username" placeholder="Your Name" />
                            </div>

                            <div class="form-group" style="position: relative;">
                                <label for="password"><i class="zmdi zmdi-lock"></i></label>
                                <input type="password" name="password" id="password" placeholder="Password" />
                                <!-- Eye icon inside the input field -->
                                <i class="zmdi zmdi-eye-off" id="togglePassword" style="position: absolute; right: 10px; top: 12px; cursor: pointer;"></i>
                            </div>

                            <div class="form-group form-button">
                                <input type="submit" name="signin" id="signin" class="form-submit" value="Log in" />
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- JS -->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="js/main.js"></script>

    <script type="text/javascript">
    var status = document.getElementById("status").value;
    if (status == "failed") {
        swal("Sorry", "Wrong Username or Password", "error");
    }

    // Function to toggle the password visibility
    document.getElementById('togglePassword').addEventListener('click', function () {
        var passwordField = document.getElementById('password');
        var icon = document.getElementById('togglePassword');
        
        // Toggle the password field type between password and text
        if (passwordField.type === 'password') {
            passwordField.type = 'text'; // Show password
            icon.classList.remove('zmdi-eye-off');
            icon.classList.add('zmdi-eye'); // Change to 'eye-on' (slashed eye)
        } else {
            passwordField.type = 'password'; // Hide password
            icon.classList.remove('zmdi-eye');
            icon.classList.add('zmdi-eye-off'); // Change back to 'eye-off' (normal eye)
        }
    });
    </script>
</body>
</html>
