/*
   -- 파일명 : 04_SELECT(KH계정)_JOIN문

   <JOIN>
   두개 이상의 테이블에서 데이터를 같이 조회하고자 할 때 사용하는 구문 - SELECT
   조회 결과는 하나의 결과 집합(RESULT SET)으로 나온다.

   JOIN을 사용하는 이유
   관계형 데이터베이스에서는 최소한의 데이터로 각각의 테이블에 데이터를 보관하고 있다.
   사원 정보는 사원 테이블, 직급 정보는 직급 테이블 등등 - 중복 데이터 최소화
   -JOIN 구문을 이용하여 서로 다른 테이블간의 관계를 맺어 데이터를 같이 조회하는 목적
   -JOIN 구문을 사용할 땐 연관된 데이터를 이용하여 관계를 맺고 조회한다.

   문법상 분류 : JOIN은 크게 오라클 전용, ANSI(미국 국립 표준협회) 구문으로 나뉘어진다.

   오라클 전용구문                 |       ANSI표준구문(오라클+다른DBMS)
   =================================================================
       등가조인(EQUAL JOIN)       |       내부조인(INNER JOIN -> JOIN USING/ON)
   ------------------------------------------------------------------------
   포괄조인                        |       외부조인(OUTER JOIN -> JOIN USING)
   LEFT OUTER JOIN               |       왼쪽 외부조인 (LEFT OUTER JOIN)
   RIGHT OUTER JOIN              |       전체 외부 조인(FULL OUTER JOIN) - 오라클구문으로는 표현X

   --------------------------------------------------------------------------------

   카테시안곱 (CARTESIAN PRODUCT)  |        교차조인(CROSS JOIN)

   ----------------------------------------------------------------------------------

                         자체 조인(SELF JOIN)
                         비 등가조인(NON EQUAL JOIN)
                         다중 조인(테이블 3개 이상)


*/

-- JOIN을 사용하지 않는 예시
-- 전체 사원들의 사번 사원명 부서코드 부서명을 조회해보기
-- 사번 사원명 부서코드를 갖는 테이블과 부서명을 갖는 테이블이 다르기때문에 각각 조회한다.

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
FROM EMPLOYEE;

SELECT DEPT_TITLE
FROM DEPARTMENT;

SELECT EMP_ID
      ,EMP_NAME
      ,DEPT_CODE
      ,DEPT_TITLE
FROM EMPLOYEE; -- EMPLOYEE 테이블에는 DEPT_TITLE이 없기 때문에 구문오류 발생

--위와같이 다른 테이블에 있는 데이터를 하나의 결과 집합으로 조회하기 위해서 JOIN 구문을 이용한다.

/*
   1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
   연결 시키고자 하는 컬럼의 값이 일치하는 행들만 조인되어 조회한다.
   -일치하지 않는 값들은 조회 결과에서 제외된다.
   -동등비교 연산자 = 를 이용해서 일치 조건 제시

   [표현법]
   등가조인(오라클 구문)
   SELECT 컬럼명 나열
   FROM 조인하고자하는 테이블명 나열
   WHERE 연결할 컬럼 = 조건 제시

   내부조인(ANSI 구문)
   SELECT 컬럼명 나열
   FROM 기준 테이블 작성
   JOIN 조인하고자 하는 테이블명 USING/ON(연결컬럼제시)
   **USING : 연결 컬럼명이 같을 경우
   **ON : 연결 컬럼명이 다를 경우

   * 오라클 구문에서 조건에 사용할 컬럼명이 같을땐 테이블명 또는 별칭을 사용해야한다.

   -- 컬럼에 담겨져있는 데이터 속성값으로 조인을 하는것임. (컬럼명은 중요하지않음!) 속성값이 뭔지?를 봐야함.

*/

-- 오라클 전용 구문
-- 사번, 사원명, 부서코드 , 부서명 조회
-- 연결 테이블(EMPLOYEE, DEPARTMENT)
-- 연결 컬럼 : EMPLOYEE - DEPT_CODE / DEPARTMENT - DEPT_ID

