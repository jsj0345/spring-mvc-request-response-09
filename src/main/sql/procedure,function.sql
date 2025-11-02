/*
  파일명 : 14_PROCEDURE,FUNCTION_KH계정

  <PROCEDURE>
  PL/SQL 구문을 저장하여 이용하는 객체
  필요할때마다 작성해놓은 PL/SQL문을 호출 할 수 있다.

  [표현법]
  CREATE[OR REPLACE] PROCEDURE 프로시저명[(매개변수)]
  IS
  BEGIN
     실행부;
  END;
*/
--프로시저 생성

--EMPLOYEE 테이블을 복사한 COPY 테이블 생성(테스트용)
CREATE TABLE PRO_TEST
AS SELECT * FROM EMPLOYEE;

--다시 확인하기 위해 삭제 구문
DROP TABLE PRO_TEST;

SELECT *
FROM PRO_TEST;

CREATE OR REPLACE PROCEDURE DELETE_DATA
IS
BEGIN
  --위에서 만든 테이블 데이터를 삭제하고 커밋까지 진행하는 구문 작성(DML)
  DELETE FROM PRO_TEST; -- PRO_TEST 테이블 데이터를 모두 지우는 구문
  COMMIT; --확정

END;
/
--Procedure DELETE_DATA이(가) 컴파일되었습니다. (등록되었다.)

--생성된 프로시저 확인해보기
SELECT *
FROM USER_PROCEDURES;

--프로시저 실행
BEGIN
  DELETE_DATA();
END;
/

--전달값이나 반환값이 없는 프로시저의 경우 간단히 실행 가능
EXEC DELETE_DATA;

SELECT * FROM PRO_TEST;

---------------------------------------------------------------
/*
  매개변수 선언하여 사용하는 프로시저
  IN : 프로시저 실행시 필요한 값을 받는 변수(자바 매개변수와 동일)
  OUT : 프로시저를 호출한 곳으로 되돌려주는 변수(결과값)

*/

CREATE OR REPLACE PROCEDURE PRO_SELECT_EMP( -- 변수명 IN/OUT 자료형
                                            V_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
                                            V_EMP_NAME OUT EMPLOYEE.EMP_NAME%TYPE,
                                            V_SALARY OUT EMPLOYEE.SALARY%TYPE,
                                            V_BONUS OUT EMPLOYEE.BONUS%TYPE
                                          )

IS

BEGIN
   SELECT EMP_NAME,SALARY,BONUS
   INTO V_EMP_NAME, V_SALARY, V_BONUS -- 조회된 데이터들 OUT 변수에 담아주기
   FROM EMPLOYEE
   WHERE EMP_ID = V_EMP_ID; -- IN으로 전달받은 전달데이터 담긴 변수


END;
/

--프로시저 호출해서 결과확인해보기

DECLARE
  --프로시저를 호출하여 응답받을 데이터 담을 변수 (OUT으로 나온 데이터 담아줄 변수)
  ENAME EMPLOYEE.EMP_NAME%TYPE;
  ESAL EMPLOYEE.SALARY%TYPE;
  EBONUS EMPLOYEE.BONUS%TYPE;

BEGIN

  --프로시저를 호출하여 IN으로 선언된 매개변수 위치에 전달해야하는 데이터 넣고
  --OUT으로 선언된 매개변수 위치에는 응답받은 데이터를 담을 변수 넣어주기
  PRO_SELECT_EMP(&사번,ENAME,ESAL,EBONUS);

  DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
  DBMS_OUTPUT.PUT_LINE('급여 : ' || ESAL);
  DBMS_OUTPUT.PUT_LINE('보너스 : ' || EBONUS);

END;
/

--EMPLOYEE 테이블을 복사하여 EMP_PRO_TEST 테이블을 만들고 (모든데이터복사)
--부서코드를 전달받아 해당 부서를 가진 사원을 모두 삭제하는 프로시저를 생성하시오.
--프로시저명 : DELETE_DEPT

CREATE TABLE EMP_PRO_TEST
AS (SELECT * FROM EMPLOYEE);

SELECT * FROM
EMP_PRO_TEST;

CREATE OR REPLACE PROCEDURE DELETE_DEPT ( V_DEPT_CODE IN EMPLOYEE.DEPT_CODE%TYPE


                            )

IS

BEGIN
     DELETE FROM EMP_PRO_TEST
     WHERE DEPT_CODE = V_DEPT_CODE;
     COMMIT;
END;
/

SELECT * FROM EMP_PRO_TEST ORDER BY DEPT_CODE DESC;

