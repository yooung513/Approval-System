<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<script src="https://code.jquery.com/jquery-3.6.3.min.js"></script>
</head>
<body>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		$(function(){

			$("#selEmail").change(function(){
				if( $("#selEmail").val() == "self" ){
					$("#mailAdd").attr("readonly", false).val("").focus();
				} else {
					$("#mailAdd").val( $("#selEmail").val() );
				}
			})
			
		})
		
		function findAddress(){
			  new daum.Postcode({
		            oncomplete: function(data) { //선택시 입력값 세팅
		            	
		            	var addr = ''; // 주소 변수
		                 
		                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
		                    addr = data.roadAddress;
		                } else { // 사용자가 지번 주소를 선택했을 경우(J)
		                    addr = data.jibunAddress;
		                }
		            	
		                document.getElementById("zipcode").value = data.zonecode; // 우편번호 넣기
		                document.getElementById("address1").value = addr; // 주소 넣기
		                document.getElementById("address2").focus(); //상세입력 포커싱
		            }
		        }).open();
		}
		
		function sendECode(){
			var email = $("#mailId").val() + "@" + $("#mailAdd").val();
			console.log("이메일 :::::" + email);
			
			$.ajax({
				type : "get",
				url : "sendECode?email=" + email,
				success : function(data) {
					
					alert("인증번호가 전송되었습니다.");
					$("#chkEmail").focus();
				}
			});
		}
	</script>
	
	<h3>회원가입</h3>
	<form id="signFrm" name="signFrm">
		<div>
			<table>
				<tr>
					<td> 아이디 : </td>
					<td> 
						<input type="text" id="id" name="id" placeholder="아이디를 입력하세요">
						<input type="button" id="chkid" name="chkid" value="중복체크">
					</td>
				</tr>
				<tr>
					<td> 비밀번호 : </td>
					<td> 
						<input type="password" id="pw1" name="pw1" placeholder="비밀번호를 입력하세요">
					</td>
				</tr>
				<tr>
					<td> 비밀번호 확인 : </td>
					<td> 
						<input type="password" id="pw2" name="pw2" placeholder="비밀번호를 입력하세요">
					</td>
				</tr>
				<tr>
					<td> 이름 : </td>
					<td> 
						<input type="text" id="name" name="name" placeholder="이름을 입력하세요">
					</td>
				</tr>
				<tr>
					<td> 우편번호 : </td>
					<td> 
						<input type="text" id="zipcode" name="zipcode" placeholder="우편번호" onclick="findAddress()">
						<input type="button" id="btnAdd" name="btnAdd" value="우편번호 찾기" onclick="findAddress()" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td> 주소 : </td>
					<td> 
						<input type="text" id="address1" name="address1" placeholder="주소를 입력하세요" readonly>
					</td>
				</tr>
				<tr>
					<td> 상세주소 : </td>
					<td> 
						<input type="text" id="address2" name="address2" placeholder="상세주소를 입력하세요">
					</td>
				</tr>
				<tr>
					<td> 이메일 : </td>
					<td> 
						<input type="text" id="mailId" name="mailId"> @
						<input type="text" id="mailAdd" name="mailAdd" readonly>
						<select id="selEmail" name="selEmail">
							<option value="" disabled selected> 선택 </option>
							<option value="naver.com" id="naver"> naver.com </option>
							<option value="daum.net" id="daum"> daum.net </option>
							<option value="gmail.com" id="gmail"> gmail.com </option>
							<option value="nate.com" id="nate"> nate.com </option>
							<option value="self" id="self"> 직접 입력하기 </option> 
						</select>
						<input type="button" id="btnEamil" name="btnEamil" value="인증 번호 " onclick="sendECode()"> <br>
						 
						<input type="text" id="txtEcode" name="txtEcode">
						<input type="button" id="chkEmail" name="chkEmail" value="인증 번호 확인 "> 
					</td>
				</tr>
				<tr>
					<td> 연락처 : </td>
					<td> 
					</td>
				</tr>
			</table>
			<br>
			<input type="button" id="signBtn" name="signBtn" value="회원가입">
		</div>
	</form>
</body>
</html>