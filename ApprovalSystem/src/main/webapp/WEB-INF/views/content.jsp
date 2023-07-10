<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결재</title>
<style>
	.header{
		height : 100px;
		padding-top : 30px;
	}
	table{
		margin: auto;
	}
	.headerth{ 
		width : 200px;
		
	}
	.body{
		height : 250px;
		margin: auto;
	}
	.bodyBtn{
		height : 50px;
		margin-bottom : 10px;
		margin-right : 250px; 
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
</head>
<body>
	
	<script>
		$(function(){
			
			$(document).ready(function(){
				
				var result 		= "${result}";
				var state 		= "${document.stateCode}"; 
				var approver 	= "${document.approverRank}"
				var writer 		= "${writer}";
				var rank 		= "${sessionScope.user.rankCode}";
				var subRank 	= "${sessionScope.subUser.rankCode}"
				
				if (subRank != null && subRank != ""){
					
					rank = subRank
				}
				
				if (result == "saved"){
					
					$("#title").attr("value", "${document.title }").attr("readonly", true);
					$("#content").append("${document.content }").attr("readonly", true);
					
					if ((rank == "B" && state != "S_04") || (rank == "G" && state != "S_03")){
						$("#bodyBtn").append("<input type='button' id='approval' name='approval' value='결재' style='float:right; ' onclick='goApproval()'>");
						$("#bodyBtn").append("<input type='button' id='reject' name='reject' value='반려' style='float:right; margin-right:10px;' onclick='goReject()'>");
					}
						
				} else if (result == "tmp"){
					
					$("#title").attr("value", "${document.title }").attr("readonly", false);
					$("#content").attr("readonly", false);
					$("#content").append("${document.content }");
					
				} else if (result == "reject"){
					
					if (writer == "mine"){
						$("#title").attr("value", "${document.title }").attr("readonly", false);
						$("#content").attr("readonly", false);
						$("#content").append("${document.content }");
						
						$("#bodyBtn").append("<input type='button' id='approval' name='approval' value='결재' style='float:right; ' onclick='goApproval()'>");
						$("#bodyBtn").append("<input type='button' id='tempSave' name='tempSave' value='임시저장' style='float:right; margin-right:10px; ' onclick='goTemp()'>");
					} else {
						
						$("#title").attr("value", "${document.title }").attr("readonly", true);
						$("#content").append("${document.content }").attr("readonly", true);
					}
				}
				
				
				if (state == "S_02"){
					$("#chkRequest").attr("checked", true);
				} else if (state == "S_03") {
					$("#chkRequest").attr("checked", true);
					$("#chkG").attr("checked", true);
				} else if (state == "S_04"){
					$("#chkRequest").attr("checked", true);
					$("#chkG").attr("checked", true);
					$("#chkB").attr("checked", true);
				} 
				
			})
			
		})
		
		
		function goTemp(){
			
			if ( $("#title").val() == null || $("#title").val() == "" ){
				alert("제목을 입력해주세요.");
			} else if ( $("#content").val() == null || $("#content").val() == "" ) {
				alert("내용을 입력해주세요.");
			} else {
				$("#insertFrm").attr("method", "post").attr("action", "tempSave").submit();
			}
		
		}
		
		function goApproval(){
			
			if ( $("#title").val() == null || $("#title").val() == "" ){
				alert("제목을 입력해주세요.");
			} else if ( $("#content").val() == null || $("#content").val() == "" ) {
				alert("내용을 입력해주세요.");
			} else {
				$("#insertFrm").attr("method", "post").attr("action", "approval").submit();
			}
		
		}
		
		function goReject(){
			
			$("#insertFrm").attr("method", "post").attr("action", "reject").submit();
		
		}
		
	</script>
	
	<div class="header"> 
		<table border="1">
			<tr>
				<th class="headerth"> 결재요청 </th>
				<th class="headerth"> 과장 </th>
				<th class="headerth"> 부장 </th>
			</tr>
			<tr>
				<th class="headerth"> <input type="checkbox" id="chkRequest" name="chkRequest" disabled="disabled"> </th>
				<th class="headerth"> <input type="checkbox" id="chkG" name="chkG" disabled="disabled"> </th>
				<th class="headerth"> <input type="checkbox" id="chkB" name="chkB" disabled="disabled"> </th>
			</tr>
		</table>
	</div>
	
	<form id="insertFrm" name="insertFrm">
	<div class="body" id="insertDiv">
<%-- 	<c:if test="${sessionScope.subUser.name != null}"> --%>
		<input type="hidden" id="subName" name="subName" value="${sessionScope.subUser.name}">
		<input type="hidden" id="subCode" name="subCode" value="${sessionScope.subUser.userCode}">
		<input type="hidden" id="subRank" name="subRank" value="${sessionScope.subUser.rankCode}">
<%-- 	</c:if> --%>
		<input type="hidden" id="docState" name="docState" value="${document.stateCode}">
		<input type="hidden" id="rank" name="rank" value="${sessionScope.user.rankCode}">
		<table>
			<tr>
				<th> 번호 : </th>
				<td> <input type="text" id="seq" name="seq" value="${seq}" readonly="readonly"> </td>
			</tr>
			<tr>
				<th> 작성자: </th>
				<td> 
					<c:if test="${result eq 'write'}" > 
						<input type="text" id="writer" name="seq" value="${sessionScope.user.name}" readonly="readonly">
					</c:if> 
					<c:if test="${result eq 'saved' || result eq 'tmp' || result eq 'reject'}" > 
						<input type="text" id="writer" name="seq" value="${document.writer}" readonly="readonly"> 
					</c:if>
				</td>
			</tr>
			<tr>
				<th> 제목 : </th>
				<td> <input type="text" id="title" name="title"> </td>
			</tr>
			<tr>
				<th> 내용 : </th>
				<td> <textarea id="content" name="content" cols="30" rows="10"></textarea> </td>
			</tr>
		</table>
	</div>
	
	<div class="bodyBtn" id="bodyBtn">		
		<c:if test="${result eq 'tmp'}">
			<input type="button" id="approval" name="approval" value="결재" style="float:right; " onclick="goApproval()">
			<input type="button" id="tempSave" name="tempSave" value="임시저장" style="float:right; margin-right:10px; " onclick="goTemp()">
		</c:if>
		<c:if test="${result eq 'write'}">
			<input type="button" id="approval" name="approval" value="결재" style="float:right; " onclick="goApproval()">
			<input type="button" id="tempSave" name="tempSave" value="임시저장" style="float:right; margin-right:10px; " onclick="goTemp()">
		</c:if>
		
	</div>
	</form>
	
	<div class="footer">
		<table border="1">
			<tr>
				<th style="width : 100px;"> 번호 </th>
				<th style="width : 200px;"> 결재일 </th>
				<th style="width : 200px;"> 결재자 </th>
				<th style="width : 200px;"> 결재상태 </th>
			</tr>
			
			<c:forEach items="${history }" var="history">
				<tr>
					<td> ${history.hisSeq } </td>
					<td> ${history.appDate } </td>
					<td> 
						<c:if test="${history.subName == null}"> ${history.approver } </c:if>
						<c:if test="${history.subName != null}"> ${history.subName } (${history.approver}) </c:if>
					</td>
					<td> ${history.stateName } </td>
				</tr>
			</c:forEach>
		</table>
		<br> <br>
		<input type="button" id="goMain" name="goMain" value="목록으로" style="display:block; margin:auto;"  onClick=" location.href = 'main'">
	</div>
</body>	
</html>