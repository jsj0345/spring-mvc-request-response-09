/*
   파일명 : 06_DDL_CREATE(DDL 계정)

   DDL(DATA DEFINITION LANGUAGE)
   데이터 정의 언어

   객체들을 새롭게 생성(CREATE) 하고 수정(ALTER)하고 삭제(DROP)하는 구문들

   1. CREATE 객체 생성 구문
   2. ALTER 객체 수정 구문
   3. DROP 객체 삭제 구문

   -테이블 생성구문
   *테이블 : 행(ROW), 열(COLUMN)으로 구성되는 가장 기본적인 데이터베이스 객체 종류중 하나로
            모든 데이터는 테이블을 통해서 저장된다(데이터를 조작하고자 하려면
            테이블을 생성하고 데이터를 넣어야한다.)

    [표현법]
    CREATE TABLE 테이블명 (
       컬럼명 자료형,
       컬럼명 자료형,
       ...
    );

    <자료형>
    -문자 CHAR(크기) / VARCHAR2(크기)
    : 크기는 BYTE 단위 이며 숫자,영문,특수문자는 한글자당 1BYTE 한글은 3BYTE를 차지한다.
    -CHAR : 고정길이(크기만큼 데이터가 들어오지 않으면 남는 자리를 공백으로 채운다)
    -VARCHAR2 : 가변길이 (크기보다 적은 데이터가 들어와도 그 값에 맞춰 크기를 유지한다)

    NUMBER : 정수 / 실수 상관 없이 NUMBER로 표기
    DATE : 날짜 데이터를 담는 자료형 (년/월/일/시/분/초) 형식으로 저장
*/

--회원들의 정보를 담을 테이블 생성해보기(아이디 비밀번호 이름 생년월일)
CREATE TABLE MEMBER(
   MEMBER_ID VARCHAR2(20),
   member_pwd varchar2(20), -- 대소문자 구분하지 않음
   MEMBER_NAME VARCHAR2(20),
   MEMBER_DATE DATE
);

-- DROP TABLE MEMBER; -- 테이블 삭제 구문

--테이블 확인
SELECT *
FROM MEMBER;

--데이터 딕셔너리 이용하여 테이블 확인
--데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
SELECT *
FROM USER_TABLES;

--컬럼 확인
SELECT *
FROM USER_TAB_COLUMNS; -- 현재 사용자가 가지고 있는 테이블의 모든 컬럼 조회

--COMMENTS 적어두기
--컬럼에 대한 설명을 달아둘 수 있다.
--[표현법] COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '생년월일';

--DML : INSERT 사용하여 데이터 추가해보기
--한 행으로 데이터 추가 구문
--[표현법] INSERT INTO 테이블명 VALUES(값, 값, ...) : 값의 순서가 중요하다.(테이블 컬럼 정의 순서와 맞추기)
INSERT INTO MEMBER VALUES('user01', 'pass01', '김유저', '000101');
INSERT INTO MEMBER VALUES('user02', 'qwe123', '김유저', '991001');

SELECT *
FROM MEMBER;

INSERT INTO MEMBER VALUES('user01', 'zxc123', '최유저', '880101'); -- 아이디 중복 데이터
--아이디 중복 데이터를 허용하지 않기 위해서는 제약조건을 부여해야한다.

SELECT *
FROM MEMBER;

INSERT INTO MEMBER VALUES(NULL, NULL, '김유저', '000101'); -- 아이디 비밀번호에 NULL이 허용되고있음.

SELECT * FROM MEMBER;

/*
   <제약조건 CONSTRAINT>
   -원하는 데이터만 유지하기 위해(보관하기 위해) 특정 컬럼마다 설정하는 제약
   -제약 조건이 부여된 컬럼에 들어올 데이터에 문제가 없는지 검사해준다.
   -종류 : NOT NULL/ UNIQUE / CHECK / PRIMARY KEY / FOREIGN KEY

   컬럼에 제약조건을 부여하는 방식 : 컬럼 레벨 방식 / 테이블 레벨 방식

   1.NOT NULL 제약조건
   해당 컬럼에는 반드시 값이 존재해야하는 경우 사용
   -NULL값이 들어와서는 안되는 컬럼이 있다면 NOT NULL 제약조건을 부여한다.
   -삽입 / 수정시 NULL값을 허용하지 않게 됨
   -부여 방식 : 컬럼 레벨 방식

*/

CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL, --컬럼 레벨 방식(컬럼명 자료형 제약조건)
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30)
);

--데이터 삽입하기
INSERT INTO MEM_NOTNULL VALUES(1,'user01','pass01','김유저','남','01033332222','user01@gmail.com');

--조회해보기
SELECT * FROM MEM_NOTNULL;

--NOT NULL 제약조건이 부여된 컬럼에 NULL값 넣어보기
INSERT INTO MEM_NOTNULL VALUES(2,'user02','pass03','박유저',NULL,'01033332222','user01@gmail.com');

--NOT NULL 제약조건이 부여되지 않은 컬럼에 NULL 넣어보기
INSERT INTO MEM_NOTNULL VALUES(3,'user03','pass04','최유저',NULL,NULL,NULL);

SELECT * FROM MEM_NOTNULL;

/*
   2. UNIQUE 제약 조건
   컬럼에 중복값을 제한하는 제약조건
   삽입 / 수정시 기존에 중복값이 존재할 경우
   추가 또는 수정이 되지 않도록 제약한다.

   부여방식 : 컬럼 레벨방식 / 테이블 레벨 방식
*/

CREATE TABLE MEM_UNIQUE(
   MEM_NO NUMBER NOT NULL UNIQUE, -- 컬럼 하나에 여러개의 제약조건 부여 가능
   MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼 옆에 작성하는 방식(컬럼레벨방식)
   MEM_PWD VARCHAR2(20) NOT NULL,
   MEM_NAME VARCHAR2(20) NOT NULL,
   GENDER CHAR(3),
   PHONE VARCHAR2(15),
   EMAIL VARCHAR2(30)
);

SELECT *
FROM MEM_UNIQUE;

--데이터 삽입
INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','김유저','남','01022223333','asd@gmail.com');

--UNIQUE 제약 조건 위배해보기
INSERT INTO MEM_UNIQUE VALUES(1,'user02','pass02','유유저','여','01022223333','asd@gmail.com');
INSERT INTO MEM_UNIQUE VALUES(2,'user01','pass02','유유저','여','01022223333','asd@gmail.com');
--UNIQUE 제약조건이 부여된 컬럼에 중복 데이터가 들어갈 수 없음.

--테이블 삭제
DROP TABLE MEM_UNIQUE;

--제약조건 테이블 레벨 방식으로 부여해보기
CREATE TABLE MEM_UNIQUE(
   MEM_NO NUMBER NOT NULL, -- 컬럼 하나에 여러개의 제약조건 부여 가능
   MEM_ID VARCHAR2(20) NOT NULL, -- 컬럼 옆에 작성하는 방식(컬럼레벨방식)
   MEM_PWD VARCHAR2(20) NOT NULL,
   MEM_NAME VARCHAR2(20) NOT NULL,
   GENDER CHAR(3),
   PHONE VARCHAR2(15),
   EMAIL VARCHAR2(30),
   UNIQUE(MEM_NO), -- 테이블 레벨방식
   UNIQUE(MEM_ID)
);

SELECT * FROM MEM_UNIQUE;

--데이터 삽입
INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','김유저','남','01022223333','asd@gmail.com');

--UNIQUE 제약 조건 위배해보기
INSERT INTO MEM_UNIQUE VALUES(1,'user02','pass02','유유저','여','01022223333','asd@gmail.com');
INSERT INTO MEM_UNIQUE VALUES(2,'user01','pass02','유유저','여','01022223333','asd@gmail.com');
--ORA-00001 : 무결성 제약 조건(DDL.SYS_C008413)에 위배됩니다.
--SYS_C008413 : 해당 제약조건의 이름
--제약조건명은 별도로 작성하지 않으면 시스템이 SYS_C~~~로 임의 이름을 부여한다.
--제약조건명은 중복될 수 없다.

