package com.tap.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    String url = "jdbc:mysql://localhost:3306/moneymagnet1";
    String un = "root";
    String pwd = "kala";
    Connection con = null;
    private PreparedStatement psmt;
    private RequestDispatcher dispatcher;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("name");
        String uemail = request.getParameter("email");
        String upwd = request.getParameter("pass");
        String Reupwd=request.getParameter("re_pass");
        String umobile = request.getParameter("contact");
        
        
        if(uname==null || uname.equals("")) {
        	request.setAttribute("status", "invalidName");
        	dispatcher=request.getRequestDispatcher("registration.jsp");
        	dispatcher.forward(request, response);
        }
        if(uemail==null || uemail.equals("")) {
        	request.setAttribute("status", "invalidEmail");
        	dispatcher=request.getRequestDispatcher("registration.jsp");
        	dispatcher.forward(request, response);
        }
        if(upwd==null || upwd.equals("")) {
        	request.setAttribute("status", "invalidUpwd");
        	dispatcher=request.getRequestDispatcher("registration.jsp");
        	dispatcher.forward(request, response);
        }else if(!upwd.equals(Reupwd)) {
        	request.setAttribute("status", "invalidConfirmPassword");
        	dispatcher=request.getRequestDispatcher("registration.jsp");
        	dispatcher.forward(request, response);
        }
        if(umobile==null || umobile.equals("")) {
        	request.setAttribute("status", "invalidMobile");
        	dispatcher=request.getRequestDispatcher("registration.jsp");
        	dispatcher.forward(request, response);
        }else if(umobile.length()>10) {
        	request.setAttribute("status", "invalidMobileLength");
        	dispatcher=request.getRequestDispatcher("registration.jsp");
        	dispatcher.forward(request, response);
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure this class is in your classpath
            con = DriverManager.getConnection(url, un, pwd);
            psmt = con.prepareStatement("INSERT INTO users(uname, upwd, uemail, umobile) VALUES(?, ?, ?, ?)");
            psmt.setString(1, uname);
            psmt.setString(2, upwd);
            psmt.setString(3, uemail);
            psmt.setString(4, umobile);
            
            int x = psmt.executeUpdate();
            dispatcher = request.getRequestDispatcher("registration.jsp");
            if (x > 0) {
                request.setAttribute("status", "success");             
   
            } else {
                request.setAttribute("status", "failed");
            }
            dispatcher.forward(request, response);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (psmt != null) psmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
