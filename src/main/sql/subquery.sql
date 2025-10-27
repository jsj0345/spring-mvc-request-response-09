-- SELECT(KH계정)_SUBQUERY

/*
   <SUBQUERY 서브쿼리>
   하나의 주된 SQL문 안에 포함된 또 하나의 SELECT 구문
   메인 SQL문을 위해 보조 역할로 사용된다.
   사용될 수 있는 구문) SELECT, INSERT, CREATE, UPDATE ...

*/

--노옹철 사원과 같은 부서인 사원들
--1)노옹철 사원의 부서 알아오기
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- D9

--2) D9 부서코드를 가진 사원들 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--위 구문을 하나로 합치기
SELECT EMP_NAME, DEPT_CODE -- 메인 코드를 먼저 짜야함
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '노옹철');

--전체 사원의 평균 급여보다 많은 급여를 받는 사원들의 사번, 이름, 직급코드 조회

--1) 전체 사원의 평균 급여
SELECT ROUND(AVG(SALARY))
FROM EMPLOYEE; -- 3047663

--2) 위에서 알아온 평균 급여를 조건에 넣어주기
SELECT EMP_ID
       ,EMP_NAME
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > 3047663;

--위 코드를 합쳐주기 (메인이 되는 구문을 먼저 작성, 그 후에 조건을 생각하기)
SELECT EMP_ID
       ,EMP_NAME
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT ROUND(AVG(SALARY))
                FROM EMPLOYEE);

/*
   서브쿼리 구분
   서브쿼리의 수행 결과값이 몇행 몇열이냐에 따라서 분류된다.

   -단일행 단일열 서브쿼리 : 서브쿼리를 수행한 결과값이 1개일때 (한칸의 컬럼값으로 조회될때)
   -다중행 단일열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러행이고 하나의 열일때
   -단일행 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 하나의 행에 여러 컬럼으로 나뉠때
   -다중행 다중열 서브쿼리 : 서브쿼리를 수행한 결과값이 여러행과 여러 컬럼으로 나뉠때

   *서브쿼리를 수행한 결과 유형에 따라서 사용가능한 연산자가 다르다.
*/

/*
    1. 단일행(단일열) 서브쿼리
    서브쿼리의 조회 결과가 오로지 1개일때
    일반 연산자 사용 가능 (=, !=, >=, <=, <, >)
*/

--전 직원의 평균급여보다 더 적게 받는 사원들의 사원명 직급코드 급여 조회
SELECT EMP_NAME
       ,JOB_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT AVG(SALARY)
                FROM EMPLOYEE);

--최저 급여를 받는 사원의 사번, 사원명, 직급코드, 급여, 입사일 조회
SELECT EMP_ID
       ,EMP_NAME
       ,JOB_CODE
       ,SALARY
       ,HIRE_DATE
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                 FROM EMPLOYEE);

-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서코드, 급여 조회
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '노옹철');

-- 노옹철 사원의 급여보다 더 많이 받는 사원들의 사번, 이름, 부서명, 급여 조회

--ORACLE
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,SALARY
FROM EMPLOYEE E, DEPARTMENT D
WHERE SALARY > (SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '노옹철')
AND E.DEPT_CODE = D.DEPT_ID;

--ANSI
SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE SALARY > (SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME = '노옹철');

--부서별 급여합이 가장 큰 부서 하나만 부서코드 부서명 급여합 조회

--ORACLE
SELECT DEPT_ID
       ,DEPT_TITLE
       ,SUM(SALARY)
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID
GROUP BY DEPT_ID, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

--ANSI
SELECT DEPT_CODE, DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
GROUP BY DEPT_CODE, DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

