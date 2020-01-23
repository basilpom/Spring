package org.zerock.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.domain.Criteria.Criteria;
import org.zerock.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@RestController
@AllArgsConstructor
@RequestMapping("/replies/")
public class ReplyController {
	private ReplyService service;
	
	// 댓글 작성
	@PreAuthorize("isAuthenticated()")
	@RequestMapping(value = "/new", method = RequestMethod.POST, consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		log.info("!!! REPLY VO !!!" + vo);
		
		int insertCount = service.register(vo);
		log.info("REPLY INSERT COUNT : " + insertCount);
		return insertCount == 1 ? new ResponseEntity<>("Success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	// 댓글 목록
	@RequestMapping(value = "/pages/{bno}/{page}", method = RequestMethod.GET, produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno){
		log.info("!!! GET LIST !!!");
		
		Criteria cri = new Criteria(page, 10);
		log.info(cri);
		
		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
		//return new ResponseEntity<>(service.getList(cri, bno), HttpStatus.OK);
	}
	// 댓글 상세보기
	@RequestMapping(value = "/{rno}", method = RequestMethod.GET, produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("!!! GET !!!" + rno);
		
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	// 댓글 수정
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(value = "/{rno}", method = {RequestMethod.PUT, RequestMethod.PATCH}, consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@PathVariable("rno") Long rno, @RequestBody ReplyVO vo) {
		log.info("!!! MODIFY !!!" + rno);
		vo.setRno(rno);
		
		return service.modify(vo) == 1 ? new ResponseEntity<>("Success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 댓글 삭제
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(value = "/{rno}", method = RequestMethod.DELETE, produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno, @RequestBody ReplyVO vo) {
		log.info("!!! REMOVE !!!" + rno);
		return service.remove(rno) == 1 ? new ResponseEntity<>("Success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
 	}
	
}
