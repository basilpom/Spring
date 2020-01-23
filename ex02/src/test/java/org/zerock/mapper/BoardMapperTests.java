package org.zerock.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Test
	public void testGetList() {
		mapper.getList().forEach(board -> log.info(board));
	}
//	
//	@Test
//	public void testInsert() {
//		BoardVO board = new BoardVO();
//		board.setTitle("insert test title");
//		board.setContent("ooh haha");
//		board.setWriter("mika");
//		
//		mapper.insert(board);
//		
//		log.info(board);
//	}
//	
//	@Test
//	public void testInsertSelectKey() {
//		BoardVO board = new BoardVO();
//		board.setTitle("select key test");
//		board.setContent("ssyang....");
//		board.setWriter("mika naena");
//		
//		mapper.insertSelectKey(board);
//		
//		log.info(board);
//	}
	
//	@Test
//	public void testRead() {
//		BoardVO board = mapper.read(24L);
//		
//		log.info(board);
//	}
	
//	@Test
//	public void testDelete() {
//		log.info("!!!! DELETE COUNT : " + mapper.delete(22L));
//	}
	
//	@Test
//	public void testUpdate() {
//		BoardVO board = new BoardVO();
//		
//		board.setBno(23L);
//		board.setTitle("update title");
//		board.setContent("update content");
//		board.setWriter("apeach");
//		
//		int count = mapper.update(board);
//		log.info("!!!! UPDATE COUNT : " + count);
//	}
}