/*

  2.다중행 단일열 서브쿼리
  서브쿼리의 조회 결과값이 여러 행일 경우
  - IN (10,20,30) 서브쿼리 : 여러개의 결과값 중에서 하나라도 일치하는것이 있다면 /NOT IN : 없다면
  - > ANY (10, 20, 30) 서브쿼리 : 여러개의 결과값 중에서 하나라도 클 경우 (여러개 결과값중 가장 작은값 보다 클경우)
  - < ANY (10, 20, 30) 서브쿼리 : 여러개의 결과값 중에서 하나라도 작을 경우 (여러개의 결과값중 가장 큰값보다 작을 경우)
  - > ALL : 여러개의 결과값이 모든 값보다 클 경우 (가장 큰 값보다 클 경우)
  - < ALL : 여러개의 결과값의 모든 값보다 작을 경우 (가장 작은 값보다 작을 경우)

*/

--각 부서별 최고 급여를 받는 사원의 이름 직급코드 급여 조회
--1) 각 부서 별 최고 급여 조회 (다중행, 단일열)
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

--2) 위 급여를 받는 사원들 정보 조회
SELECT EMP_NAME
       ,JOB_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY IN (3660000,
                 2490000,
                 3760000,
                 3900000,
                 2550000,
                 8000000,
                 2890000);

--3) 위 두 구문을 합치기
SELECT EMP_NAME
       ,JOB_CODE
       ,SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                 FROM EMPLOYEE
                 GROUP BY DEPT_CODE);

--선동일 또는 유재식 사원과 같은 부서인 사원들을 조회(사원명, 부서코드, 급여)

SELECT EMP_NAME
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME IN ('선동일', '유재식'));


--이오리 또는 하동운 사원과 같은 직급인 사원들 조회(사원명,직급코드,부서코드,급여)
SELECT EMP_NAME
       ,JOB_CODE
       ,DEPT_CODE
       ,SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('이오리', '하동운'));

--대리 직급임에도 과장 직급의 급여보다 많이 받는 사원들 조회(사번, 사원명, 직급명, 급여)

--과장 직급 급여 알아오기
SELECT JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '과장';

SELECT EMP_ID, EMP_NAME, JOB_NAME ,SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '대리'
AND SALARY > ANY (2200000, 2500000, 3760000);

-- 합치기
--ORACLE
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY
                  FROM EMPLOYEE E, JOB J
                  WHERE E.JOB_CODE = J.JOB_CODE
                  AND JOB_NAME = '과장');

--ANSI
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY
                  FROM EMPLOYEE E, JOB J
                  WHERE E.JOB_CODE = J.JOB_CODE
                  AND JOB_NAME = '과장');


--과장 직급임에도 모든 차장 직급의 급여보다 많이 받는 직원 조회(사번, 이름, 직급명, 급여)
SELECT JOB_NAME
       ,SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '차장'; -- 280, 155,249,248

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL(2800000, 1550000, 2490000, 2480000);

--합치기
--ORACLE
SELECT EMP_ID,EMP_NAME,JOB_NAME
       ,SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE E, JOB J
                    WHERE E.JOB_CODE = J.JOB_CODE
                    AND JOB_NAME = '차장');

--ANSI
SELECT EMP_ID,EMP_NAME,JOB_NAME
       ,SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE E, JOB J
                    WHERE E.JOB_CODE = J.JOB_CODE
                    AND JOB_NAME = '차장');


/*
    3. (단일행) 다중열 서브쿼리

    서브쿼리 조회 결과가 한 행이지만 컬럼 개수가 여러개로 조회될때(다중열)
*/
--하이유 사원과 같은 부서코드, 직급코드에 해당하는 사원들 조회(사원명, 부서코드, 직급코드, 고용일)

--1) 하이유 사원의 부서코드와 직급 코드 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '하이유';

--2) 부서코드 D5, 직급코드 J5인 사원들 조회
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
AND JOB_CODE = 'J5';

--합치기
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '하이유')
AND JOB_CODE = (SELECT JOB_CODE
                FROM EMPLOYEE
                WHERE EMP_NAME = '하이유');

--위 구문의 조건을 하나로 처리하기 (다중열 처리)
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '하이유'); --나열한 자료 개수와 형태를 잘 맞춰줘야함!


