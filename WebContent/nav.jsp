<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<ul>
	<li><a class="button" style="display: inline;" href="index.jsp?section=add_char.jsp">캐릭터 추가</a></li>
	<li><a class="button" style="display: inline;" href="index.jsp?section=set_char.jsp">캐릭터 설정</a></li>
	<li><a class="button" style="display: inline;" href="index.jsp?section=wish_history.jsp">기원 기록</a></li>
	<li><a id="back" class="button" style="display: inline;" href="index.jsp">돌아가기</a></li>
</ul>
<script>
	if (section == 1)
		document.getElementById("back").style.visibility = "hidden";
</script>