SELECT EMP_ID
      ,EMP_NAME
      ,DEPT_CODE
      ,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
--사원정보중 DEPT_CODE가 NULL인 사원의 데이터는 조회하지 않는다.
--DEPARTMENT 테이블의 DEPT_ID 컬럼에 NULL에 대한 정보가 없기 때문에 일치하는 데이터가 없어서 조회되지 않음.

--전체사원들의 사번, 사원명, 직급코드, 직급명을 조회
--조인할 테이블 : EMPLOYEE, JOB
--연결할 컬럼 : 두 테이블 모두 JOB_CODE

SELECT EMP_ID
       ,EMP_NAME
       ,JOB_CODE
       ,JOB_NAME
FROM EMPLOYEE, JOB
WHERE JOB_CODE = JOB_CODE; -- "COLUMN AMBIGUOUSLY DEFINED"
--컬럼명이 같은 경우 어떤 테이블에 있는 컬럼인지 명시해야한다.
--방법1. 테이블명.컬럼명
--방법2. 테이블별칭.컬럼명

--방법1. 테이블명 지정

SELECT EMP_ID
       ,EMP_NAME
       ,EMPLOYEE.JOB_CODE
       ,JOB_NAME
FROM EMPLOYEE , JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

--방법2. 테이블에 별칭 부여하고 별칭으로 지정
SELECT EMP_ID
       ,EMP_NAME
       ,E.JOB_CODE
       ,JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

--ANSI 표준 구문 이용해보기
--FROM 절엔 기준 테이블
--조인하고자 하는 테이블을 JOIN 구문과 함께 사용
--컬럼명이 같다면 USING 다르다면 ON을 이용한다.

--사번, 사원명, 부서코드, 부서명 조회
--연결 테이블(EMPLOYEE / DEPARTMENT)
--연결 컬럼(EMPLOYEE - DEPT_CODE / DEPARTMENT - DEPT_ID)

SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,DEPT_TITLE
FROM EMPLOYEE
/*INNER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 기본적으로 INNER JOIN이라 생략가능

--전체 사원들의 사번 사원명 직급코드 직급명을 조회
--조인할 테이블 EMPLOYEE, JOB
--연결 컬럼 JOB_CODE

SELECT EMP_ID
       ,EMP_NAME
       ,JOB_CODE
       ,JOB_NAME
FROM EMPLOYEE
INNER JOIN JOB USING (JOB_CODE); -- 컬럼명이 같을땐 USING 사용 가능

--컬럼명이 같지만 ON을 쓰는 경우
SELECT EMP_ID
       ,EMP_NAME
       ,EMPLOYEE.JOB_CODE
       ,JOB_NAME
FROM EMPLOYEE
INNER JOIN JOB ON(EMPLOYEE.JOB_CODE = JOB.JOB_CODE);

--조인시 추가적인 조건 부여가능
--직급이 대리인 사원들의 정보를 조회(사번, 사원명, 월급, 직급명)

--오라클전용구문
SELECT EMP_ID
       ,EMP_NAME
       ,SALARY
       ,JOB_NAME
FROM EMPLOYEE,JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE
AND JOB_NAME = '대리';

--ANSI구문
SELECT EMP_ID
       ,EMP_NAME
       ,SALARY
       ,JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

--연습문제(오라클,ANSI구문 각각 처리해보기)
--1. 부서가 인사관리부인 사원들의 사번, 사원명, 보너스 조회
--2. 부서가 총무부가 아닌 사원들의 사원명 급여 입사일 조회
--3. 보너스를 받는 사원들의 사번 사원명 보너스 부서명 조회

SELECT EMP_NO 사번
      ,EMP_NAME 사원명
      ,NVL(BONUS,0) 보너스
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';

SELECT EMP_NO 사번
      ,EMP_NAME 사원명
      ,NVL(BONUS,0) 보너스
FROM EMPLOYEE
INNER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE = '인사관리부';

--2. 부서가 총무부가 아닌 사원들의 사원명 급여 입사일 조회
-- 오라클

SELECT EMP_NAME
       ,SALARY
       ,HIRE_DATE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE != '총무부';

--ANSI

SELECT EMP_NAME
       ,SALARY
       ,HIRE_DATE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_TITLE != '총무부';

-- 3. 보너스를 받는 사원들의 사번 사원명 보너스 부서명 조회
-- 오라클
SELECT EMP_ID
       ,EMP_NAME
       ,BONUS
       ,DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;

--ANSI
SELECT EMP_ID
       ,EMP_NAME
       ,BONUS
       ,DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND BONUS IS NOT NULL;

-- 4. 아래의 두 테이블을 참고하여 부서코드 부서명 지역코드 지역명(LOCAL_NAME) 조회
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;

SELECT DEPT_ID
       ,DEPT_TITLE
       ,LOCATION_ID
       ,LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID = LOCAL_CODE;

SELECT DEPT_ID
       ,DEPT_TITLE
       ,LOCATION_ID
       ,LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

/*

    2. 포괄조인 / 외부조인(OUTER JOIN)

    테이블간의 JOIN시 조건에 일치하지 않는 행도 포함시켜 조회할 수 있다.
    단, 기준이 되는 테이블을 지정하여야한다.

    (LEFT, RIGHT, (+))

    조건에 일치하는 행 + 기준이 되는 테이블의 일치하지 않는 행까지 포함

*/

