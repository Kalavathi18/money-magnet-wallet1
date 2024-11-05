<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update User</title>
    <script>
        function showPopup(message, redirectUrl) {
            // Display a popup alert with the provided message
            alert(message);
            // Redirect to the specified URL
            window.location.href = redirectUrl;
        }
    </script>
</head>
<body>
    <h1>Update User</h1>

    <%
        // Retrieve parameters from the request
        String userId = request.getParameter("userId");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load JDBC driver and establish connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/moneymagnet1", "root", "kala");

            // Update user details in the database
            String sql = "UPDATE users2 SET username=?, email=?, phone_number=? WHERE user_id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, email);
            pstmt.setString(3, phoneNumber);
            pstmt.setInt(4, Integer.parseInt(userId));

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Successfully updated
                out.println("<script>showPopup('User updated successfully!', 'users2.jsp');</script>");
            } else {
                // Update failed
                out.println("<script>showPopup('Error updating user. Please try again.', 'users2.jsp');</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>showPopup('Error occurred: " + e.getMessage() + "', 'users2.jsp');</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>
</html>
