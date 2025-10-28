/*
  파일명 : 08_DDL(ALTER,DROP)_KH계정

  DDL(DATA DEFINITION LANGUAGE)
  데이터 정의 언어

  객체들을 생성(CREATE)하고 수정(ALTER)하고 삭제(DROP)하는 구문

  1.ALTER
  객체 구조를 수정하는 구문

  <테이블 수정>
  [표현법]
  ALTER TABLE 테이블명 수정할 내용

  -수정할 내용
  1)컬럼추가 / 수정 / 삭제
  2)제약조건 추가 / 삭제 - 수정불가 (수정하고 싶다면 삭제 후 새롭게 추가해야한다.)
  3)테이블명 / 컬럼명 / 제약조건명 수정

  1)컬럼 추가 수정 삭제
  --컬럼 추가 ADD : ADD 추가 컬럼명 자료형 DEFAULT 기본값(DEFAULT 생략가능)
*/

SELECT * FROM DEPT_COPY;

--CNAME 컬럼 추가

ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20) DEFAULT '한국'; -- 컬럼이 추가되며 설정된 DEFAULT로 추가됨.

ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20); -- 컬럼이 추가되며 NULL로 채워진다.

--DEPT_COPY 테이블의 DEPT_ID 컬럼 자료형을 CHAR(3)으로 변경해보기
--컬럼 변경(MODIFY)
--컬럼 자료형 수정 : MODIFY 수정할 컬럼명 바꿀자료형
--DEFAULT값 수정 : MODIFY 수정할 컬럼명 DEFAULT 바꿀값

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

--DEPT_COPY 테이블의 DEPT_ID컬럼 자료형을 NUMBER로 변경해보기
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; --바꿀 자료형과 다른 데이터가 이미 담겨있어서 변경 불가
--01439. 00000 -  "column to be modified must be empty to change datatype"

ALTER TABLE DEPT_COPY MODIFY LNAME NUMBER; --데이터가 비어있는 컬럼은 데이터 유형 변경 가능

ALTER TABLE DEPT_COPY MODIFY LNAME VARCHAR2(20); -- 다시 문자열 자료형으로

--DEPT_ID 컬럼 자료형 크기를 CHAR(1)로 변경해보기
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(1);
--ORA-01441: 일부 값이 너무 커서 열 길이를 줄일 수 없음
--담겨있는 데이터보다 작은 크기로 변경 불가

--한번에 여러개 변경해보기
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(50)
MODIFY LOCATION_ID VARCHAR2(10)
MODIFY LNAME DEFAULT '미국'; --DEFAULT 수정시 기존 데이터에는 영향을 주지 않음 (이후 추가될 기본값을 설정)수정할때 영향을 바로주지 않음. '미국'이 바로 들어가는건 아님.

INSERT INTO DEPT_COPY(DEPT_ID,DEPT_TITLE,LOCATION_ID)
VALUES ('D9','테스트부서','L5');

SELECT * FROM DEPT_COPY;

--컬럼 삭제 (DROP COLUMN) : DROP COLUMN 컬럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

--DEPT_COPY2 테이블의 컬럼 지우기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;

ROLLBACK; -- DDL구문은 ROLLBACK 불가

SELECT * FROM DEPT_COPY2;

--나머지 컬럼도 지우기
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
--ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다
--테이블에는 적어도 하나이상의 컬럼은 존재해야한다.

SELECT * FROM DEPT_COPY2;

--2) 제약조건 추가 / 삭제

/*

   -제약조건 추가

   -PRIMARY KEY : ADD PRIMARY KEY(컬럼명);
   -FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명(컬럼명) - 컬럼 생략가능 해당 테이블 PK
   -UNIQUE : ADD UNIQUE(컬럼명)
   -CHECK : ADD CHECK(컬럼조건)
   -NOT NULL : MODIFY 컬럼명 NOT NULL;

   제약조건명을 부여하고자 한다면
   CONSTRAINT 제약조건명을 앞에 부여하기
*/

--DEPT_COPY 테이블에
--DEPT_ID 컬럼에 PK 추가 DEPT_TITLE 컬럼에 UNIQUE 추가
--LNAME 컬럼에 NOT NULL 추가 (제약조건명 DCOPY_NN)으로

ALTER TABLE DEPT_COPY
ADD PRIMARY KEY(DEPT_ID)
ADD UNIQUE(DEPT_TITLE)
--MODIFY LNAME CONSTRAINT DCOPY_NN NOT NULL; -- 이미 해당 컬럼에 NULL값이 포함되어있기 때문에 불가능
MODIFY CNAME CONSTRAINT DCOPY_NN NOT NULL; -- PK로 설정할 컬럼에 중복데이터가 있으면 불가능

/*
  제약조건 삭제

  PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK : DROP CONSTRAINT 제약조건명
  NOT NULL : MODIFY 컬럼명 NULL;
*/

--DEPT_COPY 테이블에 있는 제약조건들 지워보기
--PK, NOT NULL, UNIQUE 제약조건명 확인 후 해당 제약조건을 지워보기
--EX) ALTER TABLE 테이블명 DROP~~

ALTER TABLE DEPT_COPY
DROP CONSTRAINT SYS_C008576
DROP CONSTRAINT SYS_C008577
MODIFY CNAME NULL;

--컬럼명, 제약조건명, 테이블명 변경(RENAME)

--컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
--DEPT_COPY에서 DEPT_TITLE 컬럼명을 DEPT_NAME으로 변경해보기
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

SELECT * FROM DEPT_COPY;

--제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
--DEPT_COPY 테이블에서
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C008481 TO DEPTID_NN;

--테이블명 변경 : 기존 테이블명 RENAME TO 바꿀테이블명
--DEPT_COPY 테이블을 DEPT_TEST로 변경
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

SELECT * FROM DEPT_COPY; -- 존재하지않음(이름바뀜)
SELECT * FROM DEPT_TEST; -- 조회 가능

---------------------------------------------------------------------------
/*
   DROP
   OBJECT 를 삭제하는 구문
   [표현법]
   DROP TABLE 테이블명;
*/

--삭제할 테이블 생성해서 테스트하기

CREATE TABLE DROPTABLE
AS SELECT * FROM DEPT_TEST;

SELECT * FROM DROPTABLE;

DROP TABLE DROPTABLE; --삭제

--부모테이블을 삭제하는 경우
--DEPT_TEST 테이블 DEPT_ID 컬럼에 PK 추가
ALTER TABLE DEPT_TEST ADD CONSTRAINT DTEST_PK PRIMARY KEY(DEPT_ID);

--EMPLOYEE_COPY2 테이블에 DEPT_CODE에 DEPT_TEST DEPT_ID 컬럼 참조 제약조건 추가하기
ALTER TABLE EMPLOYEE_COPY2
ADD CONSTRAINT ECOPY2_FK FOREIGN KEY(DEPT_CODE) REFERENCES DEPT_TEST;

--부모테이블 삭제해보기
DROP TABLE DEPT_TEST; --ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다

--참조되고 있는 자식테이블이 있기 때문에 삭제 불가

--삭제방법 2가지
--1. 자식테이블 지우고 부모테이블 지우기
--DROP TABLE 자식테이블;
--DROP TABLE 부모테이블;

--2.테이블을 삭제할때 제약조건까지 삭제하는 옵션 부여하기
--[표현법] DROP TABLE 부모테이블명 CASCADE CONSTRAINTS;
DROP TABLE DEPT_TEST CASCADE CONSTRAINTS;

SELECT * FROM DEPT_TEST;