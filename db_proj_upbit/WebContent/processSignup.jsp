<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>
<%
	request.setCharacterEncoding("UTF-8");

	String uid = request.getParameter("uid");
	String uname = request.getParameter("uname");
	
	PreparedStatement pstmt = null;
	try {
		String sql = "insert into data_User values(?,?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, uid);
		pstmt.setString(2, uname);
		pstmt.executeUpdate();
		sql = "select mname from market";
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while (rs.next()){
			if (rs.getString("mname").equals("KRW")){
				sql = "insert into Currency values(\"KRW\", ?, 1000000)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, uid);
			}
			else {
				sql = "insert into Currency values(?, ?, 0)";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, rs.getString("mname"));
				pstmt.setString(2, uid);
			}
			pstmt.executeUpdate();
		}
		// oid 가져오기
		sql = "select max(oid) as oid from orders";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		int oid = 0;
		while (rs.next()) {
			oid = rs.getInt("oid") + 1;
		}
		// date 가져오기
		java.util.Date date = new java.util.Date();
		java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// order에 데이터 넣기
		sql = "insert into Orders values(?, ?, ?, ?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setInt(1, oid);
		pstmt.setString(2, df.format(date));
		pstmt.setString(3, uid);
		pstmt.setString(4, "KRW");
		pstmt.setDouble(5, 1);
		pstmt.setDouble(6, 1000000);
		pstmt.setString(7, "Deposit");
		pstmt.executeUpdate();	
		%>
	    <script type="text/javascript">
	        var confirmed = confirm("<%= uid + " " + uname %> 가입 성공");
		    window.location.href = "main.jsp";
	    </script>
		<%
	}
	catch (Exception e) {
		%>
	    <script type="text/javascript">
	        var confirmed = confirm("<%= e %>");
		    window.location.href = "main.jsp";
	    </script>
		<%
	}
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();
	// response.sendRedirect("main.jsp");
%>