package org.zerock.domain.Criteria;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	// for paging
	private int pageNum;
	private int amount;
	
	// for search
	private String type;
	private String keyword;
	
	public Criteria() {
		this(1, 10);	// 자신의 생성자 호출
	}
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public String[] getTypeArr() {
		return type == null ? new String[] {} : type.split("");
	}
}