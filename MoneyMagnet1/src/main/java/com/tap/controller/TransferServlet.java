package com.tap.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.tap.model.Wallet;
import com.tap.util.EmailUtil;



    @WebServlet("/transfer")
    public class TransferServlet extends HttpServlet {
        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            try {
                String userIdParam = request.getParameter("userId");
                String amountParam = request.getParameter("amount");
                String accountNumber = request.getParameter("accountNumber");
                String ifscCode = request.getParameter("ifscCode");
                String bankName = request.getParameter("bankName");
                String phoneNumber = request.getParameter("phoneNumber");
                String description = request.getParameter("description");

                int userId = Integer.parseInt(userIdParam);
                double amount = Double.parseDouble(amountParam);

                Wallet wallet = new Wallet(userId);

                // Step 1: Deduct money from user's bank account
                boolean bankDeducted = wallet.deductFromBank(amount, accountNumber, ifscCode, bankName, phoneNumber, description);

                // Step 2: If bank deduction successful, add money to the wallet
                if (bankDeducted) {
                    boolean walletUpdated = wallet.addMoneyToWallet(amount, description, accountNumber);

                    if (walletUpdated) {
                        // Update balances in session
                        HttpSession session = request.getSession();
                        session.setAttribute("walletBalance", wallet.getWalletBalance());
                        session.setAttribute("bankBalance", wallet.getBankBalance());

                        // Masking account number for security
                        String maskedAccountNumber = accountNumber.replaceAll("\\d(?=\\d{4})", "*");

                        // Prepare email content
                        String email = wallet.getUserEmail(userId); // Retrieve user email
                        String subject = "Transaction Alert";
                        String body ="Dear User,\n\n" +
                                "Your account " + maskedAccountNumber + " has been debited by " + amount + ".\n" +
                                "Available bank balance: " + wallet.getBankBalance() + ".\n\n" +
                                "If you did not authorize this transaction, please report it by replying to this email.\n\n" +
                                "Thank you for using our service.";

                        // Send email
                        EmailUtil.sendEmail(email, subject, body);

                        // Forward to transfer.jsp with success message
                        request.setAttribute("success", "Your funds have been transferred successfully!");
                        request.getRequestDispatcher("transfer.jsp").forward(request, response);
                    } else {
                        // Failed to credit wallet
                        request.setAttribute("error", "Failed to credit wallet. Please try again.");
                        request.getRequestDispatcher("transfer.jsp").forward(request, response);
                    }
                } else {
                    // Failed to deduct from bank
                    request.setAttribute("error", "Insufficient balance !... Failed to deduct from bank. Please check your balance and details.");
                    request.getRequestDispatcher("transfer.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("error", "Invalid input. Please enter valid numbers.");
                request.getRequestDispatcher("transfer.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "An unexpected error occurred. Please try again.");
                request.getRequestDispatcher("transfer.jsp").forward(request, response);
            }
        }
    }