/*
    파일명 : 13_PLSQL_KH계정.SQL

    PL/SQL
    오라클 내에 내장되어 있는 절차형 언어로
    SQL문장 내에서 변수의 정의, 조건처리(IF) 반복처리(FOR,LOOP,WHILE),예외처리등을 지원하여
    SQL문의 단점을 보완한다.
    다수의 SQL문을 한번에 수행가능

    PL/SQL문의 구조
    [선언부(DECLARE SECTION)] : DECLARE로 시작 변수나 상수를 선언 및 초기화 하는 영역
    [실행부(EXCUTABLE SECTION)] : BEGIN으로 시작 SQL문 또는 제어문등의 로직을 작성하는 영역
    [예외처리부(EXCEPTION SECTION)] : EXCEPTION으로 시작 예외 발생시 해결하기 위한 구문
    [종료부(END)] " END; / 로 구문의 끝을 표현한다.

*/

--출력 확인을 위한 아웃풋 옵션 켜주기
SET SERVEROUTPUT ON;

BEGIN
      DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/
-- 마지막 구문 표시  /를 넣어주면 영역이 끝났다는 것을 보여줌

/*
  1. DECLARE 선언부
  변수나 상수를 선언하는 공간(선언과 동시에 초기화 가능)
  일반 타입 변수, 레퍼런스 변수, ROW타입 변수

  1-1) 일반 타입 변수 선언 및 초기화
  [표현법]
  변수명[CONSTRAINT] 자료형 [:=값]; * := 표현은 대입 연산자  (:=)

*/

DECLARE -- 선언부
  EID NUMBER;
  ENAME VARCHAR2(20);
  PI CONSTANT NUMBER := 3.14;
BEGIN
  --위 선언부에서 선언한 변수에 데이터 대입하기
  --EID := 999;
  --ENAME := '김구구';

  --사용자에게 입력받는 프롬프트 : & (자바에서 스캐너 같은 느낌)
  EID := &번호;
  ENAME := '&이름';

  DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
  DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME); -- 회색으로 안변하면 오타 있는 것

END;
/

--이름, 나이, 성별을 변수처리후 사용자에게 입력받아 화면에 출력해보기
--NAME, AGE, GENDER 자료형은 자유

DECLARE
 NAME VARCHAR2(20);
 AGE NUMBER;
 GENDER VARCHAR2(10);
BEGIN
  NAME := '&이름';
  AGE := &나이;
  GENDER := '&성별';

  DBMS_OUTPUT.PUT_LINE('NAME : ' || NAME);
  DBMS_OUTPUT.PUT_LINE('AGE : ' || AGE);
  DBMS_OUTPUT.PUT_LINE('GENDER : ' || GENDER);

END;
/

/*
  1_2) 레퍼런스 타입 변수 선언 및 초기화(특정 테이블에 있는 컬럼 데이터 타입을 참조)

  [표현법]
  변수명 테이블명.컬럼명%TYPE;
*/

DECLARE
  EID EMPLOYEE.EMP_ID%TYPE; -- EMPLOYEE 테이블에 EMP_ID 컬럼 자료형 참조
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  SALARY EMPLOYEE.SALARY%TYPE;
BEGIN

  --EID := '299';
  --ENAME := '이구구';
  --SALARY := 3000000;

  SELECT EMP_ID,EMP_NAME,SALARY
  INTO EID,ENAME,SALARY -- 컬럼 조회데이터를 아래 INTO구문에서 변수에 담아주겠다.
  FROM EMPLOYEE
  WHERE EMP_ID = 200;

  DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
  DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || SALARY);

END;
/

----실습----
/*
   레퍼런스 타입 변수로 EID,ENAME,JCODE,DTITLE,SAL을 선언후
   각 자료형은 EMPLOYEE 테이블과 DEPARTMENT 테이블을 참조하여 자료형 선언
   사용자가 입력한 사번에 대한 사원정보를 출력해보세요
   출력은 변수명 : 담긴값 형태로 처리
*/

DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  JCODE EMPLOYEE.JOB_CODE%TYPE;
  DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
  SAL EMPLOYEE.SALARY%TYPE;
BEGIN

  EID := &사번;
  --ENAME := '&사원이름';
  --JCODE := '&직급코드';
  --DTITLE := '&부서명';
  --SAL := &급여;
  SELECT EMP_NAME,JOB_CODE,DEPT_TITLE,SALARY
  INTO ENAME,JCODE,DTITLE,SAL
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
  WHERE EMP_ID = EID;

  DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
  DBMS_OUTPUT.PUT_LINE('사원이름 : ' || ENAME);
  DBMS_OUTPUT.PUT_LINE('직급코드 : ' || JCODE);
  DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);

  --강사님 코드 보기

