package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Override
	@Transactional
	public void register(BoardVO board) {
		log.info("!!! REGISTER !!!" + board);
		mapper.insertSelectKey(board);
		
		// 첨부파일
		if(board.getAttachList() == null || board.getAttachList().size() <= 0)
		{
			return;
		}
		board.getAttachList().forEach(attach -> {
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("!!!!! GET !!!!!" + bno);
		
		return mapper.read(bno);
	}

	@Override
	@Transactional
	public boolean modify(BoardVO board) {
		log.info("!!!!! MODIFY !!!!!" + board);
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0)
		{
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
	}

	@Override
	@Transactional
	public boolean remove(Long bno) {
		log.info("!!!!! REMOVE !!!!!" + bno);
		
		attachMapper.deleteAll(bno);
		return mapper.delete(bno) == 1;
	}

//	@Override
//	public List<BoardVO> getList() {
//		log.info("!!!!! GET LIST !!!!!");
//		
//		return mapper.getList();
//	}

	@Override
	public List<BoardVO> getListWithPaging(Criteria cri) {
		log.info("!!! GET LIST WITH CRITERIA !!!"+ cri);
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		log.info("!!! GET TOTAL COUNT !!!");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("!!! GET ATTACH LIST BY BNO !!!" + bno);
		return attachMapper.findByBno(bno);
	}

}
