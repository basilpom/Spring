
/* Drop Tables */

DROP TABLE BOARD CASCADE CONSTRAINTS;
DROP TABLE ORDERDETAILS CASCADE CONSTRAINTS;
DROP TABLE GOODS CASCADE CONSTRAINTS;
DROP TABLE ORDERS CASCADE CONSTRAINTS;
DROP TABLE MEMBERS CASCADE CONSTRAINTS;




/* Create Tables */

CREATE TABLE BOARD
(
	-- 게시글번호
	BNO number NOT NULL,
	-- 회원 아이디
	ID varchar2(20) NOT NULL,
	-- 글제목
	TITLE varchar2(200) NOT NULL,
	CONTENT varchar2(1000) NOT NULL,
	PRIMARY KEY (BNO)
);


CREATE TABLE GOODS
(
	-- 상품번호
	-- 년월일+일련번호4자리의 조합
	CODE char(12) NOT NULL,
	-- 상품이름
	NAME varchar2(20) NOT NULL,
	-- 현재 시점의 상품 가격
	PRICE number NOT NULL,
	PRIMARY KEY (CODE)
);


CREATE TABLE MEMBERS
(
	-- 회원 아이디
	ID varchar2(20) NOT NULL,
	NAME varchar2(50) NOT NULL,
	-- 회원 비밀번호
	PASSWORD varchar2(20) NOT NULL,
	PRIMARY KEY (ID)
);


CREATE TABLE ORDERDETAILS
(
	-- 주문번호
	-- 년월일 8자리 + 카테고리번호 4자리 + 일련번호 8자리
	ONO char(20) NOT NULL,
	-- 상품번호
	-- 년월일+일련번호4자리의 조합
	CODE char(12) NOT NULL,
	PRIMARY KEY (ONO, CODE)
);


CREATE TABLE ORDERS
(
	-- 주문번호
	-- 년월일 8자리 + 카테고리번호 4자리 + 일련번호 8자리
	ONO char(20) NOT NULL,
	-- 회원 아이디
	ID varchar2(20) NOT NULL,
	PRIMARY KEY (ONO)
);



/* Create Foreign Keys */

ALTER TABLE ORDERDETAILS
	ADD FOREIGN KEY (CODE)
	REFERENCES GOODS (CODE)
;


ALTER TABLE BOARD
	ADD FOREIGN KEY (ID)
	REFERENCES MEMBERS (ID)
;


ALTER TABLE ORDERS
	ADD FOREIGN KEY (ID)
	REFERENCES MEMBERS (ID)
;


ALTER TABLE ORDERDETAILS
	ADD FOREIGN KEY (ONO)
	REFERENCES ORDERS (ONO)
;



/* Comments */

COMMENT ON COLUMN BOARD.BNO IS '게시글번호';
COMMENT ON COLUMN BOARD.ID IS '회원 아이디';
COMMENT ON COLUMN BOARD.TITLE IS '글제목';
COMMENT ON COLUMN GOODS.CODE IS '상품번호
년월일+일련번호4자리의 조합';
COMMENT ON COLUMN GOODS.NAME IS '상품이름';
COMMENT ON COLUMN GOODS.PRICE IS '현재 시점의 상품 가격';
COMMENT ON COLUMN MEMBERS.ID IS '회원 아이디';
COMMENT ON COLUMN MEMBERS.PASSWORD IS '회원 비밀번호';
COMMENT ON COLUMN ORDERDETAILS.ONO IS '주문번호
년월일 8자리 + 카테고리번호 4자리 + 일련번호 8자리';
COMMENT ON COLUMN ORDERDETAILS.CODE IS '상품번호
년월일+일련번호4자리의 조합';
COMMENT ON COLUMN ORDERS.ONO IS '주문번호
년월일 8자리 + 카테고리번호 4자리 + 일련번호 8자리';
COMMENT ON COLUMN ORDERS.ID IS '회원 아이디';