BEGIN
   DELETE_DEPT('&부서코드');

END;
/




--DEPT_AVG 라는 이름의 프로시저를 작성
--해당 프로시저는 부서코드를 입력받아 해당 부서의 평균 급여와 인원수를 반환하는 프로시저이다.
--이때 사용되는 변수명 및 자료형은 자유롭게 작성하고
--평균은 반올림처리하여 화면에 평균급여 : OOO / 인원수 : OOO명 으로 출력되도록 작성해보시오.

CREATE OR REPLACE PROCEDURE DEPT_AVG (  V_DEPT_CODE IN EMPLOYEE.DEPT_CODE%TYPE,
                                        V_AVERAGE OUT NUMBER,
                                        V_COUNT OUT  NUMBER

                                       )
IS

BEGIN
   SELECT AVG(SALARY), COUNT(*)
   INTO V_AVERAGE , V_COUNT
   FROM EMPLOYEE
   WHERE DEPT_CODE = V_DEPT_CODE
   GROUP BY DEPT_CODE;


END;
/

DECLARE
  AVER NUMBER;
  P NUMBER;
BEGIN
  DEPT_AVG('&부서코드',AVER,P);





  DBMS_OUTPUT.PUT_LINE('평균 급여 : ' || ROUND((AVER)));
  DBMS_OUTPUT.PUT_LINE('사람수 : ' || P);

END;
/

--데이터 삽입용 프로시저 작성해보기
--EMPLOYEE 테이블에 필수입력사항들을 입력받아 EMPLOYEE 테이블에 데이터 한 행을 추가하는 프로시저 작성해보기
SELECT * FROM EMPLOYEE;

CREATE OR REPLACE PROCEDURE INSERT_EMP(EID IN EMPLOYEE.EMP_ID%TYPE,
                                       ENAME IN EMPLOYEE.EMP_NAME%TYPE,
                                       ENO IN EMPLOYEE.EMP_NO%TYPE,
                                       JCODE IN EMPLOYEE.JOB_CODE%TYPE,
                                       SLEVEL IN EMPLOYEE.SAL_LEVEL%TYPE)

IS

BEGIN
    INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,SAL_LEVEL)
    VALUES(EID,ENAME,ENO,JCODE,SLEVEL);

    COMMIT;
END;
/

--실행
EXEC INSERT_EMP(555,'김오오','555555-5555555','J5','S5');

SELECT *
FROM EMPLOYEE;

/*
  프로시저 장점
  1.처리속도가 빠르다.
  2.대량 자료 처리시 효율이 좋음
   -DB에서 대용량 데이터를 SELECT로 조회하여 자바단에서 처리하는 경우와
     DB 자체에서 처리하는 경우
     DB에서 자바단(서버)로 전달시에 발생하는 네트워크 비용을 줄일 수 있음(효율성)

  프로시저 단점
  1. DB작업을 직접 사용하는것이기 때문에 DB에 부하를 줄 수 있다.
  2. 유지보수 측면에서 본다면 자바 소스코드와 오라클 코드를 동시 관리하기 어려움이 있다.

*/

/*
  1)
  프로시저를 이용하여 모든 사원의 급여를 인상시키는 작업을 해보기
  EMPLOYEE 테이블을 복사한 PRO_TEST 테이블을 만들고
  SALARY_UPDATE라는 프로시저를 생성하여
  전달받은 값 만큼의 퍼센트로 급여를 인상시키는 프로시저를 작성하시오 (매개변수명 자료형 자유)
  EX) 전달값 20 == 20% 인상

  2)
  프로시저를 이용하여 PRO_TEST 테이블에 있는 사원정보중 핸드폰 번호가 없는 사원이라면
  '번호 없음' 데이터를 넣어보기
  프로시저에 사원번호를 전달받고 전달받은 사원번호로 사원 정보를 조회하여
  번호가 있으면 사원정보 사원명 ,핸드폰번호 출력
  번호가 없으면 '번호없음' 데이터 넣고 사원명, 핸드폰번호, 이메일 주소 출력해보기

*/

--1번

DROP TABLE PRO_TEST;

CREATE TABLE PRO_TEST_100
AS (SELECT * FROM EMPLOYEE);

SELECT * FROM PRO_TEST_100;

CREATE OR REPLACE PROCEDURE SALARY_UPDATE(SALARY_PERCENT IN NUMBER)

IS

BEGIN
   UPDATE PRO_TEST_100
   SET SALARY = SALARY + (SALARY * SALARY_PERCENT);


