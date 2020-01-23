package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
@AllArgsConstructor
public class ReplyPageDTO {
	private int replyCnt;
	private List<ReplyVO> list;
}
