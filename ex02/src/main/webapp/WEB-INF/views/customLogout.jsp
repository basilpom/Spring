<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./includes/header.jsp" %>

<div class="container-fluid">

	<div class="card shadow mb-4" style="width: 60%; margin: auto;">
		<div class="card-header py-3">
			<h4 class="m-0 font-weight-bold text-primary">Logout</h4>
		</div>
		
		<div class="card-body">
			<form action="/customLogout" method="post">
				<h6>로그아웃하시겠습니까?</h6>
				<button class="btn btn-primary">Logout</button>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
		</div>
	</div>
	
</div>

<%@ include file="./includes/footer.jsp" %>
