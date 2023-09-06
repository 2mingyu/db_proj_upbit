<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
<title>login.jsp</title>
</head>
<body>
	<div class="container">
	<h2>로그인</h2>
	<form name = login action="./processLogin.jsp" class="form-horizontal" method="post">
		<div class="form-group row">
			<label class="col-sm-2">로그인 UID</label>
			<div class="col-sm-3">
				<input type="text" id="uid" name="uid" class="form-control">
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-offset-2 col-sm-10 ">
				<input type="submit" class="btn btn-primary" value="로그인">
			</div>
		</div>
	</form>
	</div>

</body>
</html>