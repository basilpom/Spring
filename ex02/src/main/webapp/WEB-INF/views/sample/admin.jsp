<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ADMIN</title>
</head>
<body>
	<h1>ADMIN PAGE</h1>

	<p>principal : <sec:authentication property="principal" /></p>
	<p>MemberVO : <sec:authentication property="principal.member" /></p>
	<p>Name : <sec:authentication property="principal.member.userName" /></p>
	<p>username : <sec:authentication property="principal.username" /></p>
	<p>authList : <sec:authentication property="principal.member.authList" /></p>
	
	<a href="/customLogout">Logout</a>
</body>
</html>