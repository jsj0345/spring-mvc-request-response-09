/*
   KH_연습문제 (1 ~ 25번)
   KH_JOIN및서브쿼리_문제 (1~12번)
*/

-- 1. JOB 테이블의 모든 정보 조회
SELECT *
FROM JOB; -- JOB 테이블에 있는 모든 열들 조회

-- 2. JOB 테이블의 직급 이름 조회
SELECT JOB_NAME
FROM JOB;

-- 3. DEPARTMENT 테이블의 모든 정보 조회
SELECT *
FROM DEPARTMENT;

-- 4. EMPLOYEE 테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM EMPLOYEE;

-- 5. EMPLOYEE 테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM EMPLOYEE;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
SELECT EMP_NAME
       ,SALARY*12
       ,(SALARY + (SALARY * NVL(BONUS,0)))*12
       ,((SALARY + (SALARY * NVL(BONUS,0)))*12 - (SALARY*12*0.03))
FROM EMPLOYEE; -- NVL로 BONUS가 NULL인 행들을 BOUNS -> 0으로 만듬.

-- 7. EMPLOYEE 테이블에서 SAL_LEVEL이 S1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME
       ,SALARY
       ,HIRE_DATE
       ,PHONE
FROM EMPLOYEE
WHERE SAL_LEVEL = 'S1';
-- WHERE 절을 이용해서 SAL_LEVEL이 S1인 행만 나오게함.

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인
-- 사원의 이름, 월급, 실수령액, 고용일 조회

SELECT EMP_NAME
       ,SALARY
       ,((SALARY + (SALARY * NVL(BONUS,0)))*12 - (SALARY*12*0.03))
       ,HIRE_DATE
FROM EMPLOYEE
WHERE ((SALARY + (SALARY * NVL(BONUS,0)))*12 - (SALARY*12*0.03)) >= 50000000;

-- 9. EMPLOYEE 테이블에 월급이 4000000 이상이고
-- JOB_CODE가 J2인 사원의 전체 내용 조회

SELECT *
FROM EMPLOYEE
WHERE SALARY >= 4000000
AND JOB_CODE = 'J2';

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중
-- 고용일이 02년 1월 1일 보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME
       ,DEPT_CODE
       ,HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9', 'D5')
AND HIRE_DATE < TO_DATE('020101','YYMMDD');

-- 11. EMPLOYEE 테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의
-- 전체 내용을 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN TO_DATE('900101', 'RRMMDD') AND TO_DATE('010101','YYMMDD');

-- 12. EMPLOYEE 테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME
       ,NVL(PHONE, '전화번호 없음')
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%'
OR PHONE IS NULL;

--> 만약에 WHERE PHONE NOT LIKE '010%'로만 조건을 걸어두면
--> NULL은 안나옴 따라서 조건을 하나 더 붙여준다.
--> NVL을 이용해서 NULL 나오게 하지말고 전화번호 없음 문구를 나오게하자.

-- 14. EMPLOYEE 테이블에서 메일주소 '_'의 앞이 4자이면서
-- DEPT_CODE가 D9 또는 D6이고
-- 고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회

SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D9','D6')
AND EMAIL LIKE '____\_%' ESCAPE '\'
AND SALARY >= 2700000
--AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01';
AND HIRE_DATE BETWEEN TO_DATE('900101','RRMMDD') AND TO_DATE('011201','RRMMDD');

-->HIRE_DATE는 DATE타입 '90/01/01'은 문자열 타입이지만 자동형변환 연산처리가 된다.
-->00년은 존재하지않아서 01부터하고
-->00~49는 RR로 입력하면 1900년대가아닌 2000년대로 받아들임 50~99는 90년대로 받아들임

-- 15. EMPLOYEE 테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME
       ,SUBSTR(EMP_NO,1,2) "생년"
       ,SUBSTR(EMP_NO,3,2) "생월"
       ,SUBSTR(EMP_NO,5,2) "생일"
FROM EMPLOYEE;

-- 16. EMPLOYEE 테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME
       ,RPAD(SUBSTR(EMP_NO,1,7),14,'*')
FROM EMPLOYEE;

-- 17. EMPLOYEE 테이블에서 사원명, 입사일 - 오늘, 오늘 - 입사일 조회
-- (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)

