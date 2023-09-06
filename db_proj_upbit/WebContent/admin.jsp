<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ include file="dbconn.jsp"%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>admin.jsp</title>
</head>
<body>
	<jsp:include page="menu.jsp" />
	<div class="jumbotron">
		<div class="container">
			<h1 class="display-3">admin</h1>
		</div>
	</div>
	<div class="container">
	<h3>UID-UNAME</h3>
	<%
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ResultSet rs2 = null;

	String sql = "select * from data_user";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	while (rs.next()) {
	%>
	<div class="col-md-4">
		<%=rs.getString("uid")%>
		<%=rs.getString("uname")%>
		<a href="./processDeleteUser.jsp?uid=<%=rs.getString("uid")%>"
			class="btn btn-danger" role="button">삭제></a>
	</div>
	<%
	}
	// 전체 보유 자산 출력
	sql = "select * from data_user";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	%><h3>보유 자산</h3>
	<%
	while (rs.next()) {
	%>
	<div><%=rs.getString("uid")%></div>
	<%
	sql = "select * from currency where cowner=?";
	pstmt = conn.prepareStatement(sql);
	String uid = rs.getString("uid");
	pstmt.setString(1, uid);
	rs2 = pstmt.executeQuery();
	%>
	<table class="table">
		<tbody>
			<tr>
				<%
				while (rs2.next()) {
				%>
				<th scope="col"><%=rs2.getString("cname")%></th>
				<th scope="col"><%=rs2.getString("amount")%></th>
				<%
				}
				%>
			</tr>
		</tbody>
	</table>
	<%
	}
	// 전체 주문 내역 출력
	sql = "select * from orders";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	%>
	<h3>주문 내역</h3>
	<table class="table">
		<thead>
			<tr>
				<th scope="col">oid</th>
				<th scope="col">tradeDate</th>
				<th scope="col">tradeUser</th>
				<th scope="col">tradeCurrency</th>
				<th scope="col">tradePrice</th>
				<th scope="col">tradeAmount</th>
				<th scope="col">side</th>
			</tr>
		</thead>
		<tbody>
			<%
			rs.last();
			do {
			%>
			<tr>
				<th scope="row"><%=rs.getString("oid")%></th>
				<td><%=rs.getString("tradeDate")%></td>
				<td><%=rs.getString("tradeUser")%></td>
				<td><%=rs.getString("tradeCurrency")%></td>
				<td><%=rs.getString("tradePrice")%></td>
				<td><%=rs.getString("tradeAmount")%></td>
				<td><%=rs.getString("side")%></td>
			</tr>
			<%
			} while (rs.previous());
			%>
		</tbody>
	</table>
	<%
	if (rs != null)
		rs.close();
	if (pstmt != null)
		pstmt.close();
	if (conn != null)
		conn.close();
	%>
	</div>
</body>
</html>