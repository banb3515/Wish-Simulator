<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	String[] chars = (String[])request.getSession().getAttribute("wish_chars");
	int wishNum = (int)request.getSession().getAttribute("wish_num");
	String wishVideo = (String)request.getSession().getAttribute("wish_video");
	String category = (String)request.getSession().getAttribute("category");
%>
<style>
	#wish_video {
		position: fixed;
		right: 0;
		bottom: 0;
		min-width: 100%;
		min-height: 100%;
	}
		
	.video_container {
		position: relative;
	}
		
	.video_container video {
		display: block;
		position: absolute;
		z-index: 0;
	}
		
	.overlay {
		position: absolute;
		top: 20px;
		right: 80px;
		z-index: 1;
	}
		
	.overlay a {
		color: white;
		font-size: 30px;
		text-decoration: none;
		font-family: 'Jua', sans-serif;
		text-shadow: -1px 0 black, 0 1px black, 1px 0 black, 0 -1px black;
	}
</style>
<script>
	let wishVideo;

	window.onload = function () {
		let nav = document.getElementsByTagName("nav")[0]; 
		nav.style.visibility = "hidden";
		
		wishVideo = setTimeout(() => {
			showResult();
		}, 6200);
	}
	
	function skip() {
		clearTimeout(wishVideo);
		showResult();
	}
	
	function showResult() {
		let nav = document.getElementsByTagName("nav")[0];
		let result = document.getElementById("result");
		let video = document.getElementById("wish_video");
		let skip = document.getElementById("skip");
		video.style.visibility = "hidden";
		skip.style.visibility = "hidden";
		nav.style.visibility = "visible";
		result.style.visibility = "visible";
		skip.text = "";
	}
	
	function showSkip() {
		let skip = document.getElementById("skip");
		if (skip.style.visibility == "hidden") skip.style.visibility = "visible";
		else skip.style.visibility = "hidden";
	}
</script>
<figure id="wish_video" onclick="showSkip()">
	<div class="video_container">
		<video autoplay muted>
			<source src="video/<%= wishVideo %>.mp4" type="video/mp4">
		</video>
	
		<span class="overlay"><a href="#" onclick="skip()" id="skip" style="visibility: hidden;">건너뛰기  ➜</a></span>
	</div>
</figure>
<div id="result" style="visibility: hidden;">
	<h1 style="font-size: 32px;">기원 <%= wishNum %>회 결과</h1>
	
	<div style="height: 85vh; overflow: auto; margin-left: 20px; margin-right: 20px;">
		<%
			Statement stmt = conn.createStatement();
			ResultSet rs = null;
		
			if (chars.length == 1) { %>
				<table class="table" style="margin-left: 20px; margin-right: 20px;">
					<tr>
						<%
							rs = stmt.executeQuery("SELECT IMAGE FROM WISH WHERE NAME = '" + chars[0] + "'");
							String image = "";
							if (rs.next()) image = rs.getString(1); %>
						
						<th><img src="images/characters/<%= image %>" alt="<%= chars[0] %>" height="65%"></th>
					</tr>
		
					<tr>
						<th class="top"><%= chars[0] %></th>
					</tr>
				
					<tr>
						<%
							rs = stmt.executeQuery("SELECT GRADE FROM WISH WHERE NAME = '" + chars[0] + "'");
							String grade = "";
							if (rs.next()) {
								for (int loop = 0; loop < rs.getInt(1); loop ++)
									grade += "★";
							} %>	
								
						<th class="bottom" style="color: orange;"><%= grade %></th>
					</tr>
				</table>
		<% } else { %>
			<table class="table" style="margin-left: 20px; margin-right: 20px;">
				<tr>
					<%
						for (int i = 0; i < chars.length; i ++) {
							if (i == 5) break;
							
							String name = chars[i];
							
							rs = stmt.executeQuery("SELECT IMAGE FROM WISH WHERE NAME = '" + name + "'");
							String image = "";
							if (rs.next()) image = rs.getString(1); %>
							
							<th><img src="images/characters/<%= image %>" alt="<%= name %>" width="125"></th>
						<% }
					%>
				</tr>
			
				<tr>
					<%
					for (int i = 0; i < chars.length; i ++) {
						if (i == 5) break; %>
							<th class="top"><%= chars[i] %></th>
						<% }
					%>
				</tr>
				
				<tr>
					<%
						for (int i = 0; i < chars.length; i ++) {
							if (i == 5) break;
							
							rs = stmt.executeQuery("SELECT GRADE FROM WISH WHERE NAME = '" + chars[i] + "'");
							String grade = "";
							if (rs.next()) {
								for (int loop = 0; loop < rs.getInt(1); loop ++)
									grade += "★";
							} %>
							
							<th class="bottom" style="color: orange;"><%= grade %></th>
						<% }
					%>
				</tr>
			</table><br><br>
			
			<table class="table">
				<tr>
					<%
						for (int i = 5; i < chars.length; i ++) {
							String name = chars[i];
							
							rs = stmt.executeQuery("SELECT IMAGE FROM WISH WHERE NAME = '" + name + "'");
							String image = "";
							if (rs.next()) image = rs.getString(1); %>
							
							<th><img src="images/characters/<%= image %>" alt="<%= name %>" width="125"></th>
						<% }
					%>
				</tr>
			
				<tr>
					<%
						for (int i = 5; i < chars.length; i ++) { %>
							<th class="top"><%= chars[i] %></th>
						<% }
					%>
				</tr>
				
				<tr>
					<%
						for (int i = 5; i < chars.length; i ++) {
							rs = stmt.executeQuery("SELECT GRADE FROM WISH WHERE NAME = '" + chars[i] + "'");
							String grade = "";
							if (rs.next()) {
								for (int loop = 0; loop < rs.getInt(1); loop ++)
									grade += "★";
							} %>
							
							<th class="bottom" style="color: orange;"><%= grade %></th>
					<% } %>
				</tr>
			</table>
		<% }
			rs.close();
			stmt.close();
			conn.close();
		%>
	</div>
	
	<a href="index.jsp?section=section.jsp?category=<%= category %>" class="button">다시 뽑기</a>
</div>