END;

/

/*
  1-3) ROW타입 변수 선언
  테이블의 한 행에 대한 모든 컬럼값을 담을 수 있는 변수
  [표현식] 변수명 테이블명%ROWTYPE;

*/

SELECT * FROM EMPLOYEE;

DECLARE
  E EMPLOYEE%ROWTYPE; --EMPLOYEE 테이블의 행 자료형 참조

BEGIN
  SELECT *
  INTO E -- 조회된 한 행을 E 변수에 담기
  FROM EMPLOYEE
  WHERE EMP_ID = '&사번';

  DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
  DBMS_OUTPUT.PUT_LINE('전화번호 : ' || E.PHONE);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);

END;
/
--DEPARTMENT 테이블을 ROW타입 변수로 설정한뒤(변수명 자유)
--사용자에게 부서코드를 입력받아 해당 부서정보 출력해보기

DECLARE
  D DEPARTMENT%ROWTYPE; -- DEPARTMENT 테이블의 행 자료형 참조

BEGIN
  SELECT *
  INTO D -- 조회된 한 행을 D 변수에 담기
  FROM DEPARTMENT
  WHERE DEPT_ID = '&부서코드';

  DBMS_OUTPUT.PUT_LINE('DEPT_ID : ' || D.DEPT_ID);
  DBMS_OUTPUT.PUT_LINE('부서명 : ' || D.DEPT_TITLE);
  DBMS_OUTPUT.PUT_LINE('지역코드 : ' || D.LOCATION_ID);

END;
/

/*
  VW_PLSQL 이름의 뷰를 사원명,부서명,직급명을 갖게 생성하여
  해당 뷰 ROWTYPE 설정 후 "사번"을 입력받아 해당 정보를 출력하는 구문 작성해보기
*/

CREATE OR REPLACE VIEW VW_PLSQL
                    AS (SELECT EMP_NAME "사원명"
                     ,DEPT_TITLE "부서명"
                     ,JOB_NAME "직급명"
            FROM EMPLOYEE E
            JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
            JOIN JOB J ON E.JOB_CODE = J.JOB_CODE);

--위 뷰를 이용하기
DECLARE
  --만들어준 뷰 ROWTYPE선언
  VW VW_PLSQL%ROWTYPE;
BEGIN
  --위 변수에 담아줄 행을 조회하는 구문 작성
  SELECT *
  INTO VW
  FROM VW_PLSQL
  WHERE 사원명 = (SELECT EMP_NAME
                 FROM EMPLOYEE
                 WHERE EMP_ID = '&사번');


  DBMS_OUTPUT.PUT_LINE('사원명 : ' || VW.사원명);
  DBMS_OUTPUT.PUT_LINE('부서명 : ' || VW.부서명);
  DBMS_OUTPUT.PUT_LINE('직급명 : ' || VW.직급명);
END;
/

-------------------------------------------------
/*
  조건문

  IF 조건문
    THEN 실행내용
  END IF;

  사번을 입력받고 해당 사원의 사번 이름 급여 보너스를 출력
  단 보너스를 받지 않은 사원은 보너스 출력 전 보너스를 지급받지 않는 사원입니다. 메시지 출력해보기
*/

DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  SAL EMPLOYEE.SALARY%TYPE;
  BONUS EMPLOYEE.BONUS%TYPE;
BEGIN

  SELECT EMP_ID,EMP_NAME,SALARY,NVL(BONUS,0)
  INTO EID,ENAME,SAL,BONUS
  FROM EMPLOYEE
  WHERE EMP_ID = '&사번';

  /*
  SELECT EMP_ID,EMP_NAME,SALARY,NVL(BONUS,0) INTO EID,ENAME,SAL,BONUS FROM EMPLOYEE WHERE EMP_ID = '&사번';
  사용자가 입력한 사번을 가지고 EMPLOYEE 테이블에 있는
  EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)열을 갖고 오는거잖아 그럼 그때 컬럼에 있는 데이터들을 EID, ENAME, SAL, BONUS로 보겠다는거임?

  → 이 뜻이, "EMPLOYEE 테이블에서 해당 컬럼 값을 가져와서
  PL/SQL의 변수 EID, ENAME, SAL, BONUS에 넣겠다" 맞나요? 네
  */

  DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
  DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);

  --보너스를 받지 않는 사원에 대한 조건처리
  IF (BONUS = 0)
     THEN DBMS_OUTPUT.PUT_LINE('보너스를 받지 않는 사원입니다.');
  END IF;

  DBMS_OUTPUT.PUT_LINE('보너스 : ' || BONUS);



