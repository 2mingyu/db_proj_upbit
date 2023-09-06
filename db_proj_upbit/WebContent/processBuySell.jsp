<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>

<%@ include file="dbconn.jsp"%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>processBuy.jsp</title>
</head>
<body>
	<%
	String uid = request.getParameter("uid");
	String cname = request.getParameter("cname");
	float amount = Float.parseFloat(request.getParameter("buyAmount"));
	String bs = request.getParameter("bs");
	
	String sql = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	float KRWAmount = 0;
	float coinPrice = 0;
	float coinAmount = 0;
	//get KRWAmount
	sql = "select amount from currency where (cowner=? and cname=\"KRW\")";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, uid);
	rs = pstmt.executeQuery();
	while (rs.next()) {
		KRWAmount = rs.getFloat("amount");
	}
	// get coinPrice
	sql = "select price from market where mname=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, cname);
	rs = pstmt.executeQuery();
	while (rs.next()) {
		coinPrice = rs.getFloat("price");
	}
	//get coinAmount
	sql = "select amount from currency where (cowner=? and cname=?)";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, uid);
	pstmt.setString(2, cname);
	rs = pstmt.executeQuery();
	while (rs.next()) {
		coinAmount = rs.getFloat("amount");
	}
	// 조건확인(매수)
	if (bs.equals("Buy")){
		if (coinPrice * amount > KRWAmount) {	// 매수 실패
			%>
		    <script type="text/javascript">
		        var confirmed = confirm("<%= coinPrice + "*" + amount + ">" + KRWAmount %> 매수 실패");
			    window.location.href = "market.jsp?uid=" + <%=uid%>;
		    </script>
			<%
		}
		else {
			sql = "UPDATE currency SET amount=? WHERE (cowner=? and cname=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setFloat(1, amount);
			pstmt.setString(2, uid);
			pstmt.setString(3, cname);
			pstmt.executeUpdate();
			sql = "UPDATE currency SET amount=? WHERE (cowner=? and cname=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setFloat(1, KRWAmount - amount * coinPrice);
			pstmt.setString(2, uid);
			pstmt.setString(3, "KRW");
			pstmt.executeUpdate();
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
			pstmt.setString(4, cname);
			pstmt.setDouble(5, coinPrice);
			pstmt.setDouble(6, amount);
			pstmt.setString(7, bs);
			pstmt.executeUpdate();	
			%>
			<script type="text/javascript">
			    var confirmed = confirm("<%= amount + cname + bs%> 성공");
			    window.location.href = "market.jsp?uid=" + <%=uid%>;
			</script>
			<%
		}
	}
	// 조건확인(매도)
	else if (bs.equals("Sell")) {
		if (coinAmount < amount) {	// 매도 실패
			%>
		    <script type="text/javascript">
		        var confirmed = confirm("<%=amount + ">" + coinAmount %> 매도 실패");
			    window.location.href = "market.jsp?uid=" + <%=uid%>;
		    </script>
			<%
		}
		else {
			sql = "UPDATE currency SET amount=? WHERE (cowner=? and cname=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setFloat(1, coinAmount - amount);
			pstmt.setString(2, uid);
			pstmt.setString(3, cname);
			pstmt.executeUpdate();
			sql = "UPDATE currency SET amount=? WHERE (cowner=? and cname=?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setFloat(1, KRWAmount + amount * coinPrice);
			pstmt.setString(2, uid);
			pstmt.setString(3, "KRW");
			pstmt.executeUpdate();
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
			pstmt.setString(4, cname);
			pstmt.setDouble(5, coinPrice);
			pstmt.setDouble(6, amount);
			pstmt.setString(7, bs);
			pstmt.executeUpdate();	
			%>
			<script type="text/javascript">
			    var confirmed = confirm("<%= amount + cname + bs%> 성공");
			    window.location.href = "market.jsp?uid=" + <%=uid%>;
			</script>
			<%
		}
	}
	
	if (rs != null)
	rs.close();
	if (pstmt != null)
	pstmt.close();
	if (conn != null)
	conn.close();
	%>
</body>
</html>