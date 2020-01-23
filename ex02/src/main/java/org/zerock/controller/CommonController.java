package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.log4j.Log4j;

@Log4j
@Controller
public class CommonController {
	@GetMapping("/accessError")
	public void accessDenied(Authentication auth, Model model) {
		log.info("!!! ACCESS DENIED !!!" + auth);
		model.addAttribute("msg", "ACCESS DENIED");
	}
	
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		log.info("!!! ERROR :" + error);
		log.info("!!! LOGOUT : " + logout);
		
		if(error != null)
		{
			model.addAttribute("error", "LOGIN ERROR! CHECK YOUR ACCOUNT!");
		}
		if(logout != null)
		{
			model.addAttribute("logout", "LOGOUT SUCCESS!");
		}
	}
	
	@GetMapping("/customLogout")
	public void logoutGET() {}
	
	// security-context.xml 에서 invalidate-session="true" 로 지정하였기 때문에 아무것도 안해도 OK
	@PostMapping("/customLogout")
	public void logoutPost() {}
}