END;
/

--사원정보 한행을 담는 변수 선언 후
--사원명,부서코드,급여를 출력해보세요
--만약 부서코드가 없다면 부서코드를 출력하기전에 부서를 배정받지 않은 사원입니다. 를 출력해보기
--출력형식 : 사원명 : OOO

DECLARE
   E EMPLOYEE%ROWTYPE;
BEGIN
   SELECT *
   INTO E
   FROM EMPLOYEE
   WHERE EMP_ID = '&사번';

   DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);

   IF (E.DEPT_CODE = '부서 없음')
     THEN DBMS_OUTPUT.PUT_LINE('부서를 배정받지 않은 사원입니다.');
   END IF;

   DBMS_OUTPUT.PUT_LINE('부서코드 : ' || E.DEPT_CODE);

END;
/

--2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF;

DECLARE
   E EMPLOYEE%ROWTYPE;
BEGIN
   SELECT *
   INTO E
   FROM EMPLOYEE
   WHERE EMP_ID = '&사번';

   DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);

   --부서가 없으면 부서를 배정받지 않음 / 부서가 있으면 부서를 배정받음 출력 해보기

   IF E.DEPT_CODE IS NULL
      THEN DBMS_OUTPUT.PUT_LINE('부서를 배정 받지 않은 사원입니다.');
   ELSE
        --ELSE에는 THEN을 입력하지 않음.
       DBMS_OUTPUT.PUT_LINE('부서를 배정 받은 사원입니다.');
   END IF;

END;
/

--------------------------------------
/*
  레퍼런스 타입변수(EID,ENAME,DTITLE,NCODE) 와 일반 변수 TEAM VARCHAR2(10)을 사용한다.
  참조는 EMPLOYEE 테이블을 이용할것
  사용자가 입력한 사번에 대한 사번,이름,부서명,근무국가카드를 조회하고
  NCODE의 값이 KO 일 경우 TEAM변수에 한국팀대입
  KO가 아닐경우 해외팀을 대입하여
  사번 이름 부서 소속(TEAM)을 출력해보세요.
*/

DECLARE
   EID EMPLOYEE.EMP_ID%TYPE;
   ENAME EMPLOYEE.EMP_NAME%TYPE;
   DTITLE EMPLOYEE.EMP_NAME%TYPE; -- 데이터 타입을 보고 몇 바이트인지를 봐야함 DEPT_TITLE, NATIONAL_CODE 데이터 타입을 봐야함.
   NCODE EMPLOYEE.DEPT_CODE%TYPE;
   TEAM VARCHAR2(10);
BEGIN
  SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
  INTO EID,ENAME,DTITLE,NCODE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
  JOIN LOCATION ON LOCATION_ID = LOCAL_CODE
  JOIN NATIONAL USING (NATIONAL_CODE)
  WHERE EMP_ID = '&사번';

  DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
  DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
  DBMS_OUTPUT.PUT_LINE('부서 이름 : ' || DTITLE);

  DBMS_OUTPUT.PUT_LINE('근무국가카드 : ' || NCODE);

  IF(NCODE = 'KO')
    THEN TEAM := '한국팀';
  ELSE
    TEAM := '해외팀';
  END IF;
  DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
  DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
  DBMS_OUTPUT.PUT_LINE('부서 이름 : ' || DTITLE);
  DBMS_OUTPUT.PUT_LINE('소속 : ' || TEAM);







END;
/


--3) IF ELSIF ELSE
/*
   IF 조건식
      THEN 실행구문
   ELSIF 조건식
      THEN 실행구문
   ...
   ELSE
      실행구문
   END IF;
*/

/*
  레퍼런스 변수로 SAL ENAME 설정하고 일반 타입 변수로 GRADE VARCHAR2(10) 설정
  사번을 입력받아 해당 사원의 급여등급을 측정해보기
  급여가 500만원 이상이면 고급
  급여가 500만원 미만 300만원 이상이면 중급
  그외는 초급을 GRADE에 담아 출력문은 해당 사원의 급여 등급은 XX 입니다 를 출력해보세요.
*/

DECLARE
   SAL EMPLOYEE.SALARY%TYPE;
   ENAME EMPLOYEE.EMP_NAME%TYPE;
   GRADE VARCHAR2(10);
