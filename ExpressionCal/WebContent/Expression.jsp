<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Home</title>
<style type="text/css">
textarea {
	border: none;
}

div {
	height: 400px;
	width: 50%;
	background-color: powderblue;
	display: block;
}
</style>
<script type="text/javascript">
	function erase() {
		document.getElementById("output").value = "";
	}
</script>
</head>

<body>
	<center>
		<div id="div">
			<form action="ExpressionServlet" method="post">
				<table align="center" border="0">
					<caption>
						<h2>Expression Calculator</h2>
					</caption>
					<tr>
						<td>Enter an Expression :</td>
						<td><textarea style="width: 200%" rows="5" name="text"></textarea></td>
					</tr>
					<tr>
						<td>Result:</td>
						<td><textarea id="output" style="width: 200%" rows="1" />${express}
							</textarea></td>
					</tr>
					<tr>
						<td></td>
						<td><input type="submit" value="submit" id="submit"></td>
						&nbsp&nbsp
						<td><input type="button" value="Clear" id="clear"
							onclick="javascript:erase();"></td>
					</tr>
				</table>
			</form>
		</div>
	</center>
</body>
</html>