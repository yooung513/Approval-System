<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결재 시스템 메인</title>
<style>
	.header{
		height : 30px;
		margin : 15px;
	}
	.headerBtn{
		height : 30px;
		margin : 10px;
		float:right
	}
	.schBoarder{
		height : 80px;
		margin-top : 70px;
		margin-left : 30px;
		margin-right : 30px;
		padding : 20px;
		padding-right : 50px;
		border : 1px solid;
	}
	.boarder{
		height : 300px;
		margin-top : 50px;
		margin-left : 30px;
		margin-right : 30px;
	}
	table{
		margin: auto;
	}
	
</style>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
</head>
<body>
	<script type="text/javascript">
		$(function(){
			
			$(document).ready(function(){
				
				var result = "${result}";
				if (result == "zero"){
					html = "";
					html += "<tr>";
					html += "<td colspan='7'> 검색 결과가 없습니다. </td>";
					html += "</tr>";
					
					$("#tList").append(html);
				}
				
				// 직급
				var rank = "${sessionScope.user.rankCode}";
				
				// 직급에 따른 결재 버튼 표시
				if (rank == 'B' || rank == 'G'){
					
					var htmlhead = '<input type="button" id="subapp" name="subapp" value="대리결제" onclick="goSubApp()"> ';
					$("#headerBtn").append(htmlhead);
					
				}
				
				var date = '${search.strDate}';
				if ( date == null || date == '' ){
					
					// 검색 날짜 지정 (한달 전 ~ 오늘)
					var today = new Date();
					
					var endDate = today.toISOString().substring(0,10);
					$("#endDate").val(endDate);
					
					var strDate = new Date(today.setMonth(today.getMonth()-1));
					strDate = strDate.toISOString().substring(0,10);
					$("#strDate").val(strDate);
				}
				
			})
			

			$("#schBtn").on("click", function(event){
				if ( $("#searchType").val() != "sel" && $("#keyword").val() == "" ){
					alert("검색어를 입력해주세요.");
				} else {
					$("#schFrm").attr("method", "post").attr("action", "searchByCon").submit();	
				}
			})
			
		})	
		
		function findByState(){
			
			$.ajax({
				
				url : "searchByState",
				type : "post",
				data : $("#schFrm").serialize(),
				success : function(dataMap){
				
					$("#frmList").html(dataMap);
				
				},
				error : function(){
					alert("error");
				}
			})
			
	    }
		
		function goSubApp(){
			window.open("/subappPop", "subappPop", "width=640, height=400")
		}
		
	</script>
	
	<div class="header">
			${sessionScope.user.name }(${sessionScope.user.rankName})님 환영합니다.
			<c:if test="${sessionScope.subUser.name != null}"> <br> 대리자 : ${sessionScope.subUser.name }(${sessionScope.subUser.rankName})님 </c:if>
			<input type="button" id="logout" name="logout" value="로그아웃" style="float:right;" onclick=" location.href='logout'">
	</div>
	
	<div id="headerBtn" class="headerBtn">
		<input type="button" id="write" name="write" value="글쓰기" onclick=" location.href = 'content'"> 
 	</div>
 	
 	<form id="schFrm" name="schFrm">
 		<div class="schBoarder">
 			<select id="searchType" name="searchType">
				<option value="sel" 		<c:if test="${search.searchType eq 'sel' }" > 		selected </c:if>> 선택 	 </option>
				<option value="writer"  	<c:if test="${search.searchType eq 'writer' }" > 	selected </c:if>> 작성자  	 </option>
				<option value="approver" 	<c:if test="${search.searchType eq 'approver' }" > 	selected </c:if>> 결재자 	 </option>
				<option value="doc" 	 	<c:if test="${search.searchType eq 'doc' }" > 		selected </c:if>> 제목+내용  </option>
			</select>
			
			<input type="text" id="keyword" name="keyword" size="30" placeholder="검색어를 입력하세요." value="${search.keyword }"> &nbsp; &nbsp;
			
			<select id="stateCode" name="stateCode" onchange="findByState()">
				<option value="sel"  <c:if test="${search.stateCode eq 'sel'  }" > selected </c:if>> 결재상태 </option>
				<option value="S_01" <c:if test="${search.stateCode eq 'S_01' }" > selected </c:if>> 임시저장 </option>
				<option value="S_02" <c:if test="${search.stateCode eq 'S_02' }" > selected </c:if>> 결재대기 </option>
				<option value="S_03" <c:if test="${search.stateCode eq 'S_03' }" > selected </c:if>> 결재중 	 </option>
				<option value="S_04" <c:if test="${search.stateCode eq 'S_04' }" > selected </c:if>> 결재완료  </option>
				<option value="S_05" <c:if test="${search.stateCode eq 'S_05' }" > selected </c:if>> 반려 	 </option>
			</select> <br> <br>
			
			<input type="date" id="strDate" name="strDate" value="${search.strDate }"/> ~ <input type="date" id="endDate" name="endDate" value="${search.endDate }"/> 
			<input type="button" id="schBtn" name="schBtn" style="width:80px; float:right;" value="검색">
 		</div>	
 	</form>
 	
 	<div class="boarder">
 	<form id="frmList" name="frmList">
 		<table border="1">
 		
 		<thead>
 			<tr>
 				<th style="width : 100px;"> 번호 </th>
 				<th style="width : 200px;"> 작성자 </th>
 				<th style="width : 300px;"> 제목 </th>
 				<th style="width : 200px;"> 작성일 </th>
 				<th style="width : 200px;"> 결재일 </th>
 				<th style="width : 200px;"> 결재자 </th>
 				<th style="width : 200px;"> 결재상태 </th>
 			</tr>
 		</thead>
 		
 		<tbody id="tList">
			<c:forEach items="${document }" var="document" varStatus="num">
				<tr onclick="location.href = 'content?seq=${document.seq }'">
					<td> ${document.seq } </td>
					<td> ${document.writer } </td>
					<td> ${document.title } </td>
					<td> ${document.regDate } </td>
					<td> ${document.appDate } </td>
					<td> 
						<c:if test="${document.subName == null}"> ${document.approver } </c:if>
						<c:if test="${document.subName != null}"> ${document.subName } (${document.approver}) </c:if>
					</td>
					<td> ${document.stateName } </td>
				</tr>
			</c:forEach>
		</tbody>
 		
 		</table>
 	</form>
 	</div>
	
</body>
</html>