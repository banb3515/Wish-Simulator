<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<script>
	function wish(num) {
		if (frm.category.value == "none") {
			alert("카테고리를 선택해주세요.");
			return false;
		} else {
			frm.wish_num.value = num;
			frm.submit();
		}
		return true;
	}
	
	function setCategory(category) {
		if (frm.category.value == category) return false;
		location.replace("index.jsp?section=section.jsp?category=" + category);
	}
</script>
<form action="action.jsp" method="post" name="frm"> 
	<input type="hidden" name="action" value="wish">
	<input type="hidden" name="category" value="none">
	<input type="hidden" name="wish_num">
	
	<table class="table">
		<tr>
			<td><a href="#" class="button" onclick="setCategory('픽업')" style="width: 140px;">픽업</a></td>
			<td></td>
			<td><a href="#" class="button" onclick="setCategory('상시')" style="width: 140px;">상시</a></td>
		</tr>
	</table><br>
	
	<table class="table">
		<tr>
			<th class="left">스택 현황</th>
			
			<th class="left">픽업</th>
			<td style="background-color: white; font-weight: bold;">
				<%
					Statement stmt = conn.createStatement();
					ResultSet rs = stmt.executeQuery("SELECT STACK FROM WISH_STACK WHERE CS = 'STACK' AND CATEGORY = '픽업'");
					if (rs.next()) { %>
						<%= rs.getInt(1) %> 스택
					<% }
				%>
			</td>
			
			<th class="left">상시</th>
			<td style="background-color: white; font-weight: bold;">
				<%
					rs = stmt.executeQuery("SELECT STACK FROM WISH_STACK WHERE CS = 'STACK' AND CATEGORY = '상시'");
					if (rs.next()) { %>
						<%= rs.getInt(1) %> 스택
					<% }
				%>
			</td>
		</tr>
		
		<%
			rs = stmt.executeQuery("SELECT STACK FROM WISH_STACK WHERE CS = 'PICKUP'");
			if (rs.next()) {
				if (rs.getInt(1) == 1) { %>
					<tr>
						<th colspan="5" class="top">[픽업] 다음 5성 캐릭터 픽업 캐릭터 확정 !</th>
					</tr>
				<% }
			}
		%>
	</table><br><br>
	
	<img id="categoryImg" alt="카테고리 이미지"><br>
	
	<table class="table">
		<tr>
			<td><a class="button" href="#" onclick="wish(1)" style="background-color: #E0E0E0">기원(뽑기) 1회</a></td>
			<td><a class="button" href="#" onclick="wish(10)">기원(뽑기) 10회</a>
		</tr>
	</table>
</form>
<%
	rs.close();
	stmt.close();
	conn.close();

	request.setCharacterEncoding("UTF-8");	

	String category = request.getParameter("category");
	if (category == null) category = "픽업";
%>
<script>
	frm.category.value = "<%= category %>";
	document.getElementById("categoryImg").src = "images/section/<%= category %>.png"; 
</script>