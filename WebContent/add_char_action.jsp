<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>    
<%@ page import="java.sql.*" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@page import="com.oreilly.servlet.MultipartRequest" %>
<%@ include file="dbConnection.jsp" %>
<%
	int size = 1024 * 1024 * 10;
	String path = request.getSession().getServletContext().getRealPath("/MyWeb/images/characters/");
	File pathFolder = new File(path);
	
	if (!pathFolder.exists()) pathFolder.mkdirs();
	
	MultipartRequest multi = new MultipartRequest(request, path, size, "UTF-8", new DefaultFileRenamePolicy());
	
	String image = multi.getOriginalFileName("image");
	int pos = image.lastIndexOf(".");
	String ext = image.substring(pos);
	
	File oldFile = new File(path + image);
    File newFile = new File(path + multi.getParameter("name") + ext);
    oldFile.renameTo(newFile);
	
	PreparedStatement pstmt = null;
	
	pstmt = conn.prepareStatement("INSERT INTO WISH VALUES (?, ?, ?, ?)");
	pstmt.setString(1, multi.getParameter("name"));
	pstmt.setString(2, multi.getParameter("name") + ext);
	pstmt.setInt(3, Integer.parseInt(multi.getParameter("grade")));
	pstmt.setInt(4, Integer.parseInt(multi.getParameter("pickup")));
	pstmt.executeUpdate();
	
	pstmt.close();
	conn.close();
	
	response.sendRedirect("index.jsp?section=add_char.jsp");
%>