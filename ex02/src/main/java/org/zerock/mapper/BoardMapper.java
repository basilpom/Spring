package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria.Criteria;

public interface BoardMapper {
	// total count
	public int getTotalCount(Criteria cri);
	// list with paging
	public List<BoardVO> getListWithPaging(Criteria cri);
	// BoardMapper.xml 에 작성해 준 select 문. 상속하여 class 만들  필요 없이 알아서  구현 해 줌
	public List<BoardVO> getList();
	// insert
	public void insert(BoardVO board);
	// sequence value 먼저 알아낸 후 insert
	public void insertSelectKey(BoardVO board);
	// 상세보기, 수정화면
	public BoardVO read(Long bno);
	// delete
	public int delete(Long bno);
	// update
	public int update(BoardVO board);
	// reply count
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}