SELECT EMP_NAME
       ,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID; -- 21행 (데이터가 일치하지 않은 2명의 데이터는 조회되지 않음)

SELECT * FROM EMPLOYEE; -- 23행

--전체 사원들의 사원명, 급여, 부서명
-- 1) LEFT OUTER JOIN : 두 테이블 중 왼편에 기술된 테이블을 기준으로 JOIN처리
--                        왼편에 있는 테이블 데이터는 조건이 일치하지 않아도 전부 조회하게 된다.

--ANSI
SELECT EMP_NAME
       ,SALARY
       ,DEPT_TITLE
FROM EMPLOYEE
LEFT /*OUTER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 23행

--DEPT_CODE와 DEPT_ID가 일치하지 않아서 조회되지 않은 데이터의 DEPT_TITLE은 NULL로 조회된다.

--ORACLE (+)
SELECT EMP_NAME
       ,SALARY
       ,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+); --기준테이블의 반대 테이블 연결 컬럼 뒤에 (+) 기호를 추가한다.

--DEPT_TITLE은 없어서 못 나오니까 (+)를 붙인다는 느낌으로 받아들여도된다.

--2)RIGHT OUTER JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN 오른편에 기술된 테이블 정보 전부조회

--ANSI
SELECT EMP_NAME
       ,SALARY
       ,DEPT_TITLE
FROM EMPLOYEE
RIGHT OUTER JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

--> DEPT_TITLE 일치하지 않는 부서이름들이 나오는데 마케팅부, 국내영업부, 해외영업3부에 일치하지 않는 사원정보들은 NULL로.

--ORACLE
SELECT EMP_NAME
       ,SALARY
       ,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

--3) FULL OUTER JOIN : 두 테이블이 가진 모든 행을 조회 (오라클 구문은 없다.)
--ANSI
SELECT EMP_NAME
       ,SALARY
       ,DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- 26행

--ORACLE
SELECT EMP_NAME
       ,SALARY
       ,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+); -- 오라클구문에서 OUTER JOIN은 1개만 지정가능

--춘대학 계정으로 확인해보기
--서울에 사는 학번, 이름, 지도교수명 조회하기
--ANSI

SELECT STUDENT_NO
       ,STUDENT_NAME
       ,NVL(PROFESSOR_NAME, '지도교수 없음')
FROM TB_STUDENT
LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE SUBSTR(STUDENT_ADDRESS,1,2) ='서울';

--ORACLE

SELECT STUDENT_NO
       ,STUDENT_NAME
       ,NVL(PROFESSOR_NAME, '지도교수 없음')
FROM TB_STUDENT, TB_PROFESSOR
WHERE COACH_PROFESSOR_NO = PROFESSOR_NO(+)
AND SUBSTR(STUDENT_ADDRESS,1,2) ='서울';


--경기도 사는 학생중 지도교수가 없으면 (지도교수없음) 으로 출력되며 모든 학생정보 출력 되도록 조회

--ANSI
SELECT STUDENT_NO
    ,TB_STUDENT.DEPARTMENT_NO
    ,STUDENT_NAME
    ,STUDENT_SSN
    ,STUDENT_ADDRESS
    ,ENTRANCE_DATE
    ,ABSENCE_YN
    ,COACH_PROFESSOR_NO
    ,NVL(PROFESSOR_NAME, '지도교수 없음')
FROM TB_STUDENT
LEFT JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE SUBSTR(STUDENT_ADDRESS,1,3) = '경기도';

--ORACLE
SELECT STUDENT_NO
    ,TB_STUDENT.DEPARTMENT_NO
    ,STUDENT_NAME
    ,STUDENT_SSN
    ,STUDENT_ADDRESS
    ,ENTRANCE_DATE
    ,ABSENCE_YN
    ,COACH_PROFESSOR_NO
    ,NVL(PROFESSOR_NAME, '지도교수 없음')
FROM TB_STUDENT S, TB_PROFESSOR P
WHERE COACH_PROFESSOR_NO = PROFESSOR_NO(+)
AND SUBSTR(STUDENT_ADDRESS,1,3) = '경기도';

--테이블 별칭 부여시 별칭.*로 전체 컬럼 조회 가능
SELECT S.*
    ,NVL(PROFESSOR_NAME, '지도교수 없음')
FROM TB_STUDENT S, TB_PROFESSOR P
WHERE COACH_PROFESSOR_NO = PROFESSOR_NO(+)
AND SUBSTR(STUDENT_ADDRESS,1,3) = '경기도';

--KH계정으로
/*
    3. 카타시안 곱 / 교차조인
    모든 테이블의 각 행이 서로 매핑된 데이터가 조회된다.
    두 테이블의 행들이 모두 곱해진 행들의 조합이 출력됨
    각각 N개 M개 행을 가진 테이블들의 결과는 N*M
    모든 경우의수를 조회하여 방대한 데이터를 조회할 수 있기 때문에
    과부하 위험이 있음
    때문에 조인 구문에 조건을 부여하는것을 주의하기
*/

