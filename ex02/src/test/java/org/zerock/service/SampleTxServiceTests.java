package org.zerock.service;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class SampleTxServiceTests {
	@Setter(onMethod_ = @Autowired)
	private SampleTxService service;
	
	@Test
	public void testLong() {
		String str = "I want to shoot a movie with you.";// Hold you hand and walk, run, fly with you. Why am I blooming when I look at you. I can change the world to be with you so take my hand. walk, run, fly with you~~~~";
		log.info(str.getBytes().length);
		service.addData(str);
	}

}
