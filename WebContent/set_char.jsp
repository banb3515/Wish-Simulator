<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
	Statement stmt = conn.createStatement();
	ResultSet rs = null;
%>
<script>
	function setPickup(charName, pickup) {
		frm.pickup.value = pickup;
		let pickupText = pickup == 1 ? "픽업" : "상시";
		
		if (!confirm(charName + " 캐릭터를 " + pickupText + "(으)로 설정합니다.")) return false;
		
		frm.action.value = "set_pickup";
		frm.name.value = charName;
		
		alert(charName + " 캐릭터를 " + pickupText +"(으)로 설정하였습니다.");
		
		frm.submit();
	}
</script>
<h1 style="font-size: 32px;">캐릭터 설정</h1><br>
<form action="action.jsp" method="post" name="frm">
	<input type="hidden" name="action">
	<input type="hidden" name="name">
	<input type="hidden" name="pickup">

	<div style="text-align: center; display:inline-block; *display:inline; zoom:1;">
		<div style="width: 45%; height: 80vh; float: left; overflow: auto; margin-right: 30px; margin-left: 16px;">
			<table class="table">
				<tr>
					<th colspan="3" class="top">픽업 캐릭터</th>
				</tr>
				
				<tr>
					<th class="bottom" width="100">이름</th>
					<th class="bottom" width="100">등급</th>
					<th class="bottom" width="100">픽업</th>
				</tr>
				
				<%
					rs = stmt.executeQuery("SELECT NAME, GRADE FROM WISH WHERE PICKUP = 1 ORDER BY GRADE DESC, NAME");
					
					while (rs.next()) {
							String grade = "";
						for (int i = 0; i < rs.getInt(2); i ++)
							grade += "★"; %>
						<tr style="background-color: white;">
							<td style="text-align: center;"><%= rs.getString(1) %></td>
							<td style="text-align: center; color: orange;"><%= grade %></td>
							<td style="text-align: center;"><a class="button" href="#" onclick="setPickup('<%= rs.getString(1) %>', 0)">해제</a></td>
						</tr>
					<% }
				%>
			</table>
		</div>
		
		<div style="width: 45%; height: 80vh; float: left; overflow: auto; margin-left: 30px;">
			<table class="table">
				<tr>
					<th colspan="3" class="top">상시 캐릭터</th>
				</tr>
				
				<tr>
					<th class="bottom" width="100">이름</th>
					<th class="bottom" width="100">등급</th>
					<th class="bottom" width="100">픽업</th>
				</tr>
				
				<%
					rs = stmt.executeQuery("SELECT NAME, GRADE FROM WISH WHERE PICKUP = 0 ORDER BY GRADE DESC, NAME");
					
					while (rs.next()) {
						String grade = "";
						for (int i = 0; i < rs.getInt(2); i ++)
							grade += "★"; %>
						<tr style="background-color: white;">
							<td style="text-align: center;"><%= rs.getString(1) %></td>
							<td style="text-align: center; color: orange;"><%= grade %></td>
							<td style="text-align: center;"><a class="button" href="#" onclick="setPickup('<%= rs.getString(1) %>', 1)">설정</a>
						</tr>
					<% }
					
					stmt.close();
					rs.close();
					conn.close();
				%>
			</table>
		</div>
	</div>
</form>