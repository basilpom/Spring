<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="./includes/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
	<!-- <h1 class="h3 mb-2 text-gray-800">Custom Login Page</h1> -->
	
	
	<div class="card shadow mb-4" style="width: 60%; margin: auto;">
		<div class="card-header py-3">
			<h4 class="m-0 font-weight-bold text-primary">Please Sign in</h4>
		</div>
		
		<div class="card-body">
			<form method="post" action="/login">
				<div class="form-group">
					<input class="form-control" type="text" name="username" placeholder="userid" autofocus/>
				</div>
				<div class="form-group">
					<input class="form-control" type="password" name="password" placeholder="password" />
				</div>
				<div class="checkbox">
					<label>
						<input name="remember-me" type="checkbox">Remember Me
					</label>
				</div>
				<div class="form-group">
					<input class="form-control" type="submit" />
				</div>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
		</div>
		
		<div class="card-footer">
			${error}
			<!-- ${logout} -->
		</div>
		
	</div>
	
</div>

<%@ include file="./includes/footer.jsp" %>
<c:if test="${param.logout != null}">
	<script>
		$(document).ready(function(){
			if(history.state)
			{
				return;
			}
			alert("로그아웃하였습니다.");
			history.replaceState({}, null, null)
		});
	</script>
</c:if>