SELECT EMP_NAME
       , FLOOR(ABS(HIRE_DATE - SYSDATE)) "근무일수1"
       , FLOOR(SYSDATE - HIRE_DATE) "근무일수2"
FROM EMPLOYEE;

-- 18. EMPLOYEE 테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID,2) != 0;

-- 19. EMPLOYEE 테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE ((SYSDATE - HIRE_DATE) / 365) >= 20;

-- 20. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME
       ,TO_CHAR(SALARY, 'L9,000,000')
FROM EMPLOYEE;

-- 21. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
-- (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며
-- 나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)

SELECT EMP_NAME
       ,DEPT_CODE
       ,SUBSTR(EMP_NO,1,2) || '년' || SUBSTR(EMP_NO,3,2) || '월' || SUBSTR(EMP_NO,5,2) || '일' "생년월일"
       ,FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6), 'RRMMDD')) /365)  "나이(만)"
FROM EMPLOYEE;

-- 22. EMPLOYEE 테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되
-- D5면 총무부, D6면 기획부, D9면 영업부로 처리
-- (단, 부서코드 오름차순으로 정렬)

SELECT E.*
      ,DECODE(DEPT_CODE,'D5','총무부','D6','기획부','D9','영업부')
FROM EMPLOYEE E
WHERE DEPT_CODE IN ('D5','D6','D9')
ORDER BY DEPT_CODE;

-- 23. EMPLOYEE 테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리
-- 주민번호 앞자리와 뒷자리의 합 조회

SELECT EMP_NAME "사원명"
       ,SUBSTR(EMP_NO,1,6) "주민번호 앞자리"
       ,SUBSTR(EMP_NO,8) "주민번호 뒷자리"
       ,(SUBSTR(EMP_NO,1,6)) + SUBSTR(EMP_NO,8) "앞자리와 뒷자리 합"
FROM EMPLOYEE
WHERE EMP_ID = '201';

-- 24. EMPLOYEE 테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회
SELECT SUM((SALARY + (SALARY * BONUS)) *12) "보너스 포함 연봉"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

-- 25. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고
-- 각 년도별 입사 인원수 조회
-- 전체 직원 수, 2001년, 2002년, 2003년, 2004년

/*
SELECT EXTRACT(YEAR FROM HIRE_DATE)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';
*/

--COUNT(CASE WHEN SALARY >= 3000000 THEN 1 END)

SELECT COUNT(*) "전체 인원"
       ,COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2001 THEN 1 END) "2001년 입사 인원"
       ,COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2002 THEN 1 END) "2002년 입사 인원"
       ,COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2003 THEN 1 END) "2003년 입사 인원"
       ,COUNT(CASE WHEN EXTRACT(YEAR FROM HIRE_DATE) = 2004 THEN 1 END) "2004년 입사 인원"
FROM EMPLOYEE;

SELECT EXTRACT(YEAR FROM HIRE_DATE) "입사년도" ,COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
HAVING EXTRACT(YEAR FROM HIRE_DATE) IN ('2001','2002','2003','2004');

/*
   KH_JOIN및서브쿼리_문제 (1~13번)
*/

-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과 주민번호, 부서 명, 직급 조회

--ANSI
SELECT EMP_NAME
       ,EMP_NO
       ,DEPT_TITLE
       ,JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE EMP_NAME LIKE '전%'
AND SUBSTR(EMP_NO,8,1) = '2'
AND EMP_NO LIKE '7%';

--ORACLE
SELECT EMP_NAME
       ,EMP_NO
       ,DEPT_TITLE
       ,JOB_NAME
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE E.DEPT_CODE = D.DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EMP_NAME LIKE '전%'
AND SUBSTR(EMP_NO,8,1) = '2'
AND EMP_NO LIKE '7%';

-- 2. 나이 상 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회

