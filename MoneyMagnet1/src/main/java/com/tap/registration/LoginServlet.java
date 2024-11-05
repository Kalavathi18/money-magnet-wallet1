package com.tap.registration;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class Login
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	String url = "jdbc:mysql://localhost:3306/moneymagnet1";
    String un = "root";
    String pwd = "kala";
    
    Connection con = null;
    private PreparedStatement psmt;
    private RequestDispatcher dispatcher;
       
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String uemail=request.getParameter("username");
		String upwd=request.getParameter("password");
		
		HttpSession session=request.getSession();
		
		 try {
	            Class.forName("com.mysql.cj.jdbc.Driver"); // Ensure this class is in your classpath
	            con = DriverManager.getConnection(url, un, pwd);
	            psmt = con.prepareStatement("select * from users where uemail=? and upwd=?");
	           
	            psmt.setString(1, uemail);
	            psmt.setString(2, upwd);
	            
	            
	            ResultSet rs = psmt.executeQuery();
	            if (rs.next()) {
	                session.setAttribute("name", rs.getString("uname"));
	                dispatcher = request.getRequestDispatcher("index.jsp");
	            } else {
	                request.setAttribute("status", "failed");
	                dispatcher = request.getRequestDispatcher("login.jsp");
	            }
	            dispatcher.forward(request, response);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	}

}
