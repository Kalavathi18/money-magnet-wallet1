package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import com.tap.util.DBUtil;

@WebServlet("/createAccount")
public class CreateAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String balanceStr = request.getParameter("balance");
        String accountNumber = request.getParameter("account_number");
        String accountType = request.getParameter("account_type");
        String IFSCCode = request.getParameter("ifsc_code");
        String bankName = request.getParameter("bank_name");
        String MICRCode = request.getParameter("micr_code");
        String branchCode = request.getParameter("branch_code");
        String phoneNumber = request.getParameter("phone_number");

        // Validate inputs
        String validationStatus = validateInput(accountNumber, IFSCCode,  phoneNumber);
        if (!validationStatus.isEmpty()) {
            request.setAttribute("status", validationStatus);
            request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            return;
        }

        double balance;
        try {
            balance = Double.parseDouble(balanceStr);
        } catch (NumberFormatException e) {
            request.setAttribute("status", "invalidBalance");
            request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtUser = null;
        PreparedStatement pstmtWallet = null;
        try {
            conn = DBUtil.getConnection();
            conn.setAutoCommit(false); // Start transaction

            // Insert into users2 table
            String sqlUser = "INSERT INTO users2 (username, email, password, balance, account_number, account_type, IFSC_code, bank_name, MICR_code, branch_code, phone_number, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'ACTIVE', NOW())";
            pstmtUser = conn.prepareStatement(sqlUser, PreparedStatement.RETURN_GENERATED_KEYS);
            pstmtUser.setString(1, username);
            pstmtUser.setString(2, email);
            pstmtUser.setString(3, password); // Consider hashing the password
            pstmtUser.setDouble(4, balance);
            pstmtUser.setString(5, accountNumber);
            pstmtUser.setString(6, accountType);
            pstmtUser.setString(7, IFSCCode);
            pstmtUser.setString(8, bankName);
            pstmtUser.setString(9, MICRCode);
            pstmtUser.setString(10, branchCode);
            pstmtUser.setString(11, phoneNumber);
            int resultUser = pstmtUser.executeUpdate();

            int userId = 0;
            try (var rs = pstmtUser.getGeneratedKeys()) {
                if (rs.next()) {
                    userId = rs.getInt(1);
                }
            }

            // Insert into wallet table with initial balance of 0.0
            String sqlWallet = "INSERT INTO wallet2 (user_id, balance, account_number) VALUES (?, 0.0,?)";
            pstmtWallet = conn.prepareStatement(sqlWallet);
            pstmtWallet.setInt(1, userId);
            pstmtWallet.setString(2, accountNumber);
            int resultWallet = pstmtWallet.executeUpdate();

            if (resultUser > 0 && resultWallet > 0) {
                conn.commit();

                // Send email notification
                sendEmail(email, username, accountNumber);

                // Set status as success and forward back to createAccount.jsp to show the pop-up
                request.setAttribute("status", "success");
                request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            } else {
                conn.rollback();
                request.setAttribute("status", "creationFailed");
                request.getRequestDispatcher("createAccount.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
            request.setAttribute("status", "dbError");
            request.getRequestDispatcher("createAccount.jsp").forward(request, response);
        } finally {
            DBUtil.close(conn, pstmtUser, null);
            DBUtil.close(null, pstmtWallet, null);
        }
    }

    private String validateInput(String accountNumber, String IFSCCode,  String phoneNumber) {
        if (accountNumber.length() != 11) {
            return "invalidAccountNumber";
        }
        if (!IFSCCode.matches("^[A-Za-z]{4}\\d{7}$")) {
            return "invalidIfscCode";
        }
        
        if (phoneNumber.length() != 10) {
            return "invalidPhoneNumber";
        }
        return "";
    }

    private void sendEmail(String recipientEmail, String username, String accountNumber) {
        String host = "smtp.gmail.com"; // Use your email provider's SMTP server
        String from = "walllet1818@gmail.com"; // Replace with your email
        String password = "pvah dhlt wfir ghrp"; // Replace with your email password

        Properties props = new Properties();
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(from));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Welcome to MoneyMagnet Wallet");

            String msg = "Hello " + username + ",\n\n"
                    + "Welcome to MoneyMagnet Wallet. Your journey has started with us.\n"
                    + "Thank you for choosing MoneyMagnet. Your account number is: " + accountNumber + "\n\n"
                    + "Best regards,\n"
                    + "MoneyMagnet Team";

            message.setText(msg);
            Transport.send(message);

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
