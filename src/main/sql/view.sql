/*
    -파일명 : 11_OBJECT(VIEW)_KH계정 (VIEW는 자주 사용함)

    OBJECT : 데이터베이스를 이루는 논리적인 구조물들

    OBJECT의 종류
    -TABLE,VIEW,USER,SEQUENCE,TRIGGER,FUNCTION,...


    <VIEW>
    SELECT구문을 저장할 수 있는 OBJECT
    자주 사용되는 SELECT 구문을 VIEW에 저장하면 매번 구문을 작성할 필요 없다.
    -조회용 임시 테이블(실제 데이터가 담기는것이 아닌 조회 구문을 담는 객체이다)
*/

--한국에서 근무하는 사원들의 사번,이름,부서명,급여,근무국가명,직급명을 조회해보세요
SELECT EMP_ID
      ,EMP_NAME
      ,DEPT_TITLE
      ,SALARY
      ,NATIONAL_NAME
      ,JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
LEFT JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
LEFT JOIN NATIONAL USING(NATIONAL_CODE)
WHERE NATIONAL_NAME = '한국';

--위와같이 긴 쿼리 구문을 뷰로 만들어서 편하게 사용하기

/*
    VIEW 생성법
    [표현법]

    CREATE VIEW 뷰명
    AS 서브쿼리

    또는

    CREATE OR REPLACE VIEW 뷰명
    AS 서브쿼리

    **CREATE OR REPLACE 옵션
     -뷰 생성시 기존 뷰가 존재한다면 갱신
      기존 뷰가 없다면 생성해주는 구문 (생략가능)
*/

CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID
          ,EMP_NAME
          ,DEPT_TITLE
          ,SALARY
          ,NATIONAL_NAME
          ,JOB_NAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    LEFT JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
    LEFT JOIN NATIONAL USING(NATIONAL_CODE);
--ORA-01031: 권한이 불충분합니다

--시스템 계정에서 CREATE VIEW 권한 부여하기
GRANT CREATE VIEW TO KH;--시스템 계정에서 실행

--권한 부여 후 다시 KH 계정으로 VIEW 생성시켜보기
CREATE VIEW VW_EMPLOYEE
AS SELECT EMP_ID
          ,EMP_NAME
          ,DEPT_TITLE
          ,SALARY
          ,NATIONAL_NAME
          ,JOB_NAME
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    LEFT JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
    LEFT JOIN NATIONAL USING(NATIONAL_CODE);

SELECT * FROM VW_EMPLOYEE;

--한국에서 근무하는 사원들만 조회
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '한국';
--일본에서 근무하는 사원들만 조회
SELECT *
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME = '일본';
--러시아에 근무하는 사원들의 사번 이름 직급명 보너스까지 조회(갱신필요)
SELECT EMP_ID
      ,EMP_NAME
      ,JOB_NAME
      ,BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='러시아'; --BONUS 컬럼은 VIEW를 만들때 추가하지 않았기 때문에 오류발생

SELECT *
FROM VW_EMPLOYEE;

--VIEW에 보너스 컬럼 추가 후 갱신하기 (CREATE OR REPLACE 옵션 추가)
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID
          ,EMP_NAME
          ,DEPT_TITLE
          ,SALARY
          ,NATIONAL_NAME
          ,JOB_NAME
          ,BONUS
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    LEFT JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
    LEFT JOIN NATIONAL USING(NATIONAL_CODE)
    ORDER BY 1;

--갱신이 되었는지 확인 (BONUS컬럼 조회)
SELECT EMP_ID
      ,EMP_NAME
      ,JOB_NAME
      ,BONUS
FROM VW_EMPLOYEE
WHERE NATIONAL_NAME='러시아';

--VIEW 정보 조회(TEXT컬럼에 해당 VIEW를 생성할 때 사용한 SELECT 구문이 담겨있음)
--VIEW는 논리적인 가상테이블로 실제 데이터를 가지고 있는것이 아니고
--TEXT컬럼에 담겨진 SELECT구문을 수행하여 보여주는 형태이다.
SELECT *
FROM USER_VIEWS;

/*
    뷰 컬럼에 별칭 부여해보기
    서브쿼리 구문중 SELECT절에 함수나 연산식이 기술되어있는 경우 반드시 별칭 지정
*/
--사원의 사번,이름,직급명,성별,근무년수를 조회할 수 있는 SELECT 문으로 VIEW 만들어보기
SELECT EMP_ID
      ,EMP_NAME
      ,JOB_NAME
      ,DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여')
      ,EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

--위 구문으로 VIEW 생성하기
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID
          ,EMP_NAME
          ,JOB_NAME
          ,DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여')
          ,EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE);

--VIEW컬럼에 별칭 부여하기
CREATE OR REPLACE VIEW VW_EMP_JOB
AS SELECT EMP_ID
          ,EMP_NAME 사원명
          ,JOB_NAME 직급명
          ,DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여') 성별
          ,EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 근무년수
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE);

--조회
SELECT * FROM VW_EMP_JOB;

--별칭 부여 방법 2
--뷰이름 옆에 ()로 별칭 나열하기 (단,모든 컬럼에 대한 별칭을 부여해야한다.)
CREATE OR REPLACE VIEW VW_EMP_JOB(사번,사원명,직급명,성별,근무년수)
AS SELECT EMP_ID
          ,EMP_NAME
          ,JOB_NAME
          ,DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여')
          ,EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE);

SELECT * FROM VW_EMP_JOB;

--생성된 별칭 지정해서 조건처리
SELECT 사번
      ,사원명
      ,직급명
      ,성별
      ,근무년수
FROM VW_EMP_JOB
WHERE 성별 = '남';

--DROP : 뷰 삭제
DROP VIEW VW_EMP_JOB;

--VIEW에 DML 처리해보기
--VIEW는 데이터를 실제로 가지고 있는게 아니고 기반테이블의 데이터를 조회하여 보여주는 역할이기 때문에
--DML구문을 수행한다면 해당 VIEW가 기반으로 가지는 테이블에 DML이 수행된다.

CREATE VIEW VW_JOB
AS SELECT * FROM JOB;

SELECT * FROM JOB;
SELECT * FROM VW_JOB;

INSERT INTO VW_JOB VALUES('J8','인턴');

SELECT * FROM JOB; -- VIEW에 INSERT를 했지만 VIEW를 구성하는 원본(기반) 테이블에 적용되어있음
SELECT * FROM VW_JOB; -- 인턴정보 확인

--UPDATE 해보기
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- 기반인 JOB 테이블도 바뀐다.

-- DELETE 해보기
DELETE FROM VW_JOB
WHERE JOB_CODE = 'J8';

--> JOB, VW_JOB 다 삭제되어있음.

/*
   위와 같이 VIEW에 DML 구문을 수행하면 해당 VIEW를 구성하는 기반테이블에 적용이 된다.
   VIEW는 실제 데이터가 담긴 테이블이 아니라 테이블을 조회하는 구문이 담겨있고
   해당 구문을 수행하는 역할이기 때문
   VIEW 는 DML 구문을 수행하기보단 조회의 목적으로 사용된다.

   ***
   VIEW에 DML 구문이 실행 가능한 경우 : 서브쿼리를 이용하여 기존 테이블의 데이터에 별도의 조작없이 조회한 경우

   ***VIEW에 DML 처리가 불가능 한 경우***
   1)VIEW에 정의 되어 있지 않은 컬럼 조작
   2)VIEW에 정의 되어 있지 않은 컬럼 중 베이스 테이블에 NOT NULL 제약조건이 지정된 경우
   3)산술 연산식 또는 함수를 통해 정의된 경우
   4)그룹함수나 GROUP BY 절이 포함된 경우
   5)DISTINCT 구문이 포함된 경우
   6)JOIN을 이용하여 여러 테이블을 매칭시켜놓은 경우 등등...


*/

--VIEW 옵션
--FORCE : 쿼리문의 테이블, 컬럼, 함수등이 일부 존재하지 않아도 생성(강제 생성)
--[표현법] CREATE FORCE VIEW 뷰명 AS 쿼리문;

CREATE OR REPLACE VIEW VW_TEST
AS SELECT * FROM TB_TEST; -- TB_TEST라는 기반 테이블이 없기 때문에 생성 불가능

CREATE FORCE VIEW VW_TEST
AS SELECT * FROM TB_TEST; -- 강제 생성(기반테이블이 없어도 생성됨)

SELECT * FROM VW_TEST; --기반테이블이 없기 때문에 조회 불가

--기반 테이블 생성
CREATE TABLE TB_TEST(
  NO NUMBER
);

--VIEW의 구조만 미리 지정해놓고 싶을때 사용하는 구문

--WITH READ ONLY 옵션
--VIEW에 대한 DML처리를 막는 구문(조회전용으로 사용하기 위해)
CREATE OR REPLACE VIEW VW_READONLY
AS SELECT * FROM EMPLOYEE WITH READ ONLY;

SELECT * FROM VW_READONLY;
--DML 수행해보기
DELETE FROM VW_READONLY; -- SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
