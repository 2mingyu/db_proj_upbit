<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head>
<link rel="stylesheet" href="./resources/css/bootstrap.min.css" />
<title>signup.jsp</title>
</head>
<body>
	<div class="container">
	<h2>회원가입</h2>
	<form name = "signup" action="./processSignup.jsp" class="form-horizontal" method="post">
		<div class="form-group row">
			<label class="col-sm-2">가입 ID</label>
			<div class="col-sm-3">
				<input type="text" id="uid" name="uid" class="form-control">
			</div>
		</div>
		<div class="form-group row">
			<label class="col-sm-2">가입 닉네임</label>
			<div class="col-sm-3">
				<input type="text" id="uname" name="uname" class="form-control">
			</div>
		</div>
		<div class="form-group row">
			<div class="col-sm-offset-2 col-sm-10 ">
				<input type="submit" class="btn btn-primary" value="가입">
			</div>
		</div>
	</form>
	</div>
</body>
</html>