/*
   제약조건 명 부여 방법
   -컬럼 레벨 방식

   CREATE TABLE 테이블명(
      컬럼명 자료형 CONSTRAINT 제약조건명 제약조건
      ...
   );

   -테이블 레벨 방식
   CREATE TABLE 테이블명 (
     컬럼명 자료형,
     ...
     CONSTRAINT 제약조건명 제약조건(컬럼)
   );
*/

CREATE TABLE MEM_CON_NN(
     MEM_NO NUMBER NOT NULL,
     MEM_ID VARCHAR2(20) CONSTRAINT MEM_ID_NN NOT NULL, -- 컬럼 레벨 방식
     MEM_PWD VARCHAR2(20) NOT NULL,
     MEM_NAME VARCHAR2(20) NOT NULL,
     GENDER CHAR(3),
     PHONE VARCHAR2(15),
     EMAIL VARCHAR2(30),

     CONSTRAINT MEM_NO_UQ UNIQUE(MEM_NO) --테이블 레벨 방식

);

--데이터 삽입
INSERT INTO MEM_CON_NN VALUES(1,'user01','pass01','김유저','남','01022223333','asd@gmail.com');

--UNIQUE 제약 조건 위배해보기
INSERT INTO MEM_CON_NN VALUES(1,'user02','pass02','유유저','여','01022223333','asd@gmail.com');
INSERT INTO MEM_CON_NN VALUES(2,NULL,'pass02','유유저','여','01022223333','asd@gmail.com');

/*
   3. CHECK 제약 조건
   특정 컬럼에 특정 값만 들어갈 수 있도록 제약하는 제약 조건
   EX) 성별에 남 / 여만 들어갈 수 있도록

   [표현법]
   CHECK(조건)

*/

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')), -- 남 또는 여 만 들어갈수 있도록 체크 제약조건 부여
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE
);

--데이터 삽입
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','남','01022223333','asd@gmail.com',SYSDATE);

SELECT *
FROM MEM_CHECK;

--CHECK 제약 조건 위배해보기
INSERT INTO MEM_CHECK VALUES(2,'user01','pass01','김유저','하','01022223333','asd@gmail.com',SYSDATE);
--체크 제약조건(DDL.SYS_C008393)이 위배되었습니다

INSERT INTO MEM_CHECK VALUES(2,'user01','pass01','김유저',NULL,'01022223333','asd@gmail.com',SYSDATE);

-- NOT NULL 제약조건이 부여되지 않았기 때문에 NULL도 허용

SELECT * FROM MEM_CHECK;

/*
  DEFAULT 설정
  특정 컬럼에 데이터가 들어갈때 기본적으로 들어가는 기본값이 있다면
  해당 값을 기본으로 설정 가능
  -제약조건이 아님
  EX) 퇴사여부 N / 입사일 SYSDATE / 휴학여부 Y/N,,,

*/

DROP TABLE MEM_CHECK; -- 테이블 삭제

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(15),
    EMAIL VARCHAR2(30),
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL, -- 기본값 SYSDATE로 설정 제약조건은 DEFAULT 뒤에 설정하기
    CONSTRAINT CK_GEN CHECK (GENDER IN('남','여')) --체크제약조건 테이블 레벨 방식
);

SELECT * FROM MEM_CHECK;
--데이터 삽입
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','남','01022223333','asd@gmail.com',SYSDATE);
INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','김유저','하','01022223333','asd@gmail.com',SYSDATE);
INSERT INTO MEM_CHECK VALUES(2,'user02','pass02','박유저','여','01022223333','asd@gmail.com',DEFAULT);

/*
   INSERT 구문에서 컬럼명을 나열해주면 나열되지 않은 컬럼에 대해서는 기본값이 삽입된다.
   [표현법]
   INSERT INTO 테이블명(컬럼,컬럼2,컬럼3,...) VALUES (값, 값2,값3,...);
   테이블명 뒤에 컬럼을 나열하는데 이때 나열되지 않은 컬럼에는 기본값인 NULL이 들어가고
   만약 DEFAULT가 설정되어 있는 컬럼이라면 DEFAULT에 설정한 값이 들어간다.

   **NOT NULL 제약 조건이 걸려있는 컬럼은 컬럼 나열에 꼭 포함시키거나 DEFAULT 설정이 되어있어야한다.

*/

INSERT INTO MEM_CHECK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(3,'qwe123','asd123','최유저');

--컬럼 나열하지 않은 데이터에는 기본값(NULL)이 들어간다 만약 DEFAULT 설정을 하면 해당 값이 들어간다.

SELECT *
FROM MEM_CHECK;


/*
   4.PRIMARY KEY 기본키 제약조건
   테이블에서 각행들의 정보를 유일하게 식별할 수 있는 컬럼에 부여하는 제약조건
   -각 행들을 구분할 수 있는 식별자의 역할
   EX)사번, 부서코드, 직급코드, ...
   --NOT NULL 제약조건과 UNIQUE 제약조건이 걸려있다.

   **한 테이블에는 하나만 지정 가능 (고유 식별자의 역할)
*/

CREATE TABLE MEM_PK (
  MEM_NO NUMBER CONSTRAINT MEM_NO_PK PRIMARY KEY, -- MEM_NO를 식별자로 지정 (PK)
  MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
  MEM_PWD VARCHAR2(20) NOT NULL,
  MEM_NAME VARCHAR2(20) NOT NULL,
  GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
  PHONE VARCHAR2(15),
  EMAIL VARCHAR2(30),
  HIRE_DATE DATE DEFAULT SYSDATE
);

--데이터 삽입
--NOT NULL 제약조건이 있는 컬럼을 나열방식에 작성하지 않으면 NOT NULL제약조건 위배(DEFAULT가 없는 경우)
INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(1,'qwe123','asd123','최유저'); --기본값인 NULL이 들어갈라해서 오류가 생김.
INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GENDER) VALUES(1,'qwe123','asd123','최유저','남');

SELECT *
FROM MEM_PK;
--PK에 UNIQUE 제약조건 확인 (무결성 제약 조건(DDL.MEM_NO_PK)에 위배됩니다)
INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GENDER) VALUES(1,'ASD123','ZXC123','박유저','여');

--PK에 NOT NULL 제약조건 확인
INSERT INTO MEM_PK(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GENDER) VALUES(NULL,'ASD123','ZXC123','박유저','여');
--PRIMARY KEY는 UNIQUE, NOT NULL 제약조건을 포함하고 있다.

--한 테이블에 기본키(PK)를 여러개 설정 가능한지 확인해보기
CREATE TABLE MEM_PK2 (
  MEM_NO NUMBER CONSTRAINT MEM_NO_PK PRIMARY KEY, -- MEM_NO를 식별자로 지정 (PK)
  MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
  MEM_PWD VARCHAR2(20) NOT NULL,
  MEM_NAME VARCHAR2(20) NOT NULL,
  GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
  PHONE VARCHAR2(15),
  EMAIL VARCHAR2(30),
  HIRE_DATE DATE DEFAULT SYSDATE,
  CONSTRAINT MEM_ID_PK PRIMARY KEY(MEM_ID) -- 테이블 레벨방식
);  -- 테이블에는 하나의 기본 키만 가질 수 있습니다.

