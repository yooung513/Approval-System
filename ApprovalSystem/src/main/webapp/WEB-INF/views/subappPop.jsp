<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>대리 결재 창</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
</head>
<body>
	<script type="text/javascript">
	$(function(){
		
		$(document).ready(function(){
			
			var result = "${result}";
			if (result == "fin"){
				alert("승인되었습니다.");
				self.close();
			}
		})
		
		$("#subBtn").on("click", function(event){
			
			if ( $("#takenCode").val() == "sel"){
				alert("대리결재자를 선택해주세요.");
			} else{
				$("#subFrm").attr("method", "post").attr("action", "subUser").submit();
			}

		})
		
	})
		

	function goSelect(){
		
		var rank = $("#takenCode option:selected").attr('value2');
		$("#subRank").empty();
		$("#subRank").append(rank);
	}
	
	</script>
	
	<form id="subFrm" name="subFrm" >
		<input type="hidden" id="givenCode" name="givenCode" value="${sessionScope.user.userCode }">
		<table style="margin:auto; margin-top:100px">
			<tr>
				<th> 대리 결재자 : </th>
				<td>
					<select id="takenCode" name="takenCode" onChange="goSelect()">
						<option value="sel"> 선택  </option>
						<c:forEach var="subUser" items="${subUser }">
							<option value="${subUser.userCode}" value2="${subUser.rankName }"> ${subUser.name}
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<th> 직급 : </th>
				<td id="subRank"> </td>
			</tr>
			<tr>
				<th> 대리자 : </th>
				<td> ${sessionScope.user.name }(${sessionScope.user.rankName}) </td>
			</tr>
		</table>
		<div style="margin-top:20px; text-align:center;">
			<input type="button" id="cancle" name="cancle" value="취소" onclick="self.close();">
			<input type="button" id="subBtn" name="subBtn" value="승인">
		</div>
	</form>
</body>
</html>