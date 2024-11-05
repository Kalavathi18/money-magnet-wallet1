package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.tap.util.DBUtil;

@WebServlet("/deleteUserServlet")
public class DeleteUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String userId = request.getParameter("userId");
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = DBUtil.getConnection(); // Get DB connection
            String sql = "DELETE FROM users2 WHERE user_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(userId));
            stmt.executeUpdate();
            
            response.sendRedirect("users2.jsp"); // Redirect to users list page after deletion
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("errorPage.jsp"); // Redirect to an error page
        } finally {
            DBUtil.close(null, stmt, conn); // Close resources
        }
    }
}