--ANSI
SELECT E.*
FROM (
            SELECT EMP_ID
                   ,EMP_NAME
                   ,FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD')) / 365) "나이"
                   ,DEPT_TITLE
                   ,JOB_NAME
                   ,RANK() OVER(ORDER BY FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD')) / 365) ) "순위"
            FROM EMPLOYEE E
            JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
            JOIN JOB J ON E.JOB_CODE = J.JOB_CODE

     ) E
WHERE 순위 = 1;

--ORACLE
SELECT E.*
FROM (
            SELECT EMP_ID
                   ,EMP_NAME
                   ,FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD')) / 365) "나이"
                   ,DEPT_TITLE
                   ,JOB_NAME
                   ,RANK() OVER(ORDER BY FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD')) / 365) ) "순위"
            FROM EMPLOYEE E, DEPARTMENT D, JOB J
            WHERE E.DEPT_CODE = D.DEPT_ID
            AND E.JOB_CODE = J.JOB_CODE
            --JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
            --JOIN JOB J ON E.JOB_CODE = J.JOB_CODE

     ) E
WHERE 순위 = 1;

--ROWNUM
SELECT ROWNUM, E.*
FROM (
            SELECT EMP_ID
                   ,EMP_NAME
                   ,FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD')) / 365) "나이"
                   ,DEPT_TITLE
                   ,JOB_NAME
            FROM EMPLOYEE E
            JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
            JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
            ORDER BY "나이" ASC

     ) E
WHERE ROWNUM = 1;

SELECT ROWNUM, E.*
FROM (
            SELECT EMP_ID
                   ,EMP_NAME
                   ,FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO,1,6),'RRMMDD')) / 365) "나이"
                   ,DEPT_TITLE
                   ,JOB_NAME
            FROM EMPLOYEE E, DEPARTMENT D, JOB J
            WHERE E.DEPT_CODE = D.DEPT_ID
            AND E.JOB_CODE = J.JOB_CODE
            ORDER BY "나이" ASC

     ) E
WHERE ROWNUM = 1;

-- 3. 이름에 ‘형’이 들어가는 사원의 사원 코드, 사원 명, 직급 명 조회

--ANSI
SELECT EMP_ID
       ,EMP_NAME
       ,JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE EMP_NAME LIKE '%형%';

--ORACLE
SELECT EMP_ID
       ,EMP_NAME
       ,JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND EMP_NAME LIKE '%형%';

-- 4. 부서코드가 D5이거나 D6인 사원의 사원 명, 직급 명, 부서 코드, 부서 명 조회

--ANSI
SELECT EMP_NAME
       ,JOB_NAME
       ,DEPT_CODE
       ,DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
WHERE E.DEPT_CODE IN ('D5', 'D6');

--ORACLE
SELECT EMP_NAME
       ,JOB_NAME
       ,DEPT_CODE
       ,DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D, JOB J
WHERE D.DEPT_ID = E.DEPT_CODE
AND J.JOB_CODE = E.JOB_CODE
AND E.DEPT_CODE IN ('D5', 'D6');

-- 5. 보너스를 받는 사원의 사원 명, 부서 명, 지역 명 조회

--ANSI
SELECT EMP_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE BONUS IS NOT NULL;

--ORACLE
SELECT EMP_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND BONUS IS NOT NULL;

-- 6. 사원 명, 직급 명, 부서 명, 지역 명 조회

--ANSI
SELECT EMP_NAME
       ,JOB_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE;

--ORACLE
SELECT EMP_NAME
       ,JOB_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
FROM EMPLOYEE E, JOB J, DEPARTMENT D, LOCATION L
WHERE E.JOB_CODE = J.JOB_CODE
AND E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE;

-- 7. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회

--ANSI
SELECT EMP_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
       ,NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE N.NATIONAL_NAME IN ('한국', '일본');

--ORACLE
SELECT EMP_NAME
       ,DEPT_TITLE
       ,LOCAL_NAME
       ,NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
WHERE E.DEPT_CODE = D.DEPT_ID
AND D.LOCATION_ID = L.LOCAL_CODE
AND L.NATIONAL_CODE = N.NATIONAL_CODE
AND N.NATIONAL_NAME IN ('한국', '일본');

-- 8. 한 사원과 같은 부서에서 일하는 사원의 이름 조회

--ANSI
SELECT E.EMP_NAME
       ,E.DEPT_CODE
       ,EE.EMP_NAME
FROM EMPLOYEE E
JOIN EMPLOYEE EE ON E.DEPT_CODE = EE.DEPT_CODE
WHERE E.EMP_NAME != EE.EMP_NAME
ORDER BY E.EMP_NAME ASC;