BEGIN
     SELECT SALARY, EMP_NAME
     INTO SAL, ENAME
     FROM EMPLOYEE E
     WHERE EMP_ID = '&사번';

     IF(SAL >= 5000000)
       THEN GRADE := '고급';
     ELSIF(SAL >= 3000000 OR SAL < 5000000)
       THEN GRADE := '중급';
     ELSE
       GRADE :='초급';
     END IF;

     --해당 사원의 급여 등급은 XX입니다.
     DBMS_OUTPUT.PUT_LINE('해당 사원 ' || ENAME || '의 급여 등급은 ' ||GRADE|| '입니다.');

END;
/

--------------------------------------------------------------

/*
  사원의 사번을 입력받아 사원명, 부서명, 지역명 ,국가명을 조회하는 VIEW 를 생성
  ROWTYPE 변수에 담고
  일반타입 변수 STR VARCHAR2(20)을 만들어
  입력한 사원의 국가에 따라서 OOO 사원님 (해당 국가 인사말) 을 STR 변수에 대입하고 출력하기
  EX ) 한국 : 선동일 사원님 안녕하세요 / 일본 : 하이유 사원님 오하요
*/
CREATE OR REPLACE VIEW VW_HI
  AS SELECT  EMP_NAME 사원명
             ,DEPT_TITLE 부서명
             ,LOCAL_NAME 지역명
             ,NATIONAL_NAME 국가명
      FROM EMPLOYEE E
      JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
      JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;


DECLARE
  VW VW_HI%ROWTYPE;
  STR VARCHAR2(50);

BEGIN

  SELECT *
  INTO VW
  FROM VW_HI
  WHERE 사원명 = (SELECT EMP_NAME
                     FROM EMPLOYEE
                     WHERE EMP_ID = '&사번');


  IF(VW.국가명 = '한국')
    THEN STR := '안녕하세요';
  ELSIF(VW.국가명 = '일본')
    THEN STR :=  '오하요.';
  ELSIF(VW.국가명 = '중국')
    THEN STR :=  '니하오마';
  ELSIF(VW.국가명 = '미국')
    THEN STR :=  '헬로우';
  ELSE
    STR :=  '즈드라스트부이쩨';
  END IF;

  DBMS_OUTPUT.PUT_LINE(VW.사원명 || '님 ' || STR);


END;
/


/*
   2)
   사원의 연봉을 구하는 PL/SQL문 작성하기
   사원의 보너스가 있다면 보너스 포함 연봉 출력
   보너스가 없다면 급여*12 연봉 출력
   ROWTYPE 변수로 EMPLOYEE이용
   연봉 담을 변수로 VEARSAL NUMBER 일반타입 변수 사용하기
   사번을 입력받아 OOO님의 연봉은 \000,000,000원 입니다. 형식으로 출력하기
*/

DECLARE
  E EMPLOYEE%ROWTYPE;
  YEARSAL NUMBER;
BEGIN

   SELECT *
   INTO E
   FROM EMPLOYEE
   WHERE EMP_ID = '&사번';

   IF E.BONUS IS NOT NULL
      THEN YEARSAL := (E.SALARY + (E.SALARY * E.BONUS)) * 12;
   ELSE
      YEARSAL := E.SALARY * 12;
   END IF;

   DBMS_OUTPUT.PUT_LINE(E.EMP_NAME||'님의 연봉은 ' || TO_CHAR(YEARSAL, 'FML999,999,999') ||'원 입니다.');


END;
/

------------------------------------------------------------------------

/*

  반복문

  1) BASIC LOOP문
  [표현식]
  LOOP
     반복적으로 실행할 구문

     *반복을 빠져나갈 구문
  END LOOP;

  *반복을 빠져나갈 구문 2가지
  1)IF 조건식 THEN EXIT; END IF;
  2)EXIT WHEN 조건식;

*/

DECLARE
    I NUMBER := 1; -- 시작값 1로 초기화
BEGIN

    LOOP

      DBMS_OUTPUT.PUT_LINE('I값 : ' || I);
      I := I + 1;  -- I값 증가시키는 구문

      --1)
--      IF I = 6
--         THEN EXIT; -- 반복 벗어나기
--      END IF;

      --2) EXIT WHEN 구문
        EXIT WHEN I = 10;

    END LOOP;

END;
/

-------------------------

/*
  2) FOR LOOP
  [표현식]
  FOR 변수 IN 초기값.. 최종값
  LOOP
    반복실행구문
  END LOOP;

*/