--박나라 사원과 같은 직급코드, 같은 사수사번을 가진 사원들의 사번,이름,직급코드,사수사번 조회
SELECT EMP_ID
       ,EMP_NAME
       ,JOB_CODE
       ,NVL(MANAGER_ID, '사수 없음')
FROM EMPLOYEE
WHERE (JOB_CODE,MANAGER_ID) = (SELECT JOB_CODE,MANAGER_ID -- 개수 잘 맞춰줘야함!
                            FROM EMPLOYEE
                            WHERE EMP_NAME = '박나라'
                            );

/*
   4. 다중행 다중열 서브쿼리
   서브쿼리의 조회 결과가 다중행, 다중열인 경우
*/
-- 각 직급별 최소 급여를 받는 사원들 조회(사번, 사원명, 직급코드, 급여)

--1) 직급별 최소 급여 조회
SELECT MIN(SALARY), JOB_CODE
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY 2;

--위 조회 결과와 일치하는 사원들 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE,MIN(SALARY)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);

--각 부서별 최고급여를 받는 사원들 조회(사번, 사원명, 부서코드, 급여)
SELECT DEPT_CODE, MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE;

SELECT EMP_ID
       ,EMP_NAME
       ,NVL(DEPT_CODE, '부서 없음')
       ,SALARY
FROM EMPLOYEE
WHERE (NVL(DEPT_CODE, '부서 없음'), SALARY) IN (SELECT NVL(DEPT_CODE, '부서 없음'), MAX(SALARY)
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE);


---------------------------------------------------------------------------------------------------------------
/*
    5. 인라인뷰 (INLINE VIEW)
    FROM절에서 서브쿼리를 제시하여
    조회된 결과 (RESULT SET)을 테이블처럼 이용하는 구문
*/

--보너스 포함 연봉이 3000만원 이상인 사원들의 사번, 이름, 보너스포함연봉, 부서코드 조회

SELECT EMP_ID 사번
       ,EMP_NAME 사원명
       ,(SALARY + (SALARY*NVL(BONUS,0))*12) "보너스포함연봉"
       ,NVL(DEPT_CODE, '부서없음') 부서
FROM EMPLOYEE
WHERE (SALARY + (SALARY*NVL(BONUS,0))*12) >= 30000000;

--조건을 넣기 전 보너스포함 연봉 계산 조회 결과를 인라인뷰로 작성하기
SELECT 사번,사원명,보너스포함연봉,부서
FROM (SELECT EMP_ID 사번
       ,EMP_NAME 사원명
       ,(SALARY + (SALARY*NVL(BONUS,0))*12) "보너스포함연봉"
       ,NVL(DEPT_CODE, '부서없음') 부서 -- 데이터를 테이블처럼 씀
        FROM EMPLOYEE)
WHERE 보너스포함연봉 >= 30000000; --인라인뷰에서 작성한 별칭을 컬럼명으로 이용 가능

--인라인뷰가 주로 사용되는 예시
--TOP-N 분석 : 데이터베이스상에 있는 자료중 최상위 N개의 자료를 보기 위해 사용하는 기능

--전 직원들 중 급여가 가장 높은 상위 5명 조회(순위, 사원명,급여)
--ROWNUM : 오라클에서 제공하는 가상컬럼으로 1부터 순위를 부여해준다.
SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC; -- 실행순서가 FROM - SELECT - ORDER BY 순이기 때문에
--ROWNUM에서 순번을 먼저 부여한 뒤 정렬되어 ROWNUM의 순서가 섞인다.
--해결방법 : 순번을 부여하기 전에 정렬된 조회구문을 인라인뷰로 사용하여 정렬 후 순번 부여하기

--급여 내림차순 정렬 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

--위 구문을 인라인 뷰로 사용
SELECT ROWNUM,EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY
      FROM EMPLOYEE
      ORDER BY SALARY DESC) -- 여기서 급여를 기준으로 내림차순을 하고 이후에 ROWNUM을 추가하면 급여 높은순 -> 낮은순으로 숫자가 매겨짐.
