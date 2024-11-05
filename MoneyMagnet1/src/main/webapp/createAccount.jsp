<%@ page import="java.sql.*"%>
<%@ page import="com.tap.util.DBUtil"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Create New Account - MoneyMagnet</title>

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
        .form-group select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <!-- Hidden input to check the status -->
    <input type="hidden" id="status" value="<%= request.getAttribute("status") != null ? request.getAttribute("status") : "" %>">

    <div class="main">
        <!-- Sign up form -->
        <section class="signup">
            <div class="container">
                <div class="signup-content">
                    <div class="signup-form">
                        <h2 class="form-title">Create New Account</h2>
                        <form method="post" action="createAccount" class="register-form" id="register-form">
                            <div class="form-group">
                                <label for="username"><i class="zmdi zmdi-account material-icons-name"></i></label>
                                <input type="text" name="username" id="username" placeholder="Your Username"  />
                            </div>
                            <div class="form-group">
                                <label for="email"><i class="zmdi zmdi-email"></i></label>
                                <input type="email" name="email" id="email" placeholder="Your Email"  />
                            </div>
                                      <!-- Add this in the form group for password -->
 <!-- Add this in the form group for password -->
<div class="form-group" style="position: relative;">
    <label for="password"><i class="zmdi zmdi-lock"></i></label>
    <input type="password" name="password" id="password" placeholder="Password" />
    <!-- Eye icon inside the input field -->
    <i class="zmdi zmdi-eye-off" id="togglePassword" style="position: absolute; right: 10px; top: 12px; cursor: pointer;"></i>
</div>

                            <div class="form-group">
                                <label for="balance"><i class="zmdi zmdi-money"></i></label>
                                <input type="number" name="balance" id="balance" min="0.01" step="0.01" placeholder="Initial Balance"  />
                            </div>
                            <div class="form-group">
                                <label for="account_number"><i class="zmdi zmdi-card"></i></label>
                                <input type="text" name="account_number" id="account_number" placeholder="Account Number"  />
                            </div>
                            <div class="form-group">
                                <label for="account_type"><i class="zmdi zmdi-case"></i></label>
                                <select name="account_type" id="account_type" >
                                    <option value="SAVINGS">Savings</option>
                                    <option value="CHECKING">Current</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="ifsc_code"><i class="zmdi zmdi-hospital"></i></label>
                                <input type="text" name="ifsc_code" id="ifsc_code" placeholder="IFSC Code"  />
                            </div>
                            <div class="form-group">
                                <label for="bank_name"><i class="zmdi zmdi-home"></i></label>
                                <input type="text" name="bank_name" id="bank_name" placeholder="Bank Name"  />
                            </div>
                            <div class="form-group">
                                <label for="micr_code"><i class="zmdi zmdi-code"></i></label>
                                <input type="text" name="micr_code" id="micr_code" placeholder="MICR Code"  />
                            </div>
                            <div class="form-group">
                                <label for="branch_code"><i class="zmdi zmdi-local-offer"></i></label>
                                <input type="text" name="branch_code" id="branch_code" placeholder="Branch Code"  />
                            </div>
                            <div class="form-group">
                                <label for="phone_number"><i class="zmdi zmdi-phone"></i></label>
                                <input type="text" name="phone_number" id="phone_number" placeholder="Phone Number"  />
                            </div>

                            <div class="form-group form-button">
                                <input type="submit" name="signup" id="signup" class="form-submit" value="Create Account" />
                            </div>
                        </form>
                    </div>
                    <div class="signup-image">
                        <figure>
                            <img src="images/signupwallet.PNG" alt="signup image">
                        </figure>
                        <a href="login1.jsp" class="signup-image-link">I am already a member</a>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- JS -->
    <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="js/main.js"></script>

    <script type="text/javascript">
        var status = document.getElementById("status").value;

        if (status === "success") {
            swal({
                title: "Congrats",
                text: "Account created successfully! ",
                icon: "success",
                timer: 2000, // Set the timer for 2 seconds
                buttons: false
            }).then(function() {
                window.location.href = "login1.jsp"; // Redirect after 3 seconds
            });
        } else if (status === "invalidName") {
            swal("Sorry", "Please Enter Name", "error");
        } else if (status === "invalidEmail") {
            swal("Sorry", "Please Enter Email", "error");
        } else if (status === "invalidPassword") {
            swal("Sorry", "Please Enter Password", "error");
        } else if (status === "invalidBalance") {
            swal("Sorry", "Invalid Balance Amount", "error");
        } else if (status === "creationFailed") {
            swal("Sorry", "Account Creation Failed", "error");
        } else if (status === "dbError") {
            swal("Sorry", "Database Error Occurred", "error");
        } else if (status === "invalidAccountNumber") {
            swal("Sorry", "Account number must be exactly 11 digits.", "error");
        } else if (status === "invalidIfscCode") {
            swal("Sorry", "IFSC code must have 4 letters followed by 7 digits.", "error");
        }  else if (status === "invalidPhoneNumber") {
            swal("Sorry", "Phone number must be exactly 10 digits.", "error");
        }

        document.getElementById("register-form").addEventListener("submit", function(event) {
            var accountNumber = document.getElementById("account_number").value;
            var ifscCode = document.getElementById("ifsc_code").value;
        
            var phoneNumber = document.getElementById("phone_number").value;
            
            // Regular expressions for validation
            var accountRegex = /^\d{11}$/;
            var ifscRegex = /^[A-Za-z]{4}\d{7}$/;
           
            var phoneRegex = /^\d{10}$/;

            // Validate account number
            if (!accountRegex.test(accountNumber)) {
                event.preventDefault();
                swal("Invalid Input", "Account number must be exactly 11 digits.", "error");
                return false;
            }

            // Validate IFSC code
            if (!ifscRegex.test(ifscCode)) {
                event.preventDefault();
                swal("Invalid Input", "IFSC code must have 4 letters followed by 7 digits.", "error");
                return false;
            }

           

            // Validate phone number
            if (!phoneRegex.test(phoneNumber)) {
                event.preventDefault();
                swal("Invalid Input", "Phone number must be exactly 10 digits.", "error");
                return false;
            }
        });

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