--사원명, 부서명
--오라클

SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
ORDER BY EMP_NAME ASC, DEPT_TITLE ASC; -- EMP_NAME 김해술은 1개인데 DEPT에 관한 정보는 9개여서 1X9 그래서 이름에 관한행은 23개 DEPT 9개 23X9 = 207


-- 오라클 조인구문의 경우 조인 조건을 넣지 않으면 모든 경우의 수를 조회해버리게 된다.

--ANSI
SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT; -- 207

/*
   4. 비 등가 조인 (NON EQUAL JOIN)  -- 많이 쓰이진 않음

   = 등호를 사용하지 않는 조인 구문 - 비교연산자를 이용한 방식

   EX) >, <, >=, <=, BETWEEN A AND B
   지정한 컬럼값이 일치하는 경우가 아닌 범위에 포함되는 경우 조회하겠다.

   등가조인 : 일치하는 경우
   비등가 조인 : 범위에 포함되는 경우

*/

--사원명, 급여
SELECT EMP_NAME
       ,SALARY
FROM EMPLOYEE;

--SAL_GRADE 테이블 조회
SELECT *
FROM SAL_GRADE;

SELECT * FROM EMPLOYEE;

--SAL_GRADE 테이블에 정의되어있는 범위를 이용하여 급여 등급 조회하기
--ORACLE
SELECT EMP_NAME
       ,SALARY
       ,S.SAL_LEVEL
