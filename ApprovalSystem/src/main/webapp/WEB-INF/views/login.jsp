<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 결재 시스템 로그인 </title>
<style>
	.wrap{
		text-align : center;
	}
</style>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
</head>
<body>
	<script>
		$(function(){
			
			var result = '<c:out value="${result}" />';
			
			$(document).ready(function(){
				if (result == "idFalse") {
					alert("등록되지 않은 사용자 입니다.");
					$("#id").focus();
					return
				} else if (result == "pwFalse") {
					alert("비밀번호가 일치하지 않습니다.");
					$("#pw").focus();
					return
				}
			})
			
			$("#pw").keyup(function(e){
				if (e.which === 13) {
					$("#loginbtn").click();
				}
			})
			
			$("#loginbtn").click(function(){
				var id = $("#id").val().trim();
				var pw = $("#pw").val();
				
				if (id == "") {
					alert("아이디를 입력하세요");
					$("#id").focus();
					return
				} else if (pw == ""){
					alert("패스워드를 입력하세요");
					$("#pw").focus();
					return
				} else {
					$("#loginfrm").attr("method", "post").attr("action", "/").submit();
				}
				
			})
		
		})
	</script>

	<div class="wrap">
		<form id="loginfrm" name="loginfrm" accept-charset="UTF-8">
			
				<h1> Login </h1>
				아이디 : <input type="text" id="id" name="id">	<br>
				비밀번호 : <input type="password" id="pw" name="pw"> <br>
				<input type="button" id="loginbtn" name="loginbtn" value="로그인">
				<input type="button" id="signup" name="signup" value="회원가입" onclick="location.href = 'Signup'">
			
		</form>
		
	</div>
	
</body>
</html>