END;
/

EXEC SALARY_UPDATE(20);

--2번 , 반복문에 UPGRADE를 SELECT 위에 추가?

CREATE OR REPLACE PROCEDURE PHONE_INFORMATION( EID IN PRO_TEST.EMP_ID%TYPE
                                              ,ENAME OUT PRO_TEST.EMP_NAME%TYPE
                                              ,PHONEE OUT PRO_TEST.PHONE%TYPE
                                              ,EMAILL OUT PRO_TEST.EMAIL%TYPE

)

IS

BEGIN


     /*
     SELECT EMP_NAME, PHONE
     INTO ENAME, PHONEE
     FROM PRO_TEST
     WHERE EMP_ID = EID;
     */

     FOR E IN (SELECT * FROM PRO_TEST) LOOP
        IF((EID = E.EMP_ID) AND (E.PHONE IS NOT NULL)) THEN
          SELECT EMP_NAME,PHONE,EMAIL
                 INTO ENAME,PHONEE,EMAILL
                 FROM PRO_TEST
                 WHERE EMP_ID = EID;
           EXIT;
        ELSIF((EID = E.EMP_ID) AND (E.PHONE IS NULL)) THEN
          SELECT EMP_NAME, NVL(PHONE, '번호없음'),EMAIL
                 INTO ENAME,PHONEE,EMAILL
                 FROM PRO_TEST
                 WHERE EMP_ID = EID;
          EXIT;
       END IF;
     END LOOP;

END;
/

DECLARE
   ENAME PRO_TEST.EMP_NAME%TYPE;
   PHONEE PRO_TEST.PHONE%TYPE;
   EMAILL PRO_TEST.EMAIL%TYPE;
BEGIN
  PHONE_INFORMATION('&사번',ENAME,PHONEE,EMAILL);

  IF(PHONEE = '번호없음') THEN
      DBMS_OUTPUT.PUT_LINE('사원 이름 : ' || ENAME);
      DBMS_OUTPUT.PUT_LINE('핸드폰 번호 : ' || PHONEE);
      DBMS_OUTPUT.PUT_LINE('이메일 : ' || EMAILL);
  ELSE
      DBMS_OUTPUT.PUT_LINE('사원 이름 : ' || ENAME);
      DBMS_OUTPUT.PUT_LINE('핸드폰 번호 : ' || PHONEE);
  END IF;

END;
/

-- 강사님 풀이
CREATE OR REPLACE PROCEDURE SELECT_PHONE(EID IN PRO_TEST.EMP_ID%TYPE
                                         ,PT OUT PRO_TEST%ROWTYPE) -- 한 행 정보 보내기

IS

BEGIN
   --한 행만 조회 및 반환
   SELECT *
   INTO PT
   FROM PRO_TEST
   WHERE EMP_ID = EID;
END;
/

--위에서 만든 프로시저로 조회한 정보를 통해 조건처리해보기

DECLARE
  PT PRO_TEST%ROWTYPE; -- 한 행 정보담을 변수 준비
BEGIN
  --프로시저 호출
  SELECT_PHONE(&사번,PT);
  --번호에 따라서 처리하기
  --번호가 없으면 번호 없음 데이터 넣고 출력하기
  IF PT.PHONE IS NULL
    THEN
      UPDATE PRO_TEST
      SET PHONE = '번호 없음'
      WHERE EMP_ID = PT.EMP_ID;
      COMMIT;

      /*
      --정보 갱신
      SELECT *
      INTO PT
      FROM PRO_TEST
      WHERE EMP_ID = PT.EMP_ID;
      */

      DBMS_OUTPUT.PUT_LINE('사원명 : ' || PT.EMP_NAME);
      DBMS_OUTPUT.PUT_LINE('핸드폰번호 : ' || PT.PHONE);
      DBMS_OUTPUT.PUT_LINE('이메일 주소 : ' || PT.EMAIL);

  ELSE
      DBMS_OUTPUT.PUT_LINE('사원명 : ' || PT.EMP_NAME);
      DBMS_OUTPUT.PUT_LINE('핸드폰번호 : ' || PT.PHONE);
  END IF;
END;
/

-----------------------------------------------------------------
/*
  FUNCTION
  프로시저와 유사하지만 실행결과를 반환 받을 수 있다.

  [표현법]
  CREATE [OR REPLACE] FUNCTION 함수명[(매개변수)]
  RETURN 자료형(반환타입)
  IS
  BEGIN
    실행부;
  END;
  /

  실행법
  함수명(전달값);
*/