WHERE ROWNUM <= 5;

--각 부서별 평균 급여가 높은 3개 부서의 부서코드, 평균급여 조회하기
SELECT ROWNUM
       ,DEPT_CODE
       ,"평균 급여"
FROM (SELECT DEPT_CODE
             ,AVG(SALARY) "평균 급여"
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
      ORDER BY "평균 급여" DESC)
WHERE ROWNUM <= 3;

--가장 최근에 입사한 사원 5명 조회 (사원명, 급여, 입사일, 순번)
SELECT EMP_NAME
       SALARY,
       HIRE_DATE,
       ROWNUM
FROM (SELECT EMP_NAME
             ,SALARY
             ,HIRE_DATE
      FROM EMPLOYEE
      ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <= 5;

--인라인뷰에 별칭부여해서 조회하기
SELECT ROWNUM,A.* -- 별칭.*을 이용해서 인라인뷰 컬럼 모두 조회가능
FROM(SELECT EMP_NAME, SALARY, HIRE_DATE
    FROM EMPLOYEE
    ORDER BY HIRE_DATE DESC) A; --인라인뷰 별칭부여

/*
    6. 순위 매기는 함수
    RANK() OVER(정렬기준)
    DENSE_RANK() OVER(정렬기준)

    -RANK() OVER(정렬기준) : 공동순위가 있다면 그 이후 번호가 순위가 된다 EX)공동 1위 3명이면 다음 순위는 4위
    -DENSE_RANK() OVER(정렬기준) : 공동순위가 있다면 그 다음순위를 이어서 처리 EX) 공동1위 3명이여도 다음 순위 2위

    정렬 기준 : ORDER BY 절 (정렬기준컬럼, 오름차순/내림차순)

    **RANK OVER 함수는 SELECT 절에서만 사용가능
*/

--사원들의 급여가 높은 순서대로 사원명 급여 순위 조회

--RANK() OVER

SELECT EMP_NAME
       ,SALARY
       ,RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE; -- 19위가 공동이기때문에 다음 순위가 21로 표기

--DENSE_RANK() OVER
SELECT EMP_NAME
      ,SALARY
      ,DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE;  -- 공동 19위지만 다음순위 20으로 표기

--위 구문을 10위까지만 표기해보자. RANK와 DENSE 둘다 해보기

SELECT *
FROM (SELECT EMP_NAME
       ,SALARY
       ,RANK() OVER(ORDER BY SALARY DESC) 순위
      FROM EMPLOYEE)
WHERE 순위 <=10;

SELECT *
FROM(SELECT EMP_NAME
            ,SALARY
            ,DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위
     FROM EMPLOYEE)
WHERE 순위 <= 10;

-- WITH : 서브쿼리를 선언해놓고 사용 (해당 SELECT절에서 사용가능하다)
-- 서브쿼리 구문이 길어진다면 해당 구문을 미리 선언해놓고 테이블처럼 사용 가능하다.
--12번
WITH SAL_TOTAL AS (
                      SELECT NVL(DEPT_TITLE, '부서미지정') 부서명,
                             SUM(SALARY) 급여합
                      FROM EMPLOYEE
                      LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                      GROUP BY DEPT_TITLE
                  )
SELECT *
FROM SAL_TOTAL
                WHERE 급여합 > (
                  SELECT SUM(급여합) * 0.2
                  FROM SAL_TOTAL
                );

-- 실습 13번
-- 부서 명과 부서 별 급여 합계 조회
-- WITH를 이용하여 급여 합과 급여 평균 조회
-- WITH는 여러개 선언 가능 ,로 구분지어 처리
WITH SAL_TOTAL AS (SELECT SUM(SALARY)
                    FROM EMPLOYEE),
     SAL_AVG AS (SELECT AVG(SALARY)
                 FROM EMPLOYEE)

SELECT *
FROM SAL_TOTAL
UNION
SELECT *
FROM SAL_AVG;