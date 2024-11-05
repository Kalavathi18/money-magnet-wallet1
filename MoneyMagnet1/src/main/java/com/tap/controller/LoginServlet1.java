package com.tap.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.tap.model.User;
import com.tap.util.DBUtil;
import com.tap.util.EmailUtil;

@WebServlet("/loginServlet1")
public class LoginServlet1 extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Validate user credentials
        User user = DBUtil.getUserByUsernameAndPassword(username, password);

        if (user != null) {
            // Create session and set user details
            HttpSession session = request.getSession(true); // create a new session if one doesn't exist
            session.setAttribute("user", user); // Set the complete User object in session
            session.setAttribute("userId", user.getUserId()); // Set userId in session
            session.setAttribute("username", user.getUsername());

            // Set wallet and bank balances in the session
            double walletBalance = DBUtil.getWalletBalance(user.getUserId()); // Implement this method in DBUtil
            double bankBalance = DBUtil.getBankBalance(user.getUserId()); // Implement this method in DBUtil
            session.setAttribute("walletBalance", walletBalance);
            session.setAttribute("bankBalance", bankBalance);

            // Set login success flag in session
            session.setAttribute("loginSuccess", true);

            // Get the current date
            SimpleDateFormat formatter = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
            Date date = new Date();
            String currentDate = formatter.format(date);

            // Send login notification email
            String subject = "Thank you for visiting MoneyMagnet Wallet";
            String message = "Dear " + user.getUsername() + ",\n\nThank you for visiting MoneyMagnet Wallet on " + currentDate + ".\n\nBest regards,\nMoneyMagnet Wallet Team";
            EmailUtil.sendEmail(user.getEmail(), subject, message);

            // Redirect back to the login1.jsp page to show the popup
            response.sendRedirect("login1.jsp");
        } else {
            // Login failed
            request.setAttribute("status", "failed");
            request.getRequestDispatcher("login1.jsp").forward(request, response);
        }
    }
}
