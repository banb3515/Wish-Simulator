<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.io.File" %> 
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
	request.setCharacterEncoding("UTF-8");

	PreparedStatement pstmt = null;
	Statement stmt = null;
	ResultSet rs = null;

	String action = request.getParameter("action");
	String redirect = "index.jsp";
	if (action == null) response.sendRedirect("index.jsp");
	
	switch (action) {
	case "wish":
		String category = request.getParameter("category");
		int wishNum = Integer.parseInt(request.getParameter("wish_num"));
		ArrayList<String> wishChars = new ArrayList<String>();
		String wishVideo = "wish4";
		boolean stackFlag = false;
		int random = 0;
		
		for (int i = 0; i < wishNum; i ++) {
			random = (int)(Math.random() * (100 - 1 + 1) + 1);
			int grade = 0;
		
			if (random == 1) grade = 5;
			else grade = 4;
			
			stmt = conn.createStatement();
			
			stmt.executeUpdate("UPDATE WISH_STACK SET STACK = STACK + 1 WHERE CS = 'STACK' AND CATEGORY = '" + category + "'");
			
			int stack = 0;
			rs = stmt.executeQuery("SELECT STACK FROM WISH_STACK WHERE CS = 'STACK' AND CATEGORY = '" + category + "'");
			if (rs.next()) stack = rs.getInt(1);
			if (grade == 5 || stack == 90) {
				stmt.executeUpdate("UPDATE WISH_STACK SET STACK = 0 WHERE CS = 'STACK' AND CATEGORY = '" + category + "'");
				stackFlag = true;
				grade = 5;
			}
			
			rs = stmt.executeQuery("SELECT COUNT(*) FROM WISH WHERE GRADE = " + grade);
			int count = 0;
			if (rs.next()) count = rs.getInt(1);
			
			random = (int)(Math.random() * (count - 1 + 1) + 1);
			int pickup = 0;
			String sql = "";
			
			if (category.equals("픽업")) {
				if (random >= 1 && random <= 2) { 
					pickup = 1;
					
					if (grade == 5) stmt.executeUpdate("UPDATE WISH_STACK SET STACK = 0 WHERE CS = 'PICKUP'");
				}
				else {
					pickup = 0;
					
					if (grade == 5) {
						rs = stmt.executeQuery("SELECT STACK FROM WISH_STACK WHERE CS = 'PICKUP'");
						if (rs.next()) {
							if (rs.getInt(1) == 0)
								stmt.executeUpdate("UPDATE WISH_STACK SET STACK = 1 WHERE CS = 'PICKUP'");
							else if (rs.getInt(1) == 1) {
								stmt.executeUpdate("UPDATE WISH_STACK SET STACK = 0 WHERE CS = 'PICKUP'");
								pickup = 1;
							}
						}
					}
				}
				
				sql = "SELECT NAME FROM WISH WHERE GRADE = " + grade + " AND PICKUP = " + pickup;
			} else {
				sql = "SELECT NAME FROM WISH WHERE GRADE = " + grade;
			}
			
			rs = stmt.executeQuery(sql);
			ArrayList<String> chars = new ArrayList<String>();
			
			while (rs.next()) chars.add(rs.getString(1));
			random = (int)(Math.random() * (chars.size() - 1 + 1));
			
			String charName = chars.get(random);
			wishChars.add(charName);
			
			pstmt = conn.prepareStatement("INSERT INTO WISH_HISTORY VALUES (WISH_HISTORY_SEQ.NEXTVAL, ?, ?, ?)");
			pstmt.setString(1, charName);
			pstmt.setString(2, category);
			pstmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
			pstmt.executeUpdate();
			
			if (wishVideo.equals("wish4") && grade == 5) wishVideo = "wish5";
		}
		
		random = (int)(Math.random() * (2 - 1 + 1));
		if (wishVideo.equals("wish5") && random == 1 && !stackFlag) wishVideo = "wish4";
		
		pageContext.getSession().setAttribute("wish_chars", wishChars.toArray(new String[wishChars.size()]));
		pageContext.getSession().setAttribute("wish_num", wishNum);
		pageContext.getSession().setAttribute("wish_video", wishVideo);
		pageContext.getSession().setAttribute("category", category);
		redirect = "index.jsp?section=wish_result.jsp";
		break;
	case "set_pickup":
		pstmt = conn.prepareStatement("UPDATE WISH SET PICKUP = ? WHERE NAME = ?");
		pstmt.setInt(1, Integer.parseInt(request.getParameter("pickup")));
		pstmt.setString(2, request.getParameter("name"));
		pstmt.executeUpdate();
		
		redirect = "index.jsp?section=set_char.jsp";
		break;
	}
	
	if (rs != null) rs.close();
	if (pstmt != null) pstmt.close();
	if (stmt != null) stmt.close();
	conn.close();
	
	response.sendRedirect(redirect);
%>