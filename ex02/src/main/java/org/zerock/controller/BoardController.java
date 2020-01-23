package org.zerock.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.PageDTO;
import org.zerock.domain.Criteria.Criteria;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@AllArgsConstructor
@RequestMapping("/board/*") // 대표 주소
public class BoardController {
	private BoardService service;
	
	// 목록 화면
//	@RequestMapping(value = "/list", method = RequestMethod.GET)
//	public void list(Model model) {
//		log.info("list");
//		// list 라는 이름으로 jsp 에 보낸다!
//		model.addAttribute("list", service.getList());
//	}
	
	// list with paging
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void list(Criteria cri, Model model) {
		log.info("list : " + cri);
		int total = service.getTotal(cri);
		log.info("total : " + total);
		
		model.addAttribute("list", service.getListWithPaging(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	// 등록 화면
	@PreAuthorize("isAuthenticated()")	// 로그인 한 사용자만 
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public void register() {}
	
	// 등록 DB 처리
	@PreAuthorize("isAuthenticated()")
	@RequestMapping(value = "/register", method = RequestMethod.POST)
	// board 자동 수집!! 없으면 만들어 내므로 에러는 안남...^^
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("!!!! REGISTER : " + board);
//		log.info("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//		if(board.getAttachList() != null)
//		{
//			board.getAttachList().forEach(attach -> log.info(attach));
//		}
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	
	// 상세 보기
	@RequestMapping(value = "/get", method = RequestMethod.GET)
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get");
		model.addAttribute("board", service.get(bno));
	}
	
	// 첨부 파일 목록
	@ResponseBody
	@RequestMapping(value = "/getAttachList", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		log.info("getAttachList : " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	// 수정 화면
	@PreAuthorize("principal.username == #writer")
	@RequestMapping(value = "/modify", method = RequestMethod.GET)
	public void modify(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model, String writer) {
		log.info("/modify");
		model.addAttribute("board", service.get(bno));
	}
	
	// 수정 처리
	@PreAuthorize("principal.username == #board.writer")
	@RequestMapping(value = "/modify", method = RequestMethod.POST)
	public String modify(BoardVO board, @ModelAttribute("cri") Criteria cri, RedirectAttributes rttr) {
		log.info("modify : " + board);
		
		if(service.modify(board))
		{
			rttr.addFlashAttribute("result", "modify");
		}
		
		// 수정 후 첫페이지 아닌 이전에 보던 페이지로  + 검색조건 유지
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	// 삭제 처리
	@PreAuthorize("principal.username == #writer")
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String remove(@RequestParam("bno") Long bno, Criteria cri, RedirectAttributes rttr, String writer) {
		log.info("remove : " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno))
		{
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "remove");
		}
		
		// 삭제 후 첫페이지 아닌 이전에 보던 페이지로  + 검색조건 유지
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	// 첨부파일 삭제 method
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0)
		{
			return;
		}
		log.info("delete attach files.................");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			try
			{
				Path file = Paths.get("C:/upload/" + attach.getUploadPath() + "/" + attach.getUuid() + "_" + attach.getFileName());
				Files.deleteIfExists(file);
				
				// 이미지 파일의 경우 썸네일도 삭제
				if(Files.probeContentType(file).startsWith("image"))
				{
					Path thumbnail = Paths.get("C:/upload/" + attach.getUploadPath() + "/s_" + attach.getUuid() + "_" + attach.getFileName());
					Files.delete(thumbnail);
				}
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		});
	}
}
