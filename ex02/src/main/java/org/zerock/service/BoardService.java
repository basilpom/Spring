package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria.Criteria;

public interface BoardService {
	// 원래는 Business Logic 이 오는 곳
	
	// total count
	public int getTotal(Criteria cri);
	// insert
	public void register(BoardVO board);
	// select one. 상세보기, 수정화면
	public BoardVO get(Long bno);
	// update
	public boolean modify(BoardVO board);
	// delete
	public boolean remove(Long bno);
	// select list
	// public List<BoardVO> getList();
	// select list with paging
	public List<BoardVO> getListWithPaging(Criteria cri);
	// attachment file
	public List<BoardAttachVO> getAttachList(Long bno);
}
