<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*"%>
<%
	Connection conn = null;
	
	try {
		String url = "jdbc:mysql://localhost:3306/proj_upbit";
		String user = "root";
		String password = "root";
		
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, user, password);
		
	} catch (SQLException ex) {
		out.println("데이터베이스 연걸이 실패했습니다.<br>");
		out.println("SQLException " + ex.getMessage());
	}
%>