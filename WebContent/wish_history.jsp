<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	String category = request.getParameter("category");
	if (category == null) category = "전체";
	
	String categorySql = "";
	if (!category.equals("전체")) {
		categorySql = " H.CATEGORY = '" + category + "'";
	}
%>
<h1 style="font-size: 32px;">기원 기록</h1><br>
<form action="" name="frm">
	<table class="table">
		<tr>
			<th class="left">카테고리</th>
			<td style="background-color: white;">
				<select name="category" onchange="setCategory()">
					<option value="전체">전체</option>
					<option value="픽업">픽업</option>
					<option value="상시">상시</option>
				</select>
			</td>
		</tr>
	</table>
	
	<br><br>
	
	<%
		int pageNum = 0;
		int maxPageNum = 1;
		int viewCnt = 10;
		if (request.getParameter("page") != null)
			pageNum = Integer.parseInt(request.getParameter("page")) - 1;
	
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM WISH_HISTORY" + (categorySql == "" ? "" : " H WHERE" + categorySql));
		int count = 0;
		
		if (rs.next()) count = rs.getInt(1);
		
		if (count == 0) { %>
			<h3>기원 기록이 없습니다.</h3>
		<% } else { %>
			<table class="table">
				<tr>
					<th class="top" width="40">번호</th>
					<th class="top" width="100">캐릭터</th>
					<th class="top" width="100">등급</th>
					<th class="top" width="80">카테고리</th>
					<th class="top" width="280">날짜</th>
				</tr>
		
				<%
					maxPageNum = count / viewCnt;
					if (count % viewCnt != 0) maxPageNum ++;
					int nowView = count - pageNum * viewCnt;
					rs = stmt.executeQuery("SELECT * FROM " + 
											"(SELECT H.NUM, W.NAME, W.GRADE, H.CATEGORY, TO_CHAR(H.MDATE, 'YYYY\"년\" MM\"월\" DD\"일,\" HH24\"시\" MI\"분\" SS\"초\"'), ROW_NUMBER() OVER(ORDER BY H.NUM) RNUM " + 
											"FROM WISH W, WISH_HISTORY H WHERE W.NAME = H.NAME " + 
											(categorySql == "" ? "" : " AND" + categorySql) + ") " + 
											"WHERE RNUM BETWEEN " + (nowView - viewCnt + 1) + " AND " + nowView + " ORDER BY NUM DESC");
					
					while (rs.next()) { %>
						<tr style="background-color: white;">
							<% 
								String grade = "";
								for (int i = 0; i < rs.getInt(3); i ++)
									grade += "★";
							%>
						
							<td style="text-align: center;"><%= rs.getInt(1) %></td>
							<td style="text-align: center;"><%= rs.getString(2) %></td>
							<td style="text-align: center; color: orange;"><%= grade %></td>
							<td style="text-align: center;"><%= rs.getString(4) %></td>
							<td style="text-align: center;"><%= rs.getString(5) %></td>
						</tr>
					<% }
				%>
			</table>
		<% }
		
		rs.close();
		stmt.close();
		conn.close();
	%>
	
	<br><br>
	
	<table class="table">
		<tr>
			<td><a class="button" onclick="setPage(-1)" style="cursor: pointer;">◀</a></td>
			<td><span style="text-align: center; font-size: 18px; font-weight: bold;"><%= pageNum + 1 %></span></td>
			<td><a class="button" onclick="setPage(+1)" style="cursor: pointer;">▶</a></td>
		</tr>
	</table>
</form>
<script>
	let page = <%= pageNum + 1 %>;
	frm.category.value = "<%= category %>";

	function setCategory() {
		location.replace("index.jsp?section=wish_history.jsp?category=" + frm.category.value);
	}
	
	function setPage(pg) {
		let min = 1;
		let max = <%= maxPageNum %>;
		
		if (pg == -1 && page > min) {
			page = Number(page) + pg;
			movePage();
		}
		else if (pg == +1 && page < max) {
			page = Number(page) + pg;
			movePage();
		}
	}

	function movePage() {
		let maxPageNum = <%= maxPageNum %>;
		
		if (page >= 0 && page <= maxPageNum)
			location.replace("index.jsp?section=wish_history.jsp?category=<%= category %>&page=" + page);
		else {
			alert("1 ~ " + maxPageNum + "까지의 페이지를 입력해주세요.");
			return false;
		}
	}
</script>