--ORACLE
SELECT E.EMP_NAME
       ,E.DEPT_CODE
       ,EE.EMP_NAME
FROM EMPLOYEE E, EMPLOYEE EE
WHERE E.DEPT_CODE = EE.DEPT_CODE
AND E.EMP_NAME != EE.EMP_NAME
ORDER BY E.EMP_NAME ASC;

-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급 명, 급여 조회(NVL 이용)

--ANSI
SELECT EMP_NAME
       ,JOB_NAME
       ,SALARY
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.JOB_CODE IN ('J4','J7');

--ORACLE
SELECT EMP_NAME
       ,JOB_NAME
       ,SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND E.JOB_CODE IN ('J4', 'J7');

-- 10. 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서 명, 직급, 입사일, 순위 조회

--ANSI
SELECT ROWNUM , E.*
FROM (SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
        FROM EMPLOYEE E
        JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
        JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
        ORDER BY ((SALARY + (SALARY * NVL(BONUS,0))) * 12) DESC) E
WHERE ROWNUM <= 5;

--ORACLE
SELECT ROWNUM , E.*
FROM (SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
       FROM EMPLOYEE E, DEPARTMENT D, JOB J
       WHERE E.DEPT_CODE = D.DEPT_ID
       AND E.JOB_CODE = J.JOB_CODE
       ORDER BY ((SALARY + (SALARY * NVL(BONUS,0))) * 12) DESC) E
WHERE ROWNUM <=5;

--RANK() OVER 적용

--ANSI
SELECT E.*
FROM (SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
       ,RANK() OVER(ORDER BY ((SALARY + (SALARY * NVL(BONUS,0))) * 12) DESC) "순위"
        FROM EMPLOYEE E
        JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
        JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
        ) E
WHERE 순위<=5;

--ORACLE
SELECT E.*
FROM (SELECT EMP_ID
       ,EMP_NAME
       ,DEPT_TITLE
       ,JOB_NAME
       ,HIRE_DATE
       ,RANK() OVER(ORDER BY ((SALARY + (SALARY * NVL(BONUS,0))) * 12) DESC) "순위"
       FROM EMPLOYEE E, DEPARTMENT D, JOB J
       WHERE E.DEPT_CODE = D.DEPT_ID
       AND E.JOB_CODE = J.JOB_CODE
       ) E
WHERE 순위<=5;

-- 11. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회

-- 11-1. JOIN과 HAVING 사용
SELECT DEPT_TITLE
       ,SUM(SALARY)
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY) *0.2
                        FROM EMPLOYEE);

-- 11-2. 인라인 뷰 사용

SELECT *
FROM ( SELECT DEPT_TITLE
       ,SUM(SALARY)
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) > (SELECT SUM(SALARY) *0.2
                        FROM EMPLOYEE) );


-- 11-3. WITH 사용
WITH SAL AS ( SELECT *
        FROM ( SELECT DEPT_TITLE
       ,SUM(SALARY)
        FROM EMPLOYEE E
        JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
        GROUP BY DEPT_TITLE
        HAVING SUM(SALARY) > (SELECT SUM(SALARY) *0.2
                                FROM EMPLOYEE) )
)

SELECT *
FROM SAL;

-- 12. 부서 명과 부서 별 급여 합계 조회

--JOIN과 GROUP BY
SELECT NVL(DEPT_TITLE,'X') "부서명"
       ,SUM(SALARY) "부서 별 급여 합계"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY DEPT_TITLE;

--인라인 뷰
SELECT *
FROM (SELECT NVL(DEPT_TITLE,'X') "부서명"
       ,SUM(SALARY) "부서 별 급여 합계"
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID(+)
GROUP BY DEPT_TITLE );

--WITH

WITH SAL_SUM AS ( SELECT *
                    FROM (SELECT NVL(DEPT_TITLE,'X') "부서명"
                           ,SUM(SALARY) "부서 별 급여 합계"
                    FROM EMPLOYEE E
                    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID(+)
                    GROUP BY DEPT_TITLE )  )

SELECT *
FROM SAL_SUM;

-- 13. WITH를 이용하여 급여 합과 급여 평균 조회
WITH SAL AS (
                SELECT SUM(SALARY), AVG(SALARY)
                FROM EMPLOYEE
            )
SELECT *
FROM SAL;