FROM EMPLOYEE E, SAL_GRADE S
WHERE SALARY >= MIN_SAL
AND SALARY<=MAX_SAL
ORDER BY SALARY DESC;

--ANSI
SELECT EMP_NAME
       ,SALARY
       ,SAL_GRADE.SAL_LEVEL
FROM EMPLOYEE
--JOIN SAL_GRADE ON (SALARY >=MIN_SAL AND SALARY<=MAX_SAL);
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);
--WHERE SALARY >= MIN_SAL
--AND SALARY <= MAX_SAL;

/*
  5.자체 조인(SELF JOIN)
  같은 테이블끼리 조인하는 경우
  자체 조인의 경우 테이블에 반드시 별칭을 부여해야한다.
  같은 테이블이지만 다른 테이블인것처럼 조인하기 위해
*/

--사원정보
SELECT *
FROM EMPLOYEE;

--사수 정보
SELECT *
FROM EMPLOYEE;

--사원의 사번, 사원명, 사수의 사번, 사원명
SELECT EMP_ID "사원 사번"
       ,EMP_NAME "사원명"
       ,MANAGER_ID "사수 사번"
       ,EMP_NAME "사수명"
FROM EMPLOYEE;

--같은 EMPLOYEE 테이블에서 사원명과 사수명을 조회하려면 자체조인(SELF JOIN)을 이용해야한다.
--ORACLE
SELECT E.EMP_ID "사원 사번"
       ,E.EMP_NAME "사원명"
       ,E.MANAGER_ID "사수 사번" -- 여기서 M을 두면 사수의 또다른 사수 사번임 말이 안됨
       ,M.EMP_NAME "사수명"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID; -- 사원의 사수와 사수의 아이디가 같을때니까 당연히 E와 M으로 둬야함

--ANSI
SELECT E.EMP_ID "사원 사번"
       ,E.EMP_NAME "사원명"
       ,E.MANAGER_ID "사수 사번" -- 여기서 M을 두면 사수의 또다른 사수 사번임 말이 안됨
       ,M.EMP_NAME "사수명"
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

--사수없는 사원들의 정보도 조회해보기

--ORACLE
SELECT E.EMP_ID "사원 사번"
       ,E.EMP_NAME "사원명"
       ,E.MANAGER_ID "사수 사번" -- 여기서 M을 두면 사수의 또다른 사수 사번임 말이 안됨
       ,M.EMP_NAME "사수명"
FROM EMPLOYEE E, EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID(+);


--ANSI
SELECT E.EMP_ID "사원 사번"
       ,E.EMP_NAME "사원명"
       ,E.MANAGER_ID "사수 사번" -- 여기서 M을 두면 사수의 또다른 사수 사번임 말이 안됨
       ,M.EMP_NAME "사수명"
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

/*
   <다중 조인>

   3개이상 테이블 조인
   조인 순서가 중요

*/

-- 사원, 사번명, 부서명, 직급명

-- 오라클
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
FROM EMPLOYEE E , DEPARTMENT D, JOB J
WHERE DEPT_CODE=DEPT_ID(+) AND E.JOB_CODE = J.JOB_CODE;

--ANSI
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE);

--사원명, 부서명, 지역명 조회
--ORACLE
SELECT EMP_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID(+)
AND D.LOCATION_ID = L.LOCAL_CODE(+);

--(+)를 위,아래에 다 쓴 이유는 다음과 같다.
--먼저 E.DEPT_CODE = D.DEPT_ID(+)를 쓰면 DEPT_CODE -> NULL인 경우의수까지 다 나온다.
-- 근데 이러면 ID도 NULL이니 LOCATION_ID도 NULL이다. 따라서 (+)를 둘다 써줘야함.

--ANSI
--ANSI 구문은 조인구문의 순서에 따라서 처리되기 때문에 순서 주의하기(먼저 조인해야하는 테이블 순서 지키기)
SELECT EMP_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) -- 조인 순서를 잘 짜야함. 만약에 로케이션 먼저하면 연관성이 없어서 오류남.
LEFT JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE);