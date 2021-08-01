<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>원신 - 기원 시뮬레이션</title>
<link rel="stylesheet" href="css/main.css">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Gothic+A1:wght@300;700&display=swap" rel="stylesheet">
</head>
<body>
	<% 
		String section = request.getParameter("section");
		int isSection = 0;
		if (section == null) section = "section.jsp";
		if (section.contains("section.jsp")) isSection = 1;
	%>
	
	<script>
		let section = <%= isSection %>;
	</script>

	<header>
		<%@ include file="header.jsp" %>
	</header>
	
	<section>
		<jsp:include page="<%= section %>" />
	</section>
	
	<nav>
		<%@ include file="nav.jsp" %>
	</nav>
	
	<footer>
		<%@ include file="footer.jsp" %>
	</footer>
</body>
</html>