<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>

<%@ include file="dbconn.jsp"%>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>market.jsp</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script type="text/javascript">
        // 특정 부분을 업데이트하는 함수
        function updateContent() {
            $.ajax({
                url: 'processGetPrice.jsp',
                type: 'GET',
                success: function(data) {
                    // 업데이트할 부분의 ID를 가진 요소를 찾아 업데이트합니다.
                    $('#content').html(data);
                },
                error: function() {
                    // 에러 처리
                }
            });
        }

        // 일정 시간마다 updateContent 함수를 호출하여 부분 업데이트
        setInterval(updateContent, 10000); // 5000ms = 5초
    </script>
</head>
<body>
	<jsp:include page="menu.jsp" />
	<div class="jumbotron">
		<div class="container">
			<h1 class="display-3">market</h1>
		</div>
	</div>
	<div class="container">
	<%
	String uid = request.getParameter("uid");
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	String sql = "select * from data_user where uid=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, uid);
	rs = pstmt.executeQuery();
	while (rs.next()) {
	%>
	<div class="col">
		<h3><%=rs.getString("uname")%></h3>
	</div>
	<%
	}
	// Upbit api로 가격 불러오기
	sql = "select mname from market";
	pstmt = conn.prepareStatement(sql);
	rs = pstmt.executeQuery();
	%>
	<div class="row">
		<div class="col-sm-4">
			<div id="content">
				<script type="text/javascript">updateContent()</script>
			</div>
		</div>
		<div class="col-sm-4">
			<form name=buy action="./processBuySell.jsp" class="form-horizontal" method="post">
				<div class="form-group row">
					<label class="col">매매수량(코인개수)</label>
				</div>
				<div class="form-group row">
					<div class="col">
						<input type="text" id="buyAmount" name="buyAmount" class="form-control">
					</div>
				</div>
				<div class="form-group row">
					<div class="col">
						<input type="hidden" name="uid" value="<%=uid %>" />
					</div>
				</div>
				<div class="form-group row">
					<div class="col">
						<select name="cname" class="form-control">
						<%
						while (rs.next()){
							if (!rs.getString("mname").equals("KRW")){
								%><option value=<%=rs.getString("mname") %>><%=rs.getString("mname") %></option>
							<%
							}
						}
						%>
						</select>
					</div>
				</div>
				<div class="form-group row">
					<div class="col">
						<select name="bs" class="form-control">
							<option value="Buy">Buy</option>
							<option value="Sell">Sell</option>
						</select>
					</div>
				</div>
				<div class="form-group row">
					<input type="submit" class="btn btn-primary" value="매매">
				</div>
			</form>
		</div>
	</div>
	<%
	// 개인 보유 자산 출력
	sql = "select * from currency where cowner=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, uid);
	rs = pstmt.executeQuery();
	%><h3>보유 자산</h3>
	<table class="table">
		<tbody>
			<tr>
				<%
				while (rs.next()) {
					%>
					<th scope="col"><%=rs.getString("cname")%></th>
					<th scope="col"><%=rs.getString("amount")%></th>
					<%
				}
				%>
			</tr>
		</tbody>
	</table>
	<%
	// 개인 주문 내역 출력
	sql = "select * from orders where tradeUser=?";
	pstmt = conn.prepareStatement(sql);
	pstmt.setString(1, uid);
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