CREATE OR REPLACE FUNCTION MYFUNC(STR VARCHAR2) -- 자료형만 선언 , VARCHAR2의 바이트 크기는 전달 받은 곳에서 작성
RETURN VARCHAR2
IS -- 선언부
  RESULT VARCHAR2(100); -- 변수 선언

BEGIN
  DBMS_OUTPUT.PUT_LINE('STR : ' || STR);
  RESULT := STR || '입니다';
  RETURN RESULT;
END;
/

--함수 호출
SELECT MYFUNC('저는 학생')
FROM DUAL;

--EMP_ID를 전달받아 연봉을 계산하여 출력해주는 함수 만들기
--EMPLOYEE 테이블 ROWTYPE으로 설정하여 조회결과 넣고
--함수의 반환값을 이용하여 사번,사원명,연봉 조회해보기
--함수명 SAL_CAL
--SELECT 구문을 이용하여 최종 조회

CREATE OR REPLACE FUNCTION SAL_CAL(EID EMPLOYEE.EMP_ID%TYPE)
RETURN NUMBER
IS -- 선언부
  E EMPLOYEE%ROWTYPE;
  RESULT NUMBER;
BEGIN
   SELECT *
   INTO E
   FROM EMPLOYEE
   WHERE EMP_ID = EID;

   --위 구문에서 급여 추출해서 연봉 계산 후 RESULT에 담아서 반환

   RESULT := (E.SALARY + (E.SALARY * NVL(E.BONUS,0))) * 12;

   RETURN RESULT; --결과값 반환

END;
/

SELECT EMP_ID 사번
       ,EMP_NAME 이름
       ,SAL_CAL(EMP_ID) 연봉
FROM EMPLOYEE
ORDER BY 3 DESC NULLS LAST;

SELECT *
FROM EMPLOYEE
WHERE SAL_CAL(EMP_ID) >= 50000000 -- 조건처리
ORDER BY SALARY DESC NULLS LAST;

--주민번호로 성별 반환 함수 - GENDER_FUNC
CREATE OR REPLACE FUNCTION GENDER_FUNC(EN EMPLOYEE.EMP_NO%TYPE)
RETURN VARCHAR2
IS
  E EMPLOYEE%ROWTYPE;
  GENDER VARCHAR2(20);
BEGIN
  SELECT *
  INTO E
  FROM EMPLOYEE
  WHERE EMP_NO = EN;

  IF(SUBSTR(E.EMP_NO,8,1) = '1')
    THEN GENDER := '남';
  ELSIF(SUBSTR(E.EMP_NO,8,1) = '2')
    THEN GENDER := '여';
  ELSE
    GENDER := '미확인';
  END IF;

  RETURN GENDER;

  EXCEPTION WHEN OTHERS THEN RETURN '오류발생';

END;
/

SELECT EMP_NAME
       ,GENDER_FUNC(EMP_NO)
FROM EMPLOYEE;



--사수사번으로 사수명 반환 함수 -- MANAGER_FUNC

--강사님 풀이
/*
CREATE OR REPLACE FUNCTION MANAGER_NAME(MID VARCHAR2)
RETURN VARCHAR2
IS
    RESULT VARCHAR2(20);
BEGIN
    --사수명 조회
    SELECT EMP_NAME
    INTO RESULT
    FROM EMPLOYEE
    WHERE EMP_ID = MID; --전달받은 사수사번을 사번으로 가지고 있는 사원의 이름 조회

    RETURN RESULT;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN '없음';
        WHEN OTHERS THEN RETURN '오류발생';
END;
/

SELECT EMP_NAME 사원명
      ,MANAGER_ID 사수사번
      ,MANAGER_NAME(MANAGER_ID) 사수명
FROM EMPLOYEE;
*/


CREATE OR REPLACE FUNCTION MANAGER_FUNC(MI EMPLOYEE.MANAGER_ID%TYPE)
RETURN VARCHAR2
IS
  E EMPLOYEE%ROWTYPE;
  NAME VARCHAR2(20);
BEGIN
   SELECT *
   INTO E
   FROM EMPLOYEE
   WHERE EMP_ID = MI;

   FOR EE IN (SELECT * FROM EMPLOYEE) LOOP
     IF(EE.EMP_ID = MI)
      THEN NAME := EE.EMP_NAME;
      EXIT;
     END IF;
   END LOOP;

   RETURN NAME;

END;
/

SELECT EMP_NAME,MANAGER_ID,MANAGER_FUNC(MANAGER_ID)
FROM EMPLOYEE;