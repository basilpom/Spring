package org.zerock.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.zerock.domain.SampleVO;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/sample")
@Log4j
public class SampleController {
	
	@PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MEMBER')")
	@GetMapping("/annoMember")
	public void doMember2() {
		log.info("!!! LOGINED ANNOTATION MEMBER !!!");
	}
	
	@Secured({"ROLE_ADMIN"})
	@GetMapping("/annoAdmin")
	public void doAdmin2() {
		log.info("!!! ADMIN ANNOTATION ONLY !!!");
	}
	
	
	///////////////////////////////////////////////////////////////////////
	// Spring Security
	@RequestMapping(value = "/all", method = RequestMethod.GET)
	public void doAll() {
		log.info("DO ALL CAN ACCESS EVERYBODY!!!!!!");
	}
	@GetMapping("/member")
	public void doMember() {
		log.info("LOGINED MEMBER!!!!!!");
	}
	@GetMapping("/admin")
	public void doAdmin() {
		log.info("ADMIN ONLY!!!!!!");
	}

	
	
	//////////////////////////////////////////////////////////////////////
	@RequestMapping(value = "/getText", method = RequestMethod.GET, produces = "text/plain; charset=UTF-8")
	public String getText() {
		log.info("!!!!!!!!!"+ MediaType.TEXT_PLAIN_VALUE);
		return "Hello";
	}
	
	@RequestMapping(value = "/getSample", method = RequestMethod.GET)
	public SampleVO getSample() {
		return new SampleVO(123, "Taegyu", "Park");
	}
	
	@RequestMapping(value = "/getList", method = RequestMethod.GET)
	public List<SampleVO> getList() {
		return IntStream.range(1,10)
				.mapToObj(i -> new SampleVO(i, i+"first", i+"last"))
				.collect(Collectors.toList());
	}
	
	@RequestMapping(value = "/getMap", method = RequestMethod.GET)
	public Map<String, SampleVO> getMap() {
		Map<String, SampleVO> map = new HashMap<>();
		map.put("first", new SampleVO(111, "taegyu", "park"));
		map.put("second", new SampleVO(222, "taegyu", "park"));
		return map;
	}
	
	@RequestMapping(value = "/getList2", method = RequestMethod.GET)
	public Map<String, List<SampleVO>> getList2() {
		Map<String, List<SampleVO>> map = new HashMap<>();
		List<SampleVO> list = new ArrayList<>();
		
		list.add(new SampleVO(1, "gildong", "hong"));
		list.add(new SampleVO(2, "taegyu", "park"));
		list.add(new SampleVO(3, "soyoon", "hwang"));
		
		map.put("Data", list);
		
		return map;
	}
	
	@RequestMapping(value = "/check", method = RequestMethod.GET, params = {"height", "weight"})
	public ResponseEntity<SampleVO> check(Double height, Double weight){
		SampleVO vo = new SampleVO(0, ""+height, ""+weight);
		ResponseEntity<SampleVO> result = null;
		
		if(height < 150)
		{
			result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);
		}
		else
		{
			result = ResponseEntity.status(HttpStatus.OK).body(vo);
		}
		return result;
	}
	
	@RequestMapping(value = "/product/{cat}/{pid}", method = RequestMethod.GET)
	public String[] getPath(@PathVariable("cat") String cat, @PathVariable("pid") Integer pid) {
		return new String[] {"category : " + cat, "productid : " + pid};
	}
}
