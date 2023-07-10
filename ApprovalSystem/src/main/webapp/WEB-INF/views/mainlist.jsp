<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
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