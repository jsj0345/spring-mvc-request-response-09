/*
   --파일명 : 07_DML(INSERT,UPDATE,DELETE)_KH계정

   DML(DATA MANIPULATION LANGUAGE)

   데이터 조작언어
   테이블에 새로운 데이터를 삽입(INSERT) 하거나
   기존의 데이터를 수정(UPDATE)하거나
   삭제(DELETE) 하는 구문

   1. INSERT : 테이블에 새로운 행을 추가하는 구문

   [표현법]
   INSERT INTO 테이블명 VALUES(값1,값2,...);
   -해당 테이블에 모든 컬럼에 데이터를 추가하고자 할때 사용하는 구문
   -컬럼의 순서, 자료형 개수를 맞춰서 VALUES 괄호 안에 나열해야한다.
   -나열된 데이터가 정해진 컬럼보다 적을 경우 : NOT ENOUGH VALUES 오류
   -나열된 데이터가 정해진 컬럼보다 많을 경우 : NOT MANY VALUES 오류 발생

*/

--EMPLOYEE 테이블에 사원 데이터 추가하기
SELECT *
FROM EMPLOYEE;

INSERT INTO EMPLOYEE
VALUES (900,'김유저','000101-3322333','user01@gmail.com'
        ,'01033335555','D5','J6','S5',3500000,0.8,214,SYSDATE,NULL,DEFAULT);


/*
   2) INSERT INTO 테이블명(컬럼명, 컬럼명, ...) VALUES (값,값,...);
   - 해당 테이블에 특정 컬럼만 선택하여 해당 컬럼에 추가할 값 제시할 때 사용
   - 한 행 단위로 추가되기 때문에 선택되지 않은 컬럼은 기본값이 삽입된다 (NULL 또는 DEFAULT)
   - DEFAULT 설정이 되어있다면 해당 값이 삽입된다.
   - NOT NULL 제약조건이 설정되어 있다면 선택하여 값을 제시하거나 DEFAULT 값이 설정되어야한다.
*/

INSERT INTO EMPLOYEE (EMP_ID
                      ,EMP_NAME
                      ,EMP_NO
                      ,JOB_CODE
                      ,SAL_LEVEL)
VALUES(901, '김사원', '990505-4433222','J6','S6');

SELECT *
FROM EMPLOYEE
WHERE EMP_ID = '901'; -- 자동 형변환이 되어서 들어간 것. ,ENT_YN은 DEFAULT

/*
  3) INSERT INTO 테이블명 (서브쿼리);
  -VALUES로 직접 값을 기입하는것이 아니라
  서브쿼리로 조회된 데이터를 INSERT 하는 구문
  여러행을 한번에 INSERT 할 수 있다.
*/

--테이블 생성
CREATE TABLE EMP_01 (
      EMP_ID NUMBER,
      EMP_NAME VARCHAR2(30),
      DEPT_TITLE VARCHAR2(20)
);

SELECT *
FROM EMP_01;

--전체사원들의 사번, 이름, 부서명을 조회한 결과를 테이블에 넣어보기
SELECT EMP_ID
       ,EMP_NAME
       ,NVL(DEPT_TITLE, '부서 없음')
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID);

--조회구문을 이용하여 데이터 삽입해보기
INSERT INTO EMP_01 (SELECT EMP_ID
                          ,EMP_NAME
                          ,NVL(DEPT_TITLE, '부서 없음')
                    FROM EMPLOYEE
                    LEFT JOIN DEPARTMENT ON (EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID));

SELECT *
FROM EMP_01; -- 조회

/*
   INSERT ALL
   두개 이상의 테이블에 각각 INSERT할때 사용하는 구문
   조건 : 사용하는 서브쿼리가 동일해야한다.
   [표현법]
   INSERT ALL
   INTO 테이블명1 VALUES (컬럼명,컬럼명,...)
   INTO 테이블명2 VALUES (컬럼명,컬럼명,...)
   서브쿼리;

   --
   테스트용 테이블 생성하기

   첫번째 테이블 사번,사원명,직급명
   두번째 테이블 사번,사원명,부서명

   두 테이블 모두 데이터 없이 EMPLOYEE 테이블 형식만 참조하여 만들기
   첫번째 테이블은 CREATE TABLE 구문으로 각 데이터 컬럼 정의
   두번째 테이블은 CREATE TABLE 서브쿼리구문으로 생성하기

*/

CREATE TABLE EMP_JOB (
    EMP_ID VARCHAR2(3 BYTE)
    ,EMP_NAME VARCHAR2(20 BYTE)
    ,JOB_NAME VARCHAR2(35 BYTE)
);

CREATE TABLE EMP_DEPT AS ( SELECT EMP_ID
                                  ,EMP_NAME
                                  ,DEPT_TITLE
                                  FROM EMPLOYEE
                                  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                                  WHERE 1=0);

