<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");

	String uid = request.getParameter("uid");
	
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	String sql = "select * from data_user where uid=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, uid);
	rs = pstmt.executeQuery();
	if (rs.next()){
		if (uid.equals("201901581")){
			response.sendRedirect("admin.jsp");
		}
		else {
			response.sendRedirect("./market.jsp?uid="+uid);
		}
	}
	else {
		%>
	    <script type="text/javascript">
	        var confirmed = confirm("로그인 실패");
		    window.location.href = "main.jsp";
	    </script>
		<%
	}
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();
	//response.sendRedirect("main.jsp");
%>