<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");

	String uid = request.getParameter("uid");
	if (uid.equals("201901581")) {
		%>
	    <script type="text/javascript">
	        var confirmed = confirm("admin은 삭제 불가능");
		    window.location.href = "admin.jsp";
	    </script>
		<%
	    return;
	}
	PreparedStatement pstmt = null;
	try {
		String sql = "delete from currency where cowner = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, uid);
		pstmt.executeUpdate();
		sql = "delete from orders where tradeUser = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, uid);
		pstmt.executeUpdate();
		sql = "delete from data_user where uid = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, uid);
		pstmt.executeUpdate();
		%>
	    <script type="text/javascript">
	        var confirmed = confirm("uid <%=uid %> 삭제 성공");
		    window.location.href = "admin.jsp";
	    </script>
		<%
	}
	catch (Exception e) {
		%>
	    <script type="text/javascript">
	        var confirmed = confirm("<%= e %>");
		    window.location.href = "admin.jsp";
	    </script>
		<%
	}
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();
	// response.sendRedirect("main.jsp");
%>