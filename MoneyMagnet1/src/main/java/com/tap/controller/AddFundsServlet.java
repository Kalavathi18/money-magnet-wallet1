package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.util.DBUtil;

@WebServlet("/TransferFundsServlet")
public class AddFundsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
	private String message;
	private String error;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String userIdStr = request.getParameter("userId");
	    String recipientAccount = request.getParameter("recipientAccount");
	    String amountStr = request.getParameter("amount");
	    String description = request.getParameter("description");
	    String password = request.getParameter("password");

	    String message = null;
	    boolean success = false;

	    // Basic validation
	    if (userIdStr == null || recipientAccount == null || amountStr == null || description == null || 
	        password == null || userIdStr.isEmpty() || recipientAccount.isEmpty() || amountStr.isEmpty() || 
	        description.isEmpty() || password.isEmpty()) {
	        message = "All fields are required.";
	    } else {
	        try {
	            int userId = Integer.parseInt(userIdStr);
	            double amount = Double.parseDouble(amountStr);

	            // Validate password (assuming a validatePassword function exists)
	            if (!validatePassword(userId, password)) {
	                message = "Invalid password.";
	            } else {
	                // Proceed with the transfer logic
	                success = transferFunds(request, userId, recipientAccount, amount, description);
	                
	                if (success) {
	                    message = "Transfer of " + amount + " to account " + recipientAccount + " was successful.";
	                } else {
	                    message = "Transfer failed. Please check the account details or your balance.";
	                }
	            }
	        } catch (NumberFormatException e) {
	            message = "Invalid number format.";
	        } catch (Exception e) {
	            message = "An error occurred: " + e.getMessage();
	        }
	    }

	    // Set success and message attributes for SweetAlert
	    request.setAttribute("success", success);
	    request.setAttribute("message", message);

	    // Forward back to the transfer form page
	    request.getRequestDispatcher("addFunds.jsp").forward(request, response);
	}

	private boolean validatePassword(int userId, String password) {
	    // Check the password from the database for the given user
	    try (Connection conn = DBUtil.getConnection()) {
	        String query = "SELECT password FROM users2 WHERE user_id = ?";
	        try (PreparedStatement ps = conn.prepareStatement(query)) {
	            ps.setInt(1, userId);
	            ResultSet rs = ps.executeQuery();
	            if (rs.next()) {
	                String storedPassword = rs.getString("password");
	                return password.equals(storedPassword); // Simple comparison, consider hashing in production
	            }
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return false;
	}


    private boolean transferFunds(HttpServletRequest request, int userId, String recipientAccount, double amount, String description) {
        try (Connection conn = DBUtil.getConnection()) {
            conn.setAutoCommit(false); // Start transaction
            
            // Step 1: Check sender's wallet balance
            String checkWalletSQL = "SELECT balance FROM wallet2 WHERE user_id = ?";
            double walletBalance;
            String senderEmail = null;
            try (PreparedStatement psCheck = conn.prepareStatement(checkWalletSQL)) {
                psCheck.setInt(1, userId);
                ResultSet rs = psCheck.executeQuery();
                if (rs.next()) {
                    walletBalance = rs.getDouble("balance");
                    if (walletBalance < amount) {
                        throw new SQLException("Insufficient wallet balance.");
                    }
                } else {
                    throw new SQLException("Wallet not found for user.");
                }
            }

            // Fetch sender's email from users2 table
            String getEmailSQL = "SELECT email FROM users2 WHERE user_id = ?";
            try (PreparedStatement psEmail = conn.prepareStatement(getEmailSQL)) {
                psEmail.setInt(1, userId);
                ResultSet rsEmail = psEmail.executeQuery();
                if (rsEmail.next()) {
                    senderEmail = rsEmail.getString("email");
                }
            }

            if (senderEmail == null) {
                throw new SQLException("Email not found for user.");
            }

            // Step 2: Update wallet balance
            String updateWalletSQL = "UPDATE wallet2 SET balance = balance - ? WHERE user_id = ?";
            try (PreparedStatement psWallet = conn.prepareStatement(updateWalletSQL)) {
                psWallet.setDouble(1, amount);
                psWallet.setInt(2, userId);
                psWallet.executeUpdate();
            }

            // Step 3: Update recipient's balance in users2
            String updateRecipientSQL = "UPDATE users2 SET balance = balance + ? WHERE account_number = ?";
            try (PreparedStatement psRecipient = conn.prepareStatement(updateRecipientSQL)) {
                psRecipient.setDouble(1, amount);
                psRecipient.setString(2, recipientAccount);
                psRecipient.executeUpdate();
            }

            // Step 4: Insert transaction record
            String insertTransactionSQL = "INSERT INTO transactions2 (user_id, amount, transaction_type, description, transaction_date, status, account_number) VALUES (?, ?, 'ADD_FUNDS', ?, NOW(), 'COMPLETED', ?)";
            try (PreparedStatement psTransaction = conn.prepareStatement(insertTransactionSQL)) {
                psTransaction.setInt(1, userId);
                psTransaction.setDouble(2, amount);
                psTransaction.setString(3, description);
                psTransaction.setString(4, recipientAccount);
                psTransaction.executeUpdate();
            }

            conn.commit(); // Commit transaction

            // Send email notification
            sendEmailNotification(senderEmail, recipientAccount, amount, walletBalance - amount);

            // Step 5: Update session attributes with new balances
            updateSessionBalances(request, userId, recipientAccount);

            return true; // Transaction successful
        } catch (SQLException e) {
            e.printStackTrace();
            // Handle rollback if needed
        }
        return false; // Failure
    }

    private void sendEmailNotification(String senderEmail, String recipientAccount, double amount, double remainingBalance) {
        String host = "smtp.gmail.com"; // Your SMTP server
        final String user = "walllet1818@gmail.com"; // Your email address
        final String password = "pvah dhlt wfir ghrp"; // Your email password

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // Enable TLS
        props.put("mail.smtp.port", "587"); // Port for TLS

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(senderEmail)); // Sending to the sender's email
            message.setSubject("Funds Transfer Notification");

            // Email content
            String msgBody = "Dear user,\n\n"
                    + "An amount of " + amount + " has been debited from your wallet "
                    + "to account number " + recipientAccount + ".\n"
                    + "Available wallet balance is: " + remainingBalance + ".\n\n"
                    + "If you did not authorize this transaction, please report it by replying to this email.\n\n"
                    + "Thank you for using our service.";


            message.setText(msgBody);
            Transport.send(message);

            System.out.println("Notification email sent successfully.");
        } catch (MessagingException e) {
            e.printStackTrace(); // Log the exception for debugging
            System.out.println("Failed to send email: " + e.getMessage());
        }
    }

    private void updateSessionBalances(HttpServletRequest request, int userId, String recipientAccount) {
        // Fetch new balances from the database and update session attributes
        try (Connection conn = DBUtil.getConnection()) {
            try (PreparedStatement psBalance = conn.prepareStatement("SELECT balance FROM wallet2 WHERE user_id = ?")) {
                psBalance.setInt(1, userId);
                ResultSet balanceResult = psBalance.executeQuery();
                if (balanceResult.next()) {
                    double newWalletBalance = balanceResult.getDouble("balance");
                    request.getSession().setAttribute("walletBalance", newWalletBalance);
                }
            }

            try (PreparedStatement psBankBalance = conn.prepareStatement("SELECT balance FROM users2 WHERE account_number = ?")) {
                psBankBalance.setString(1, recipientAccount);
                ResultSet bankBalanceResult = psBankBalance.executeQuery();
                if (bankBalanceResult.next()) {
                    double newBankBalance = bankBalanceResult.getDouble("balance");
                    request.getSession().setAttribute("bankBalance", newBankBalance);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
