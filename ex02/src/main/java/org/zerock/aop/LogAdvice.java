package org.zerock.aop;

import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Log4j
@Aspect
@Component
public class LogAdvice {
	@Before("execution(* org.zerock.service.SampleService*.*(..))")
	public void logBefore() {
		log.info("======================= BEFORE");
	}
	
	@Before("execution(* org.zerock.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBeforeWithParam(String str1, String str2) {
		log.info("STR1 : " + str1);
		log.info("STR2 : " + str2);
	}
	
	@AfterThrowing(pointcut = "execution(* org.zerock.service.SampleService*.*(..))", throwing = "exception")
	public void logException(Exception exception) {
		log.info("!!!!! EXCEPTION !!!!!");
		log.info("EXCEPTION : " + exception);
	}
	
	@Around("execution(* org.zerock.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("!! TARGET : " + pjp.getTarget());
		log.info("!! PARAM : " + Arrays.toString(pjp.getArgs()));
		
		Object result = null;
		try
		{
			result = pjp.proceed();
		}
		catch(Throwable e)
		{
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("!! TIME : " + (end-start));
		
		return result;
	}
	
	@After("execution(* org.zerock.service.SampleService*.*(..))")
	public void logAfter() {
		log.info("======================= AFTER");
	}

}
