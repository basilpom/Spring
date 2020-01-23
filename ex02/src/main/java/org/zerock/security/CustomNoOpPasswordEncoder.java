package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomNoOpPasswordEncoder implements PasswordEncoder{@Override
	public String encode(CharSequence rawPassword) {
		log.warn("!! BEFORE ENCODE : " + rawPassword);
		return rawPassword.toString();
	}

	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		log.warn("!! MATCHES : " + rawPassword + " : " + encodedPassword);
		return encodedPassword.toString().equals(encodedPassword);
	}

}