--선언부 생략
BEGIN

    FOR I IN 1..10
    LOOP
      DBMS_OUTPUT.PUT_LINE('I값 : ' || I);
    END LOOP;
END;
/

--구구단 짝수단 출력해보기
--RESULT NUMBER 변수 사용하여 결과값 담고 출력하기

DECLARE
  RESULT NUMBER;
BEGIN

   FOR I IN 2..9
   LOOP

    FOR J IN 1..9
    LOOP
      EXIT WHEN (MOD(I, 2) != 0);
      RESULT := I * J;
      DBMS_OUTPUT.PUT_LINE(I || ' X ' || J || ' = ' || RESULT);

    END LOOP;

   END LOOP;

END;
/

-----------------------------------------------------

--FOR LOOP 구문은 SELECT 결과 순회도 가능
--EMPLOYEE 테이블 데이터 순회 하며 출력하기

BEGIN -- 이거 원리가 INTO랑 비슷한지 파악하기
   FOR E IN (SELECT * FROM EMPLOYEE) LOOP
     DBMS_OUTPUT.PUT_LINE(E.EMP_NAME||'사원의 급여는 '||E.SALARY||'원 입니다.');
   END LOOP;
END;
/

--사원명, 부서명, 급여를 출력하시오
--반복문을 이용하여 처리하기
--출력예시 OOO사원의 부서는 OOO이고 급여는 OOO원 입니다.
--만약 부서가 없다면 부서없음 을 출력

BEGIN
  FOR EE IN (SELECT EMP_NAME, DEPT_TITLE ,SALARY  FROM EMPLOYEE E
              LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID) LOOP
      DBMS_OUTPUT.PUT_LINE(EE.EMP_NAME || '사원의 부서는 ' || NVL(EE.DEPT_TITLE, '부서 없음') || '이고 급여는 ' || EE.SALARY ||'원 입니다.');
  END LOOP;
END;
/

-------------------------------------------------------

/*
  3) WHILE LOOP문
  [표현식]
  WHILE 반복수행조건
  LOOP
     수행 구문
  END LOOP;
*/

DECLARE
  I NUMBER := 1; -- 초기값
BEGIN
  WHILE I < 6
  LOOP
     DBMS_OUTPUT.PUT_LINE('I값 : ' || I);
     I:=I+1; -- 증감식
  END LOOP;

END;
/

------------------------------------------------------------------------------------------------------------------------
/*
  예외 처리 부

  예외(EXCEPTION): 실행중 발생하는 오류
  [표현식]
  EXCEPTION
     WHEN 예외명1 THEN 예외처리구문1;
     WHER 예외명2 THEN 예외처리구문2;

     ...
     WHEN OTHERS THEN 예외처리구문N;

*/

--사용자가 입력한 수로 나눗셈 연산처리 결과 출력
DECLARE
  RESULT NUMBER;
BEGIN
  RESULT := 10/&숫자;
  DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
END;   -- 01476. 00000 -  "divisor is equal to zero"
/

--0으로 나눌 수 없어 나는 예외
--처리해보기
DECLARE
   RESULT NUMBER;
BEGIN
   RESULT := 10/&숫자;
   DBMS_OUTPUT.PUT_LINE('RESULT : ' || RESULT);
EXCEPTION
   WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없음');
END;
/

--UNIQUE 제약조건 위배
BEGIN

  UPDATE EMPLOYEE
  SET EMP_ID ='&변경할사번'
  WHERE EMP_NAME = '방명수';

  --예외처리
EXCEPTION
  --WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
  --예외에 따라 처리하는것이 아닌 모든 예외상황시 프로그램이 비정상종료 되지 않도록 예외잡기
  WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('예외 발생');

END;
/

--사원 정보 조회하여 변수에 담을때 여러행이 조회되면 발생하는 예외처리
--EID, ENAME 레퍼런스변스로 준비 후
--사수사번을 입력받아 해당 사수사번을 가진 사원의 사번 사원명을 출력 해보자
--이때 발생하는 예외를 처리해보시오.
--예외 공식문서 참조
DECLARE
  EID EMPLOYEE.EMP_ID%TYPE;
  ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
  SELECT EMP_ID, EMP_NAME
  INTO EID, ENAME
  FROM EMPLOYEE
  WHERE MANAGER_ID = '&사수사번';

  DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
  DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);

EXCEPTION

 -- WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('예외 발생');
  WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('다중 행 발생');
  WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('데이터 없음 예외 발생');


END;
/