-- 생성된 테이블 조회
SELECT * FROM EMP_JOB;
SELECT * FROM EMP_DEPT;

--EMP_JOB과 EMP_DEPT 테이블에 각각 조회된 데이터 넣어보기
--급여 300만원 이상 받는 사원들의 사번,이름,직급명,부서명 조회

--조회구문
SELECT EMP_ID
       ,EMP_NAME
       ,JOB_NAME
       ,DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY >= 3000000;

--INSERT ALL 구문을 이용하여 EMP_JOB, EMP_DEPT에 각 조회 결과 삽입하기
INSERT ALL
       INTO EMP_JOB VALUES(EMP_ID,EMP_NAME,JOB_NAME)
       INTO EMP_DEPT VALUES(EMP_ID,EMP_NAME,DEPT_TITLE)
SELECT EMP_ID
       ,EMP_NAME
       ,JOB_NAME
       ,DEPT_TITLE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY >= 3000000; -- 18개 행이 삽입되었습니다.

SELECT * FROM EMP_JOB; -- 9행

SELECT * FROM EMP_DEPT; -- 9행
--각각 작성한 컬럼명으로 조회된 결과행이 삽입된다.

--INSERT ALL을 이용하여 여러행 한번에 대입하기
INSERT INTO EMP_JOB VALUES(300, '김데모', '대리');
INSERT INTO EMP_JOB VALUES(301,'박연습','사원');
INSERT INTO EMP_JOB VALUES(302,'최과장','과장');

--INSERT ALL 구문에서 서브쿼리로 위 데이터 한번에 처리하기
INSERT ALL
   INTO EMP_JOB VALUES(300, '김데모', '대리')
   INTO EMP_JOB VALUES(301,'박연습','사원')
   INTO EMP_JOB VALUES(302,'최과장','과장')
SELECT *
FROM DUAL; -- 가상 테이블을 이용하여 서브쿼리 구문 작성, 나중에 MYBATIS에서 쓸 수 있음.

-- SELECT * FROM DUAL;에서 3개의 행이 나왔다고 생각하자
--그럼 1개씩마다 INSERT ALL 에 들어가서 실행 즉, 3X3 = 9




SELECT * FROM EMP_JOB;


/*
   INSERT ALL
     WHEN 조건1 THEN
     INTO 테이블명 VALUES (컬럼명,컬럼명,...)
     WHEN 조건2 THEN
     INTO 테이블명 VALUES (컬럼명,컬럼명)
    서브쿼리

    -조건에 맞는 값들을 삽입하겠다.

*/

--테스트용 테이블 생성
--사번,사원명,입사일,급여를 담을 테이블 EMP_OLD/EMP_NEW 두개 만들기

CREATE TABLE EMP_OLD
AS (SELECT EMP_ID
           ,EMP_NAME
           ,HIRE_DATE
           ,SALARY
     FROM EMPLOYEE
     WHERE 1 = 0);

CREATE TABLE EMP_NEW
AS (SELECT EMP_ID
           ,EMP_NAME
           ,HIRE_DATE
           ,SALARY
     FROM EMPLOYEE
     WHERE 1 = 0);

SELECT * FROM EMP_NEW;
SELECT * FROM EMP_OLD;

--서브쿼리로 이용할 구문 작성
--2010년 이전 이후 조건으로 조회
SELECT EMP_ID
       ,EMP_NAME
       ,HIRE_DATE
       ,SALARY
FROM EMPLOYEE
WHERE HIRE_DATE < '2010/01/01'; --2010년 이전 입사자 9명

SELECT EMP_ID
       ,EMP_NAME
       ,HIRE_DATE
       ,SALARY
FROM EMPLOYEE
WHERE HIRE_DATE >= '2010/01/01'; -- 15명