--두개의 컬럼을 하나의 PK로 묶어서 만들기 (복합키)
CREATE TABLE MEM_PK2 (
  MEM_NO NUMBER,  -- MEM_NO를 식별자로 지정 (PK)
  MEM_ID VARCHAR2(20) NOT NULL,
  MEM_PWD VARCHAR2(20) NOT NULL,
  MEM_NAME VARCHAR2(20) NOT NULL,
  GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
  PHONE VARCHAR2(15),
  EMAIL VARCHAR2(30),
  HIRE_DATE DATE DEFAULT SYSDATE,
  CONSTRAINT MEM_NOID_PK PRIMARY KEY(MEM_NO,MEM_ID) --복합키 테이블 레벨방식만 사용 가능
);

--위와같이 복합키를 설정하면 해당 컬럼들 모두 같은 값이여야 중복이라고 판단한다. (두개를 묶어서 봤을때 똑같으면 중복이라고 판단)

SELECT * FROM MEM_PK2;

DROP TABLE MEM_PK2;

--데이터 삽입
INSERT INTO MEM_PK2(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(1,'ASD123','ZXC123','박유저');
INSERT INTO MEM_PK2(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(2,'ASD123','ZXC123','박유저');
INSERT INTO MEM_PK2(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(1,'user01','ZXC123','박유저');
INSERT INTO MEM_PK2(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(1,'user01','ZXC123','박유저');

--복합키는 두 데이터가 모두 같은 경우 데이터 삽입을 막기 위해 사용된다.
--ex) 좋아요, 찜하기

/*
   5. FOREIGN KEY (외래 키)
   해당 컬럼에 다른 테이블에 존재하는 값만 허용하도록 컬럼에 부여하는 제약조건
   -다른 테이블을 참조한다.
   참조된 다른 테이블이 가지고 있는 값만 허용
   JOIN 구문에서 활용하기 좋은 컬럼

   [표현법]
   -컬럼레벨 방식
   컬럼명 자료형 CONSTRAINT 제약조건명 REFERENCES 참조테이블명(참조컬럼명)

   -테이블레벨 방식
   CONSTRAINT 제약조건명 FOREIGN KEY(컬럼명) REFERENCES 참조테이블명(참조컬럼명)
   -생략 가능한 것 : CONSTRAINT / 참조컬럼명 (생략시 참조테이블에 기본키(PK)로 설정

   주의 : 참조할 컬럼타입과 외래키로 지정할 컬럼 타입이 같아야한다.
*/

--회원 등급에 대한 데이터(등급코드, 등급명) 보관 테이블
--참조 테이블(부모)
CREATE TABLE MEM_GRADE(
  GRADE_CODE CHAR(2) PRIMARY KEY, --등급코드
  GRADE_NAME VARCHAR(20) NOT NULL --등급명
);

--등급 테이블에 데이터 삽입
INSERT INTO MEM_GRADE VALUES('G1','일반회원');
INSERT INTO MEM_GRADE VALUES('G2','우수회원');
INSERT INTO MEM_GRADE VALUES('G3','특별회원');

SELECT *
FROM MEM_GRADE;

--자식 테이블
CREATE TABLE MEM(
   MEM_NO NUMBER PRIMARY KEY, -- 기본키
   MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- NULL 허용하지 않고 중복허용하지않음
   MEM_PWD VARCHAR2(20) NOT NULL,
   MEM_NAME VARCHAR2(20) NOT NULL,
   GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
   GRADE_ID CHAR(2),
   PHONE VARCHAR2(15),
   EMAIL VARCHAR2(30),
   HIRE_DATE DATE DEFAULT SYSDATE
);

SELECT * FROM MEM;
--데이터 삽입
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(1,'ASD123','ZXC123','박유저');

--외래키가 걸려있지 않아 GRADE_ID 컬럼에 데이터가 전부 허용된다.
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(2,'ASDASD','ADASD','김유저','Q1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(3,'ZXCZXC','ZXC123','최유저','T9');

DROP TABLE MEM; -- 삭제

--외래 키 작업 후 생성
CREATE TABLE MEM(
   MEM_NO NUMBER PRIMARY KEY, -- 기본키
   MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- NULL 허용하지 않고 중복허용하지않음
   MEM_PWD VARCHAR2(20) NOT NULL,
   MEM_NAME VARCHAR2(20) NOT NULL,
   GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
   GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE), --컬럼레벨방식 MEM_GRADE 테이블의 GRADE_CODE 컬럼 참조
   PHONE VARCHAR2(15),
   EMAIL VARCHAR2(30),
   HIRE_DATE DATE DEFAULT SYSDATE
);

--데이터 삽입
--GRADE_ID에 NOT NULL 제약조건이 없어 NULL은 허용됨.
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME) VALUES(1,'ASD123','ZXC123','박유저');

SELECT *
FROM MEM;

SELECT *
FROM MEM_GRADE;

--외래키가 걸려있지 않아 GRADE_ID 컬럼에 데이터가 전부 허용된다.
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(2,'ASDASD','ADASD','김유저','Q1');
--무결성 제약조건(DDL.SYS_C008439)이 위배되었습니다- 부모 키가 없습니다

--참조테이블에 있는 데이터로 넣기
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(2,'ASDASD','ADASD','김유저','G1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(3,'ZXCZXC','ZXC123','최유저','G3');

--외래키는 설정된 컬럼은 조인 구문 활용 가능
SELECT MEM_ID
       ,MEM_NAME
       ,GRADE_NAME
FROM MEM
LEFT JOIN MEM_GRADE ON (GRADE_ID = GRADE_CODE);

--참조하고 있는 부모테이블이 삭제되거나 참조하는 컬럼데이터가 삭제될 경우?
--데이터행 삭제 구문 : DML - DELETE
--[표현법] DELETE FROM 테이블명 조건; -- 만약 조건을 작성하지 않으면 해당 테이블 모든 데이터 행이 삭제됨.

--ORA-02292: 무결성 제약조건(DDL.SYS_C008439)이 위배되었습니다- 자식 레코드가 발견되었습니다
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';

--참조되고 있는 데이터가 있다면 삭제되지 않고 오류 발생 (삭제시 어떻게 처리할것인지 설정해야함)
SELECT * FROM MEM;

/*
   자식 테이블 생성시(외래키 제약조건 부여시)
   부모테이블의 데이터가 삭제되었을때 자식테이블에는 어떻게 처리할 것인지 옵션으로 지정

   FOREIGN KEY 삭제 옵션
   -ON DELETE SET NULL : 부모 데이터를 삭제할 때 해당 데이터를 참조하는 자식 데이터를 NULL로 변경
   -ON DELETE CASCADE : 부모 데이터를 삭제할 때 해당 데이터를 참조하는 자식 데이터를 같이 삭제
   -ON DELETE RESTRICTED : 삭제 제한걸기 (기본값)

*/

DROP TABLE MEM;

--1) ON DELETE SET NULL 옵션 확인
CREATE TABLE MEM(
   MEM_NO NUMBER PRIMARY KEY, -- 기본키
   MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- NULL 허용하지 않고 중복허용하지않음
   MEM_PWD VARCHAR2(20) NOT NULL,
   MEM_NAME VARCHAR2(20) NOT NULL,
   GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
   GRADE_ID CHAR(2) REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL, --컬럼레벨방식 MEM_GRADE 테이블의 GRADE_CODE 컬럼 참조
   PHONE VARCHAR2(15),
   EMAIL VARCHAR2(30),
   HIRE_DATE DATE DEFAULT SYSDATE
);

--데이터 삽입
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(1,'ZQWDD','CDQDQ','김유저','G1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(2,'ASDASD','ADASD','이유저','G2');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(3,'ZXCZXC','ZXC123','최유저','G3');

SELECT * FROM MEM_GRADE;

--부모테이블에서 G3 데이터 삭제해보기
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G3';

--2) ON DELETE CASCADE -- 부모 데이터 삭제시 자식데이터 삭제
DROP TABLE MEM; -- 자식 테이블 다시 삭제
--부모 데이터 삭제한거 다시 넣기
INSERT INTO MEM_GRADE VALUES('G3','특별회원');

CREATE TABLE MEM(
   MEM_NO NUMBER PRIMARY KEY, -- 기본키
   MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- NULL 허용하지 않고 중복허용하지않음
   MEM_PWD VARCHAR2(20) NOT NULL,
   MEM_NAME VARCHAR2(20) NOT NULL,
   GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
   GRADE_ID CHAR(2), --컬럼레벨방식 MEM_GRADE 테이블의 GRADE_CODE 컬럼 참조
   PHONE VARCHAR2(15),
   EMAIL VARCHAR2(30),
   HIRE_DATE DATE DEFAULT SYSDATE,
   --테이블 레벨 방식으로 작성
   FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE ON DELETE CASCADE -- 참조컬럼 생각 (PK로 잡힘)
);

--데이터 삽입
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(1,'ZQWDD','CDQDQ','김유저','G1');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(2,'ASDASD','ADASD','이유저','G2');
INSERT INTO MEM(MEM_NO,MEM_ID,MEM_PWD,MEM_NAME,GRADE_ID) VALUES(3,'ZXCZXC','ZXC123','최유저','G3');

SELECT * FROM MEM;

--부모 데이터 지워보기
DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 'G1';
--ON DELETE CASCADE 옵션을 부여했기 때문에 해당 부모데이터를 참조하던 자식 데이터행 자체가 삭제된다.

--------------------------------------------------------------

--KH 계정에서 진행
/*

   서브 쿼리를 이용하여 테이블을 생성해보기 (테이블 복사)
   메인 SQL문 SELECT, CREATE, INSERT, UPDATE를 보조하는 구문 (서브쿼리)

   [표현법]
   CREATE TABLE 테이블명
   AS 서브쿼리;


*/

--EMPLOYEE 테이블 조회
SELECT *
FROM EMPLOYEE;

--EMPLOYEE 테이블에 담긴 데이터 그대로 복사 테이블 만들어보기
CREATE TABLE EMPLOYEE_COPY
AS (SELECT * FROM EMPLOYEE);

SELECT *
FROM EMPLOYEE_COPY;
--컬럼 형식, 데이터 복사완료
--NOT NULL제약조건은 복사됨
--나머지 제약조건과 COMMENT, DEFAULT 들은 복사되지 않음.
--만약 테이블 컬럼 구조만 복사하고 싶고 데이터는 복사하고 싶지 않다면
--컬럼 형식만 조회될 수 있도록 처리

SELECT *
FROM EMPLOYEE
WHERE EMP_ID = 1000;

--위 조건으로 컬럼구조만 복사한 테이블 만들기
CREATE TABLE EMPLOYEE_COPY2
AS (SELECT *
    FROM EMPLOYEE
    WHERE EMP_ID = 1000
    );

SELECT *
FROM EMPLOYEE_COPY2; -- 테이블 형식만 복사됨

DROP TABLE EMPLOYEE_COPY2;

--위와같이 컬럼에 거는 조건이 아닌 항상 FALSE가 나올 수 있는 조건을 활용한다.

SELECT *
FROM EMPLOYEE
WHERE 1=1;

CREATE TABLE EMPLOYEE_COPY2
AS (SELECT *
    FROM EMPLOYEE
    WHERE 1=0);

SELECT *
FROM EMPLOYEE_COPY2;

--전체사원의 사번, 사원명, 급여, 연봉 조회 결과를 이용하여 테이블을 복사해보기
--EMPLOYEE_COPY3 이라는 테이블명으로 데이터까지 복사하기.

CREATE TABLE EMPLOYEE_COPY3
AS (SELECT EMP_ID
           ,EMP_NAME
           ,SALARY
           ,SALARY * 12 "연봉"
     FROM EMPLOYEE);

-- 서브쿼리식에 산술연산식 또는 함수식이 기술된 경우 해당 컬럼은 반드시 별칭을 부여해야한다.

SELECT *
FROM EMPLOYEE_COPY3;