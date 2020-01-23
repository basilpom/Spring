package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		log.warn("LOGIN SUCCESS!");
	
		// 로그인 한 사용자의 권한 가져오기
		List<String> roleNames = new ArrayList<>();
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});
		log.warn("ROLE NAMES : " + roleNames);
	
		// Role 에 따라 다르게 redirect
		if(roleNames.contains("ROLE_ADMIN"))
		{
			response.sendRedirect("/sample/admin");
			return;
		}
		if(roleNames.contains("ROLE_MEMBER"))
		{
			response.sendRedirect("/sample/member");
			return;
		}
		/*
		if(roleNames.contains("ROLE_USER"))
		{
			response.sendRedirect("/sample/all");
			return;
		}
		*/
		response.sendRedirect("/");
	}

}