--INSERT ALL 구문에 조건 추가해보기
INSERT ALL
     WHEN HIRE_DATE < '2010/01/01' THEN
     INTO EMP_OLD(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
     WHEN HIRE_DATE >= '2010/01/01' THEN
     INTO EMP_NEW(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
SELECT EMP_ID,EMP_NAME,HIRE_DATE,SALARY
FROM EMPLOYEE; -- 24개 행이 삽입되었습니다.

SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

----------------------------------------------------------------------------------------------

/*
    2. UPDATE
    테이블에 기록된 기존 데이터를 수정하는 구문

    [표현법]
    UPDATE 테이블명
    SET 컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...
    WHERE 조건; -- WHERE절은 생략 가능하지만 생략하면 모든 행에 수정 작업이 일어난다.
*/

--복사본 테이블 만들기
CREATE TABLE DEPT_COPY
AS (SELECT * FROM DEPARTMENT);

SELECT *
FROM DEPT_COPY;

--DEPT_COPY 테이블에서 D9 부서의 부서명을 전략기획부로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'; --9개 행이 업데이트됨
--WHERE절로 특정 행을 지정하지 않으면 모든 행에 수정 작업 처리됨

ROLLBACK; -- 되돌리기 이전 COMMIT 시점으로

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획부'
WHERE DEPT_ID = 'D9'; --1행이 업데이트됨
--WHERE 조건에 따라서 1개행이 변경될수도 여러개행이 변경될수도 있다.

--복사본 테이블 생성하기
--테이블명 EMP_SALARY / 컬럼 EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS(데이터도 같이 복사)

CREATE TABLE EMP_SALARY
AS (SELECT EMP_ID
           ,EMP_NAME
           ,DEPT_CODE
           ,SALARY
           ,BONUS
     FROM EMPLOYEE);

SELECT *
FROM EMP_SALARY;


--EMP_SALARY 테이블에서 노옹철 사원의 급여 1000만원으로 변경하기

UPDATE EMP_SALARY
SET SALARY = '10000000'
WHERE EMP_NAME = '노옹철';

--EMP_SALARY 테이블에서 선동일 사원의 급여를 700만원으로 보너스를 0.2로 변경하기
UPDATE EMP_SALARY
SET SALARY = '7000000' , BONUS = '0.2'
WHERE EMP_NAME = '선동일';


--EMP_SALARY 테이블 전체 사원의 급여에 20퍼센트 인상한 금액으로 변경해보기
UPDATE EMP_SALARY
SET SALARY = (SALARY + (SALARY * 0.2));

UPDATE EMP_SALARY
SET SALARY = SALARY * 2
WHERE DEPT_CODE = 'D2'; -- 3개행

/*
   UPDATE 구문에 서브쿼리 이용하기
   서브쿼리를 수행한 결과로 기존값으로 부터 변경하겠다.

   [표현법]
   UPDATE 테이블명
   SET 컬럼명 = 서브쿼리
   WHERE 조건; - 생략 가능
*/

--EMP_SALARY 테이블에 있는 김유저 사원의 부서코드를 유하진 사원의 부서코드와 동일하게 변경하기
--1) 유하진 사원 부서코드 알아오기
SELECT DEPT_CODE
FROM EMP_SALARY
WHERE EMP_NAME = '유하진'; -- D2

SELECT DEPT_CODE
FROM EMP_SALARY
WHERE EMP_NAME = '김유저'; -- D5

UPDATE EMP_SALARY
SET DEPT_CODE = (SELECT DEPT_CODE
                FROM EMP_SALARY
                WHERE EMP_NAME = '유하진')
WHERE EMP_NAME = '김유저';

--방명수 사원의 급여와 보너스를 유재식 사원의 급여와 보너스값으로 변경해보기
UPDATE EMP_SALARY
SET (SALARY, BONUS)  = (SELECT SALARY, BONUS
                           FROM EMP_SALARY
                           WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

COMMIT;

--노옹철 사원의 사번을 200번으로 변경해보기 EMPLOYEE 테이블
UPDATE EMPLOYEE
SET EMP_ID = 200
WHERE EMP_NAME = '노옹철'; -- (KH.EMPLOYEE_PK)에 위배됩니다.
--UPDATE 시 제약 조건을 위배할 수 없다.

-----------------------------------------------------------------------------------

/*
   4. DELETE
   테이블에 기록된 데이터를 행 단위로 삭제하는 구문
   [표현법]
   DELETE FROM 테이블명
   WHERE 조건; -생략시 전체행 대상
*/

--EMP_SALARY 테이블
DELETE FROM EMP_SALARY; -- 25개 행이 삭제되었습니다.

SELECT * FROM EMP_SALARY;

ROLLBACK;

--조건을 이용하여 김유저 김사원 삭제해보기
DELETE FROM EMP_SALARY
WHERE EMP_NAME IN ('김유저','김사원'); -- 2개행 삭제

--조건에 따라서 삭제되는 행 수가 달라진다.


DELETE FROM EMP_SALARY
WHERE EMP_NAME = (SELECT EMP_NAME
                 FROM EMP_SALARY
                 WHERE EMP_ID = 220); --서브쿼리를 이용하여 조건처리

SELECT *
FROM EMP_SALARY;

/*
    (DDL)
    TRUNCATE : 테이블의 전체행을 삭제할때 사용하는 구문(절삭)
               DELETE 구문보다 수행속도가 빠르고 별도의 조건 제시할 필요 없음
               테이블 데이터가 절삭되는 DDL 구문이기때문에 ROLLBACK으로 되돌릴 수 없음.
               *(DELETE는 DML 구문이라 확정 전까지 ROLLBACK 되돌리기 가능)

    [표현법]
    TRUNCATE TABLE 테이블명;
*/
COMMIT;
SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY;

ROLLBACK; --DML(DELETE)롤백 가능

TRUNCATE TABLE EMP_SALARY;  --ROLLBACK 불가능

ROLLBACK;