package com.tap.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.tap.util.DBUtil; // Utility class to get database connection

public class Wallet {
    private int userId;
    private double walletBalance;
    private String accountNumber; // Added for managing bank account number
    private double bankBalance;

    // Constructor initializes the wallet for the given userId
    public Wallet(int userId) {
        this.userId = userId;
        this.walletBalance = 0.0;
        this.accountNumber = null; // Default to null; will be set if wallet exists
        initializeWallet();
    }

    // Initializes the wallet by checking if it exists and creating one if it doesn't
    private void initializeWallet() {
        try (Connection conn = DBUtil.getConnection()) {
            // Check if wallet exists for the user
            String checkWalletSQL = "SELECT balance, account_number FROM wallet2 WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(checkWalletSQL)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    this.walletBalance = rs.getDouble("balance");
                    this.accountNumber = rs.getString("account_number");
                } else {
                    // Wallet does not exist, create a new wallet
                    String createWalletSQL = "INSERT INTO wallet2 (user_id, balance) VALUES (?, ?)";
                    try (PreparedStatement insertStmt = conn.prepareStatement(createWalletSQL)) {
                        insertStmt.setInt(1, userId);
                        insertStmt.setDouble(2, this.walletBalance);
                        insertStmt.executeUpdate();
                    }
                }
            }

            // Initialize bank balance
            this.bankBalance = fetchBankBalance();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Retrieves the current bank balance from the database
    private double fetchBankBalance() {
        double balance = 0.0;
        try (Connection conn = DBUtil.getConnection()) {
            String query = "SELECT balance FROM users2 WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    balance = rs.getDouble("balance");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return balance;
    }

 // Deducts money from the bank account of the user
    public boolean deductFromBank(double amount, String accountNumber, String ifscCode, String bankName, String phoneNumber, String description) {
        System.out.println("Checking bank account details: " +
                           "Account Number = " + accountNumber +
                           ", IFSC Code = " + ifscCode +
                           ", Bank Name = " + bankName +
                           ", Phone Number = " + phoneNumber);

        try (Connection conn = DBUtil.getConnection()) {
            // Disable auto-commit for transaction management
            conn.setAutoCommit(false);
            
            // Check if the bank account exists for the user
            String checkBankAccountSQL = "SELECT balance FROM users2 WHERE account_number = ? AND IFSC_code = ? AND bank_name = ? AND phone_number = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(checkBankAccountSQL)) {
                stmt.setString(1, accountNumber);
                stmt.setString(2, ifscCode);
                stmt.setString(3, bankName);
                stmt.setString(4, phoneNumber);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next()) {
                    double bankBalance = rs.getDouble("balance");

                    // Check if the bank balance is sufficient
                    if (bankBalance >= amount) {
                        // Insert the transaction record with status 'PENDING'
                        String insertTransactionSQL = "INSERT INTO transactions2 (user_id, amount, transaction_type, description, transaction_date, status, account_number) VALUES (?, ?, 'TRANSFER', ?, NOW(), 'PENDING', ?)";
                        int transactionId = 0; // To hold the transaction ID
                        
                        try (PreparedStatement transactionStmt = conn.prepareStatement(insertTransactionSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            transactionStmt.setInt(1, userId);
                            transactionStmt.setDouble(2, amount);
                            transactionStmt.setString(3, description); // Customize the description as needed
                            transactionStmt.setString(4, accountNumber);
                            transactionStmt.executeUpdate();

                            // Get the transaction ID of the newly inserted transaction
                            ResultSet generatedKeys = transactionStmt.getGeneratedKeys();
                            if (generatedKeys.next()) {
                                transactionId = generatedKeys.getInt(1);
                            }
                        }

                        // Deduct the amount from the bank account
                        String updateBankAccountSQL = "UPDATE users2 SET balance = balance - ? WHERE account_number = ? AND IFSC_code = ? AND bank_name = ? AND phone_number = ?";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateBankAccountSQL)) {
                            updateStmt.setDouble(1, amount);
                            updateStmt.setString(2, accountNumber);
                            updateStmt.setString(3, ifscCode);
                            updateStmt.setString(4, bankName);
                            updateStmt.setString(5, phoneNumber);
                            
                            int rowsAffected = updateStmt.executeUpdate();

                            // If the balance was updated, reflect the change in the local bank balance and update transaction status
                            if (rowsAffected > 0) {
                                this.bankBalance -= amount;

                                // Update the transaction status to 'COMPLETED'
                                String updateTransactionSQL = "UPDATE transactions2 SET status = 'COMPLETED' WHERE transaction_id = ?";
                                try (PreparedStatement updateTransactionStmt = conn.prepareStatement(updateTransactionSQL)) {
                                    updateTransactionStmt.setInt(1, transactionId);
                                    updateTransactionStmt.executeUpdate();
                                }

                                // Commit the transaction
                                conn.commit();
                                return true;
                            }
                        }
                    } else {
                        System.out.println("Insufficient bank balance.");
                        return false;
                    }
                } else {
                    System.out.println("Bank account not found.");
                    return false;
                }
            } catch (SQLException e) {
                conn.rollback(); // Roll back changes on error
                e.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }



    public boolean addMoneyToWallet(double amount, String description, String newAccountNumber) {
        Connection conn = null; // Declare Connection outside the try block
        try {
            conn = DBUtil.getConnection();
            // Disable auto-commit for transaction management
            conn.setAutoCommit(false);
            
            // Update wallet balance and account number
            String updateWalletSQL = "UPDATE wallet2 SET balance = balance + ?, account_number = ? WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateWalletSQL)) {
                stmt.setDouble(1, amount);
                stmt.setString(2, newAccountNumber); // Update account number
                stmt.setInt(3, userId);
                int rowsAffected = stmt.executeUpdate();
                // Update local wallet balance
                if (rowsAffected > 0) {
                    this.walletBalance += amount; // Update local wallet balance

                    // Optional: You may want to log the transaction in some manner, e.g., update the description
                    // or just keep a record if needed without inserting a new transaction.
                    
                    // Commit the transaction
                    conn.commit();
                    return true;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Roll back changes on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackException) {
                    rollbackException.printStackTrace();
                }
            }
        } finally {
            // Close the connection in the finally block to ensure it's closed
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException closeException) {
                    closeException.printStackTrace();
                }
            }
        }
        return false;
    }
    
 // Method to retrieve user password
    public String getUserPassword(int userId) {
        String password = null;
        try (Connection conn = DBUtil.getConnection()) {
            String query = "SELECT password FROM users2 WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    password = rs.getString("password");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return password;
    }

    // Retrieves the current wallet balance
    public double getWalletBalance() {
        return walletBalance;
    }

    // Retrieves the current bank balance
    public double getBankBalance() {
        return bankBalance;
    }
    // Method to get user email
    public String getUserEmail(int userId) {
        String email = null;
        try (Connection conn = DBUtil.getConnection()) {
            String query = "SELECT email FROM users2 WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    email = rs.getString("email");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return email;
    }
    
}
