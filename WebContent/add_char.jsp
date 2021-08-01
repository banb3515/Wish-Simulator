<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
	function add() {
		if (frm.name.value == "") {
			alert("캐릭터 이름을 입력해주세요.");
			frm.name.focus();
			return false;
		} else if (frm.image.value == "") {
			alert("이미지 파일을 선택해주세요.");
			frm.image.focus();
			return false;
		} else if (frm.grade.value == "none") {
			alert("캐릭터 등급을 선택해주세요.");
			frm.grade.focus();
			return false;
		} else {
			alert("캐릭터 추가가 완료되었습니다.");
			frm.submit();
		}
		return true;
	}
	
	function reset() {
		frm.reset();
	}
</script>
<h1 style="font-size: 32px;">캐릭터 추가</h1><br>
<form action="add_char_action.jsp" method="post" name="frm" enctype="multipart/form-data">
	<table class="table">
		<tr>
			<th class="left">이름</th>
			<td colspan="2" style="background-color: white;"><input type="text" name="name" required="required"></td>
		</tr>
		
		<tr>
			<th class="left">이미지</th>
			<td colspan="2" style="background-color: white;"><input type="file" accept="image/png, image/jpeg" name="image" required="required"></td>
		</tr>
		
		<tr>
			<th class="left">등급</th>
			<td colspan="2" style="background-color: white;">
				<select name="grade">
					<option value="none" selected="selected">-- 선택 --</option>
					<option value="5">★★★★★</option>
					<option value="4">★★★★</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<th class="left">픽업</th>
			<td style="background-color: white; text-align: center;"><input type="radio" name="pickup" value="1" checked="checked"> 설정</td>
			<td style="background-color: white; text-align: center;"><input type="radio" name="pickup" value="0"> 해제</td>
		</tr>
		
		<tr>
			<td><a href="#" onclick="reset()" class="button" style="background-color: #E0E0E0">초기화</a></td>
			<td colspan="2"><a href="#" onclick="add()" class="button">추가</a></td>
		</tr>
	</table>
</form>