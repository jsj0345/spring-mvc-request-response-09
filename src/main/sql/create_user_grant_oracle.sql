--한줄 주석

/*
  여러줄 주석

  실행 키는 ctrl + enter

  파일 저장은 왼쪽 상단에 파일 누르고 경로 찾아서 02_Oracle~에 저장.

  여러줄 주석

*/

-- ctrl + x 는 지워줌 (입력했던 것을 지워줌)

-- 관리자 계정(SYSTEM) : DB의 생성과 관리를 담당하는 계정으로 모든 권한과 책임을 가지는 계정

-- 사용자 계정 : DB에 대해서 질의,갱신,보고서 작성등의 작업을 수행할 수 있는 계정, 업무에 필요한 최소한의 권한만

--           가지는 것을 원칙으로 한다.

-- 계정 생성

-- 일반 사용자 계정을 만들 수 있는 권한은 관리자 계정에 있다.

-- 사용자 계정 생성 방법

-- [표현법] CREATE USER c##계정명 IDENTIFIED BY 비밀번호;

-- SELECT * FROM ALL_TABLES;

--C## 접두어 붙이지 않고 계정 생성하기 위한 설정
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; -- 오라클 내부 스크립트 실행 설정
--위 설정을 하면 사용자 계정에 c##을 붙이지 않아도 된다. FALSE 가 되어있으면 C## 필요.


CREATE USER KH IDENTIFIED BY KH; -- 계정 생성  명령문 실행 (재생버튼)눌러도 되고 CTRL + ENTER 눌러도 된다. (한줄 실행) , 사용자 계정 만들었으니 접속 해야한다.

GRANT CONNECT,RESOURCE TO KH; -- 권한 부여

--테이블 생성공간 부여 권한 TABLE SPACE (계정 만들어 있을때 수정 처리)
--용량 제한 권한 수정
--ALTER USER KH QUOTA 100M ON USERS;

--또는 무제한 사용 권한 부여
GRANT UNLIMITED TABLESPACE TO KH;


--계정을 생성한 뒤, 권한을 부여해야 접속을 할 수 있다.
--생성된 사용자 계정에 최소한의 권한 부여하기
--[권한부여 표현법] GRANT 권한1, 권한2, .... TO 계정명;
--부여할 권한 ROLE : CONNECT, RESOURCE

--CONNECT : 접속 권한 (CREATE SESSION) / RESOURCE -- 작업권한 CREATE, INSERT, UPDATE, DELETE 등등..

GRANT CONNECT,RESOURCE TO C##KH;

--계정 삭제 구문
--[표현법] DROP USER 계정명;

DROP USER C##KH; -- 접속 해제를 해야함! 코드가 꼽혀있는지를 보면된다! (그림을 보면됨)


--아래서부턴 내가 연습해보기(수업시간때 했던거 복습해보자)

-- TABLESPACE는 데이터를 실제로 저장하는 물리적인 공간임.

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

CREATE USER KH2 IDENTIFIED BY KH2; --

GRANT CONNECT,RESOURCE TO KH2; --권한 부여 (접속할때 필요한 권한 부여 CONNECT, 작업권한 -- RESOURCE)

--또는 무제한 사용 권한 부여
GRANT UNLIMITED TABLESPACE TO KH2;

--계정을 생성한 뒤, 권한을 부여해야 접속할 수 있다.
--생성된 사용자 계정에 최소한의 권한 부여하기
--[권한부여 표현법] GRANT 권한1, 권한2, ... TO 계정명;
--부여할 권한 ROLE : CONNECT, RESOURCE

-- CONNECT : 접속 권한 (CREATE SESSION) / RESOURCE -- 작원권한 CREATE, INSERT, UPDATE, DELETE 등등..

-- 아예 삭제를 해보자

--DROP USER KH2 CASCADE;