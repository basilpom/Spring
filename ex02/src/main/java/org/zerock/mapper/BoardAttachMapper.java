package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public void insert(BoardAttachVO vo);
	public void delete(String uuid);
	public void deleteAll(Long bno);
	public List<BoardAttachVO> findByBno(Long bno);
	// 하루 전 등록된 파일 목록
	public List<BoardAttachVO> getOldFiles();
}
