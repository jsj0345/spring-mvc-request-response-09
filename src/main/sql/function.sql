--02_SELECT(KH계정)_FUNCTION.SQL

/*
   함수 FUNCTION
   자바로 생각한다면 메소드와 같은 존재
   매개변수로 전달된 값들을 읽어 계산한 결과를 반환한다.

   단일행 함수 : N개의 값을 읽어서 N개의 값을 반환한다. (매 행마다 함수를 실행하여 결과를 반환함)
   그룹 함수 : N개의 값을 읽어서 1개의 결과를 반환(하나의 그룹별로 함수 실행 후 결과 반환)

   단일행 함수와 그룹함수는 함께 사용할 수 없음 : 결과 행 수가 다르기 때문에

   단일행 함수
   -문자열과 관련된 함수
   LENGTH/LENGTHB
   -LENGTH(문자열) : 해당 문자열의 글자수 반환
   -LENGTHB : 해당 문자열의 바이트 수 반환
   결과값은 숫자로 반환
   한글은 한글자당 3BYTE
   영문 특수문자 숫자 한글자당 1BYTE
*/

--길이:3, 바이트수:9
SELECT
    length('오라클'),
    lengthb('오라클')
FROM
    dual; -- 가상테이블 DUAL (산술연산이나 가상컬럼등 임의의 값을 조회할 때 사용하는 테이블), 한글은 한 글자당 3바이트?

--길이:6, 바이트수:6
SELECT
    length('ORACLE'),
    lengthb('ORACLE')
FROM
    dual; -- 둘다 똑같이 나옴 영어는 한 알파벳당 1바이트?

--테이블을 지정하여 함수 사용해보기
SELECT
    length(email) --"이메일 길이"
    ,
    lengthb(email) --"이메일 바이트수"
FROM
    employee;

SELECT
    length(emp_name),
    lengthb(emp_name)
FROM
    employee;

/*
   INSTR
   -INSTR (문자열, 특정문자, 찾을위치, 순번) : 문자열로부터 특정 문자의 위치값 반환
   찾을 위치, 순번은 생략가능
   결과값은 NUMBER 타입으로 반환

   찾을 위치 : 1 또는 -1
   1 - 앞에서부터 찾겠다
   -1 - 뒤에서부터 찾겠다
*/

SELECT
    instr('AABBBCCCBBAA', 'B')
FROM
    dual; -- 자바와는 다르게 인덱스 시작이 1부터임 (앞에서부터 B를 찾아 위치값 반환 순번은 1부터 시작)

SELECT
    instr('AAABBCCBBAAA', 'B', 1, 3)
FROM
    dual; -- 앞에서부터 B를 찾는데 세번째 위치한 B를 찾기

SELECT
    instr('AAABBCCBBAAA', 'C', - 1, 2)
FROM
    dual; --뒤에서부터 C를 찾아 처음 찾은 위치 반환

SELECT
    instr('ASD', 'C')
FROM
    dual; -- 찾을 수 없으니 0 반환

SELECT
    instr('ASD', 'A', 1, 3)
FROM
    dual; --A는 있지만 세번째 위치한 A는 없으니 0 반환

SELECT
    instr('ASD', 'A', 1, 0)
FROM
    dual; -- 0번위치는 있을 수 없기때문에 오류 발생

--EMPLOYEE 테이블에서 모든 사원의 이름, 이메일, 이메일중 @위치 조회하기
SELECT
    emp_name,
    instr(email, '@') "이메일 위치"
FROM
    employee;
--WHERE INSTR(EMAIL,'@') = 7; -- 함수를 조건부에 넣기

/*
  SUBSTR
  문자열로부터 특정 문자열을 추출하는 함수
  -SUBSTR(문자열,처음위치,추출할 문자 개수)

  결과값은 CHARACTER 타입으로 반환(문자열)
  추출할 문자 개수 생략 가능 (생략시 끝까지 추출)
  처음위치는 음수로 제시 가능(뒤에서부터 N번째 위치로 추출)


*/

SELECT
    substr('HELLO WORLD', 5)
FROM
    dual;

SELECT
    substr('HELLO WORLD', 1, 5)
FROM
    dual;

SELECT
    substr('HELLO WORLD', 3, 5)
FROM
    dual;

SELECT
    substr('HELLO WORLD', 15)
FROM
    dual; -- 15번 위치가 존재하지 않으니 NULL

SELECT
    substr('HELLO WORLD', - 3)
FROM
    dual; --뒤에서부터 3번째 위치부터 추출

--EMPLOYEE 테이블의 주민등록번호 데이터에서 사원명, 성별부분만 추출해보기
SELECT
    emp_name             사원명,
    substr(emp_no, 8, 1) 성별
FROM
    employee;

--EMPLOYEE 테이블에서 사원들의 이메일중 ID부분만 추출해보기 (사원명, 아이디, 이메일)
--INSTR로 자르고 싶은 위치 반환받아 해당 위치를 SUBSTR에 넣어 사용하기
SELECT
    emp_name 사원명,
    emp_id   아이디,
    substr(email,
           1,
           instr(email, '@') - 1)
FROM
    employee;

--EMPLOYEE 테이블에서 남자사원들만 조회
SELECT
    *
FROM
    employee
WHERE
    substr(emp_no, 8, 1) = '1';

--EMPLOYEE 테이블에서 여자사원들만 조회
SELECT
    *
FROM
    employee
WHERE
    NOT substr(emp_no, 8, 1) = '1';

/*
  LPAD,RPAD (문자열, 최종길이(BYTE), 덧붙일문자)
  문자열을 최종적으로 반환할 문자의 길이, 덧붙이고자 하는 문자를 붙여 최종 길이를 반환
  결과값은 CHARACTER(문자열)
  덧붙이고자 하는 문자는 생략가능 (생략시 공백이 기본값)
*/

SELECT
    lpad(email, 20)
FROM
    employee; --왼쪽에 공백문자가 총 20바이트가 되도록 채워진다.

SELECT
    lpad(email, 20, '#')
FROM
    employee; -- 기본값이 공백문자 말고 다른 문자 제시하여 채우기 가능

SELECT
    rpad(email, 20, '@')
FROM
    employee; -- 총 20바이트가 되도록 오른쪽에 @로 채워짐.

--EMPLOYEE테이블의 주민번호 데이터를 조회하는데
--성별 뒤쪽은 **로 처리하기 EX) 000101-3***

SELECT
    emp_name  사원명,
    rpad(substr(emp_no,
                1,
                instr(emp_no, '-') + 1),
         14,
         '*') "주민번호" -- RPAD(SUBSTR(EMP_NO,1,8),14,'*')
FROM
    employee;

/*
  LTRIM / RTRIM
  -LTRIM/RTRIM(문자열, 제거시킬문자)
  문자열의 왼쪽 또는 오른쪽에서 제거시키고자 하는 문자 제거 함수
  제거시킬 문자 생략시 공백 제거
  결과값은 CHARACTER(문자열)
*/

SELECT
    ltrim('    K   H    ')
FROM
    dual; --왼쪽 공백제거(제거시킬 문자 제시하지 않으면 공백이 기본값)

SELECT
    rtrim('    K   H    ')
FROM
    dual; --오른쪽 공백 제거

SELECT
    rtrim('AAABBCCC', 'C') --제시한걸 만났을때 지워줌
FROM
    dual; -- 오른쪽 C 전부 제거

SELECT
    ltrim('AAABBCCC', 'A')
FROM
    dual; -- 왼쪽 A 전부 제거

SELECT
    ltrim('123456789', '321') -- 제시한걸 만났을때 지워줌
FROM
    dual; -- 오른쪽에 있는 제시 문자열을 통째로 지우는것이 아니라 해당 제시문자랑 일치하는게 있다면 지워준다.
-- 만약 일치하는게 없으면 더이상 지워지지 않음

/*
  TRIM
  -TRIM(BOTH/LEADING/TRAILING '제거문자' FROM '문자열')
  :문자열의 양쪽,앞쪽,뒤쪽에 있는 특정 문자를 제거한 나머지 문자열 반환

  결과값은 CHARACTER 자료형(문자열)
  BOTH/LEADING/TRAILING : 생략가능 생략시 기본값 BOTH(양쪽)
*/

SELECT
    TRIM('    K   H    ')
FROM
    dual; --기본값 BOTH(양쪽) 결과 연필눌러서 봐야 확실하게 알수있음

SELECT
    TRIM(LEADING 'A' FROM 'AAABBBCCCC')
FROM
    dual; -- 왼쪽 A 제거된 결과값 반환 (마주치는 문자가 A면 제거고 아니면 이제 제거안함)

SELECT
    TRIM(LEADING 'A' FROM 'AABBCCA')
FROM
    dual;

SELECT
    TRIM(TRAILING 'C' FROM 'AAABBBBCCCC')
FROM
    dual; -- 오른쪽 C 제거된 결과값 반환

SELECT
    TRIM(TRAILING 'ABC' FROM 'AABBCCQQWWEE')
FROM
    dual; -- LTRIM/RTRIM과 같이 여러 문자열 제시 불가능

/*
  LOWER / UPPER / INITCAP

  -LOWER(문자열) : 소문자 변경
  -UPPER(문자열) : 대문자 변경
  -INITCAP(문자열) : 첫 글자만 대문자로 변경
*/

SELECT
    lower('HELLO WORLD'),
    upper('hello world'),
    initcap('hello world,bye world!!hi oracle') -- 구분되어지는 특수문자 뒤로 오는 첫글자도 대문자로 변경해줌
FROM
    dual;

/*
  CONCAT
  CONCAT(문자열1, 문자열2)
  전달된 두 문자열을 하나의 문자열로 반환
  결과는 CHARACTER(문자열)
*/

SELECT
    concat('안녕', '하세요') 인사
FROM
    dual;

SELECT
    concat('안녕', '하세요', '반갑', '습니다')
FROM
    dual; -- 여러개 사용 불가능 (2개만 합치기 가능하기때문에 추가하려면 중첩사용)

SELECT
    concat('안녕',
           concat('하세요',
                  concat('반갑', '습니다')))
FROM
    dual;
--위와 같이 중첩해서 사용할때는 가독성이 좋지 않기 때문에 연결 연산자 이용하기

SELECT
    '안녕'
    || '하세요'
    || '반갑'
    || '습니다'
FROM
    dual;

/*
   REPLACE
   -문자열로부터 찾을 문자를 바꿀 문자로 변경한 문자열 반환
   -REPLACE(문자열,찾을문자,바꿀문자)

   결과값은 CHARACTER(문자열)

*/

SELECT
    replace('안녕하세요', '하세요', '하십니까')
FROM
    dual;

--EMPLOYEE 테이블에서 사원들의 이메일 주소가 gmail.com으로 변경하여 조회하기
SELECT
    emp_name,
    replace(email, 'kh.or.kr', 'gmail.com')
FROM
    employee;

-------------------------------------------------------------------------------------------------
/*
   <숫자 관련 함수>

   -ABS(숫자) : 절대값 구하는 함수
   결과는 NUMBER
*/

SELECT
    abs(- 15)
FROM
    dual; -- 15

/*
   MOD
   -MOD(숫자, 나눌값) : 두수를 나눈 나머지 값을 반환
   결과 NUMBER
*/

SELECT
    mod(10, 3)
FROM
    dual; -- 1

SELECT
    mod(- 10, 3)
FROM
    dual; -- -1

SELECT
    mod(19.9, 3)
FROM
    dual; -- 1.9

/*
   ROUND
   -ROUND(반올림할 수, 반올림 위치) : 반올림 처리 함수
   반올림 위치 : 소수점 아래 N번째수에서 반올림(생략가능 생략시 기본값 0)
   결과값 NUMBER
*/

SELECT
    round(123.456)
FROM
    dual; -- 123

SELECT
    round(123.456, 1)
FROM
    dual; -- 123.5 소수점 첫번째 자리

SELECT
    round(123.456, 2)
FROM
    dual; -- 123.46 소수점 두번째 자리

SELECT
    round(123.456, - 1)
FROM
    dual; -- 120 음수 입력시 정수자리수로 반올림

SELECT
    round(123.456, - 2)
FROM
    dual; -- 100

/*
   CEIL
   -CEIL(올림처리할 숫자) : 소수점 아래수를 무조건 올림처리하는 숫자
   결과값 NUMBER
*/

SELECT
    ceil(123.119)
FROM
    dual; -- 124

SELECT
    ceil(111.001)
FROM
    dual; -- 112

/*
  FLOOR
  -FLOOR(버림처리할 숫자) : 소수점 아래를 버림처리하는 함수
  반환타입 NUMBER
*/

SELECT
    floor(123.456)
FROM
    dual; -- 123

SELECT
    floor(555.999)
FROM
    dual; -- 555

--직원 근무일수 계산처리 소수점 버리기
SELECT
    floor(sysdate - hire_date)
FROM
    employee; -- 소수점 버리기 (시간계산까지 되기때문에 소수점 표현됨)

SELECT
    emp_name 사원명,
    floor(sysdate - hire_date)
    || '일'   근무일수
FROM
    employee;

/*
   TRUNC
   -TRUNC(버림처리숫자, 위치) : 위치가 지정가능한 버림처리 함수

   반환타입 NUMBER
   위치 생략가능 생략시 기본값 0
*/

SELECT
    trunc(123.456)
FROM
    dual; -- 123

SELECT
    trunc(123.456, 1)
FROM
    dual; -- 123.4

SELECT
    trunc(123.456, 2)
FROM
    dual; -- 123.45

SELECT
    trunc(123.456, - 1)
FROM
    dual; -- 120 (음수 지정시 정수자리로 버림처리)

-------------------------------------------------------------------------------------- ctrl + f로 검색 가능

/*
    <날짜 관련 함수>
    DATE 타입 : 년,월,일,시,분,초를 다 포함한 자료형
    SYSDATE : 현재 시스템 날짜와 시간 반환

*/

--1.
--MONTHS_BETWEEN(DATE1,DATE2) : 두 날짜 사이의 개월수 반환(결과값 NUMBER)
--DATE2가 더 미래일 경우 음수가 반환된다.
--각 직원별 근무일수 근무 개월수를 조회해보자.
SELECT
    emp_name 사원명,
    floor(sysdate - hire_date)
    || '일'   "근무 일 수",
    floor(months_between(sysdate, hire_date))
    || '개월'  "근무 개월수"
FROM
    employee;

--2번째 전달 값이 미래인 경우?
SELECT
    emp_name 사원명,
    floor((sysdate - hire_date))
    || '일'   "근무 일 수",
    floor(months_between(hire_date, sysdate))
    || '개월'  "근무 개월수"
FROM
    employee; -- 음수로 표현됨.

--2.
--ADD_MONTHS(DATE,NUMBER) : 특정 날짜에 해당 숫자만큼 개월수를 더한 날짜를 반환(반환타입 DATE)
--오늘로부터 5개월 후
SELECT
    add_months(sysdate, 5)
FROM
    dual;

--전체 사원들의 1년 근속일(입사1년)을 사원명,입사일,근속일 순으로 조회해보기
SELECT
    emp_name,
    hire_date,
    add_months(hire_date, 12) 근속일
FROM
    employee;

--3.
--NEXT_DAY(DATE,요일(문자/숫자)) : 특정날짜에서 가장 가까운 해당 요일을 찾아 날짜를 반환(반환타입 DATE)
SELECT
    next_day(sysdate, '일요일')
FROM
    dual; -- 25/10/26 오늘 날짜 기준 가장 가까운 일요일

SELECT
    next_day(sysdate, '토')
FROM
    dual; -- 25/10/25 오늘 날짜 기준 가장 가까운 토요일

SELECT
    next_day(sysdate, 1)
FROM
    dual; -- 25/10/26 (1:일요일 ~~~ 7:토요일)

SELECT
    next_day(sysdate, 'MONDAY')
FROM
    dual; -- 영어로 요일 지정시 오류발생 (현재 언어 세팅이 한국어로 되어있기 때문에)

--영어로 처리하려면 언어세팅 설정을 변경해야함
--DDL(정의언어)
ALTER SESSION SET nls_language = american;

--언어 변경 후 확인
SELECT
    next_day(sysdate, 'MONDAY')
FROM
    dual;

SELECT
    next_day(sysdate, '금요일')
FROM
    dual; --언어세팅이 영문으로 변경되었기 때문에 한글 제시 불가능

--한국어 세팅으로
ALTER SESSION SET nls_language = korean;

--4.
--LAST_DAY(DATE) : 특정 날짜 달의 마지막 날짜를 반환(반환타입 DATE)
SELECT
    last_day(sysdate),
    last_day('2025/02/05')
FROM
    dual;

--사원의 이름, 입사일, 입사한 월의 마지막 날짜 확인
SELECT
    emp_name            이름,
    hire_date           입사일,
    last_day(hire_date) "달의 마지막 날"
FROM
    employee;

--5.
/*
  EXTRACT : 년,월,일 정보 추출하여 반환 (NUMBER 타입)
  -EXTRACT(YEAR FROM 날짜) : 특정 날짜로부터 년도만 추출
  -EXTRACT(MONTH FROM 날짜) : 특정 날짜로부터 월만 추출
  -EXTRACT(DAY FROM 날짜) : 특정 날짜로부터 일만 추출
*/

SELECT
    EXTRACT(YEAR FROM sysdate)  년도,
    EXTRACT(MONTH FROM sysdate) 월,
    EXTRACT(DAY FROM sysdate)   일
FROM
    dual;

--사원명, 입사년도, 입사월, 입사일 조회
SELECT
    emp_name                      사원이름,
    EXTRACT(YEAR FROM hire_date)  입사년도,
    EXTRACT(MONTH FROM hire_date) 입사월,
    EXTRACT(DAY FROM sysdate)     입사일
FROM
    employee;

------------------------------------------------------------------------------------

/*
   <형변환 함수>
   NUMBER / DATE => CHARACTER

   - TO_CHAR(NUMBER/DATE,포맷)
   :숫자형 또는 날짜형 데이터를 문자형 타입으로 반환(입력한 포맷에 맞춰서)
*/

SELECT
    to_char(1234)
FROM
    dual;

--숫자를 문자열로 바꿀때 포맷 지정(자리수)
SELECT
    to_char(1234, '00000') 수
FROM
    dual; --빈자리를 0으로 채움.

SELECT
    to_char(1234, '99999') 수
FROM
    dual; -- 0까지 표현 X 9까지 표현 (공백)

SELECT
    to_char(1234, 'FM9999') 수
FROM
    dual; -- 지정한 숫자까지만 표현

SELECT
    to_char(1234, 'L00000') 수
FROM
    dual; --로컬 원화 기호가 붙는다

SELECT
    to_char(1234, 'L99999') 수
FROM
    dual; -- 0까지 표현 X

SELECT
    to_char(123456789, 'L999,999,999')
    || '원' 돈
FROM
    dual; -- 공백없이 자리수 표현 및 원화 표시

--날짜를 문자열로
SELECT
    sysdate 날짜
FROM
    dual; -- 시간정보까지 다 나옴 (연필 확인)

SELECT
    to_char(sysdate) 날짜
FROM
    dual; -- 문자열로 변환되었기 때문에 시간정보가 따로 나오지 않음 '25/10/21' 라는 문자열로 표기됨

--DATE 타입에서 추출할 수 있는 데이터 포맷에 맞춰서 변환해보기
SELECT
    to_char(sysdate, 'YYYY-MM-DD HH:MI:SS') 지금
FROM
    dual; -- 자바랑 다르게 MM이 아닌 MI임.
--시 분 초 : HH MI SS
--년 월 일 : YY MM DD
--24시 기준 : HH24
--요일 : DAY
--O요일에서 앞에만 표기 : DY

SELECT
    to_char(sysdate, 'YYYY-MM-DD DAY PM HH24:MI:SS')
FROM
    dual; -- 2025-10-21 화요일 오전 09:27:36 DAY PM HH24:MI:SS

SELECT
    to_char(sysdate, 'YYYY-MM-DD DY"요일" PM HH24:MI:SS')
FROM
    dual; -- 별도의 문자열을 넣고자 한다면 ""형식으로 추가해야한다.
--기본 포맷형식에서는 특수문자는 (: / -) 가능

--년도로 사용할 수 있는 포맷
SELECT
    to_char(sysdate, 'YYYY'),
    to_char(sysdate, 'RRRR'),
    to_char(sysdate, 'YY'),
    to_char(sysdate, 'RR'),
    to_char(sysdate, 'YEAR') -- TWENTY TWENTY-FIVE
FROM
    dual;

--YY와 RR 차이
--R : 반올림 (50년 기준으로 작으면 2000 크면 1900 년도로 표기된다)
--Y : 2000년도로 표기됨

--월표기
SELECT
    to_char(sysdate, 'MM') -- 10
    ,
    to_char(sysdate, 'MON') -- 10월
    ,
    to_char(sysdate, 'MONTH') -- 10월
    ,
    to_char(sysdate, 'RM') -- X(로마표기)
FROM
    dual;

--ALTER SESSION SET NLS_LANGUAGE = KOREAN;

--일표기
SELECT
    to_char(sysdate, 'D') -- 일요일기준 일요일부터 숫자
    ,
    to_char(sysdate, 'DD') -- 월 기준 1일부터 숫자
    ,
    to_char(sysdate, 'DDD') -- 년도기준 1월 1일부터 숫자
FROM
    dual;

-----------------------------------------------------------------

/*
    <TO_DATE>
    NUMBER / CHARACTER -> DATE
    TO_DATE(NUMBER/CHARACTER,포맷) : 숫자형 또는 문자형 데이터를 날짜형으로 변환(변환타입 DATE)
*/

SELECT
    TO_DATE(850101)
FROM
    dual; -- RR/MM/DD 포맷 (반올림처리)

SELECT
    TO_DATE(000505) -- 숫자를 표현할때 앞에 0을 쓰진 않음.
FROM
    dual; --숫자에서 앞에오는 0은 표현되지 않기때문에 오류 발생
--위처럼 숫자 0이 앞에 오는 경우는 문자열 표기로 해줄 것.

SELECT
    TO_DATE('000505')
FROM
    dual;

--포맷 지정하기
SELECT TO_DATE('251001 175000', 'RRMMDD HH24:MI:SS') 날짜
FROM dual; -- 연필 눌러서 확인 시간까지 다 나옴

--YY포맷을 지정하여 년도 표기
SELECT TO_DATE('990101','YYMMDD') 날짜
FROM DUAL; -- 2099년으로 찍힘(연필 확인) (YY형식을 지정하면 년도 앞쪽이 20이 붙어서 2099가 된다.)

--RR포맷을 지정하여 년도 표기
SELECT TO_DATE('990101','RRMMDD') 날짜
FROM DUAL; -- RR로 표기시 50기준 작으면 20 크면 19가 붙게된다.

--50미만이면 현재 세기 표현 (1~49)
--50이상이면 이전 세기 표현 (50~99)

------------------------------------------------------------------------------------------
/*
  CHARACTER -> NUMBER
  TO_NUMBER(문자, 포맷)
  문자형 데이터를 숫자형으로 변경(NUMBER)
*/

--자동형변환 예시
SELECT '123'+123
FROM DUAL; -- 246 (문자를 숫자로 변환 후 산술연산 처리)

SELECT '123,000'+'256,000'
FROM DUAL; -- 오류발생 : 문자열에 숫자만 있는것이 아닌 문자 기호까지 있다면 자동형변환이 불가능하다.

SELECT TO_NUMBER('123,000','999,999,999') + TO_NUMBER('256,000','999,999,999') 계산처리
FROM DUAL; -- 포맷 형식에 맞춰 형변환 후 산술 연산처리까지 완료

SELECT TO_NUMBER('000123') 수
FROM DUAL; -- 0으로 시작하는 숫자 문자열도 변환 가능

SELECT EMP_NAME
       ,EMP_NO
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = 1; -- 내부적으로 형 변환이 가능해서 써지는것 원래는 '1'이 맞음. (자동형변환 처리가 되기 때문에 문자열과 숫자 비교처리가 잘 되는것)

------------------------------------------------------------------------------------------------------------------------------

/*
    NULL 관련 함수

    NVL(컬럼명, 해당컬럼값이 NULL일 경우 치환할 값); -> 많이씀
    -해당 컬럼값이 존재할 경우 기존 컬럼값 반환
    -해당 컬럼값이 존재하지 않을 경우 (NULL일 경우) 제시한 값 반환
*/

SELECT EMP_NAME,SALARY,BONUS
FROM EMPLOYEE;

SELECT EMP_NAME,SALARY,NVL(BONUS,0)
FROM EMPLOYEE; -- SELECT는 단순 조회

--보너스 포함 연봉 계산해서 사원명과 함께 조회해보기

SELECT EMP_NAME 사원명
       ,(SALARY + (SALARY*BONUS))*12 "보너스 포함 연봉"
       ,(SALARY + (SALARY*NVL(BONUS,0)))*12 "보너스 포함 연봉NVL"
FROM EMPLOYEE; --보너스가 NULL인 경우도 0으로 치환되어 계산처리 결과 확인 가능

--부서코드가 없는 사원들 부서없음 표기 하기
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE;

SELECT EMP_NAME 사원명
       ,NVL(DEPT_CODE,'부서없음') 부서
FROM EMPLOYEE;

--NVL2(컬럼명,결과값1,결과값2) -> 삼항 연산자랑 비슷함
--해당 컬럼값이 존재할 경우(NULL이 아닐 경우) - 결과값1 반환
--해당 컬럼값이 존재하지 않을 경우 (NULL일 경우) - 결과값2 반환

--보너스가 있는 사원은 보너스있음 보너스가 없는 사원은 보너스 없음 조회해보기
SELECT EMP_NAME 사원명
       ,BONUS
       ,NVL2(BONUS,'보너스있음','보너스없음') 보너스유무
FROM EMPLOYEE;

--부서가 있는 사원은 부서 배치 완료, 부서가 없으면 부서 미배치로 조회
--사원명,부서정보 조회
SELECT EMP_NAME 사원명
       ,DEPT_CODE
       ,NVL2(DEPT_CODE,'부서 배치 완료','부서 미배치') 부서유무
FROM EMPLOYEE;

--NULLIF(비교대상1, 비교대상2) : 동등비교
--두 값이 동일한 경우 NULL 반환
--두 값이 동일하지 않을 경우 비교대상 1 반환

SELECT NULLIF('123','123')
FROM DUAL; -- 두 값이 같으니 NULL 반환

SELECT NULLIF('123','231')
FROM DUAL; -- 두 값이 다르기 때문에 앞에있는 값을 반환한다.

------------------------------------------------------------------------------------------------

/*
    <선택 함수>
    DECODE(비교대상,조건값1,결과값1,조건값2,결과값2, .... 조건값N, 결과값N, 결과값)

    자바에서의 SWITCH문과 유사하다.

    비교대상과 비교한 조건값으로 해당 결과값을 내보내는 함수
    비교대상에는 컬럼명, 산술연산(숫자), 함수(리턴값)가 들어갈 수 있다.
    비교대상과 조건값이 모두 일치하지 않으면 마지막에 작성한 결과값으로 반환된다.
    마지막 결과값은 SWITCH문에서 DEFAULT 역할
    생략도 가능하지만 생략한다면 조건에 일치하는게 없을 경우 NULL이 반환된다.
*/

--사번, 사원명, 주민번호, 성별 1이면 남자, 2면 여자로 조회해보기
SELECT EMP_ID 사번
       ,EMP_NAME 사원명
       ,EMP_NO 주민번호
       ,DECODE(SUBSTR(EMP_NO,8,1),'1','남자','2','여자','3','남자','4','여자') 성별
FROM EMPLOYEE;

--직원들의 급여를 인상시켜 조회해보기
--직급코드가 J7인 사원은 급여 10% 인상해서 조회
--직급코드가 J6인 사원은 급여 15% 인상해서 조회
--직급코드가 J5인 사원은 급여 20% 인상해서 조회
--그 외 사원들은 급여 5% 인상해서 조회
--사원명, 직급코드, 급여, 인상 후 급여로 조회해보기

SELECT EMP_NAME 사원명
      ,JOB_CODE 직급코드
      ,SALARY 급여
      ,DECODE(JOB_CODE,'J7',SALARY*1.1,'J6',SALARY*1.15,'J5',SALARY*1.2,SALARY*1.05) "인상 후 급여"
FROM EMPLOYEE;

/*
   <CASE WHEN THEN>
   [표현법]
   CASE WHEN 조건1 THEN 결과1
        WHEN 조건2 THEN 결과2
        ...
        ELSE 결과값
   END

   DECODE에선 동등비교로 수행하지만 CASE WHEN THEN 구문은 범위 비교 또한 가능하다.
   자바에서 IF문처럼 사용
*/

--사번, 사원명, 주민번호, 성별 1이면 남자, 2면 여자로 조회해보기
SELECT EMP_ID 사번
      ,EMP_NAME 사원명
      ,EMP_NO 주민번호
      ,CASE WHEN SUBSTR(EMP_NO,8,1) IN('1','3') THEN '남자'
 --           WHEN SUBSTR(EMP_NO,8,1) IN('2','4') THEN '여자'
            ELSE '여자'
       END "성별"
FROM EMPLOYEE;

--직원들의 급여를 인상시켜 조회해보기
--직급코드가 J7인 사원은 급여 10% 인상해서 조회
--직급코드가 J6인 사원은 급여 15% 인상해서 조회
--직급코드가 J5인 사원은 급여 20% 인상해서 조회
--그 외 사원들은 급여 5% 인상해서 조회
--사원명, 직급코드, 급여, 인상 후 급여로 조회해보기

SELECT EMP_NAME 사원명
       ,JOB_CODE 직급코드
       ,SALARY 급여
       ,CASE WHEN SUBSTR(JOB_CODE,1,2) = 'J7' THEN SALARY * 1.1
             WHEN SUBSTR(JOB_CODE,1,2) = 'J6' THEN SALARY * 1.15
             WHEN SUBSTR(JOB_CODE,1,2) = 'J5' THEN SALARY * 1.2
             ELSE SALARY * 1.05
        END "인상 후 급여"
FROM EMPLOYEE;

--사원명,급여,급여등급 조회
--급여등급은 급여가 500만원 초과일 경우 '고급'
--급여가 500만원 이하 350만원 초과일 경우 '중급'
--급여가 350만원 이하일 경우 '초급'으로 조회하기

SELECT EMP_NAME 사원명
       ,SALARY 급여
       ,CASE WHEN SALARY>3500000 AND SALARY <=5000000 THEN '중급'
             WHEN SALARY>5000000 THEN '고급'
             ELSE '초급'
       END "급여 등급"
FROM EMPLOYEE;

-- 15. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME 사원명
       ,SUBSTR(EMP_NO,1,2) "생년"
       ,SUBSTR(EMP_NO,3,2) "생월"
       ,SUBSTR(EMP_NO,5,2) "생일"
FROM EMPLOYEE;

-- 16. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME 사원명
       ,RPAD(SUBSTR(EMP_NO,1,7),14,'*') "생년월일"
FROM EMPLOYEE;

-- 17. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- (단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)

SELECT EMP_NO 사원명
       ,FLOOR(ABS(SYSDATE-HIRE_DATE)) "근무일수1"
       ,FLOOR(SYSDATE-HIRE_DATE) "근무일수2"
FROM EMPLOYEE;

-- 18. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID,2) != 0;

-- 19. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;

-- 20. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME 사원명
       ,TO_CHAR(SALARY, 'L9,000,000') 급여
FROM EMPLOYEE;

-- 21. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
-- (단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며
-- 나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)

SELECT EMP_NAME 직원명
      ,DEPT_CODE 부서코드
      ,TO_CHAR(TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'), 'YY"년"MM"월"DD"일"')
      ,FLOOR((SYSDATE - TO_DATE(SUBSTR(EMP_NO, 1, 6), 'RRMMDD'))/365) 나이
FROM EMPLOYEE;

-- 22.EMPLOYEE테이블에서 부서코드가 D5, D6, D9인 사원만 조회하되 D5면 총무부, D6면 기획부, D9면 영업부로 처리
-- (단, 부서코드 오름차순으로 정리)

SELECT CASE WHEN DEPT_CODE = 'D5' THEN '총무부'
            WHEN DEPT_CODE = 'D6' THEN '기획부'
            WHEN DEPT_CODE = 'D9' THEN '영업부'
        END "부서"
FROM EMPLOYEE
ORDER BY "부서" ASC;

-- 23. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리
-- 주민번호 앞자리와 뒷자리의 합 조회

SELECT EMP_NAME 사원명
      ,SUBSTR(EMP_NO,1,6) "주민번호 앞자리"
      ,SUBSTR(EMP_NO,8) "주민번호 뒷자리"
      ,(SUBSTR(EMP_NO,1,6) + SUBSTR(EMP_NO,8,14)) "앞자리와 뒷자리의 합"
FROM EMPLOYEE
WHERE EMP_ID = '201';

-- 24. EMPLOYEE테이블에서 부서코드가 D5인 직원의 보너스 포함 연봉 합 조회

SELECT DEPT_CODE , SUM(SALARY + (SALARY * BONUS)) "보너스 포함 연봉 합"
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING DEPT_CODE = 'D5';

-- 25. EMPLOYEE테이블에서 직원들의 입사일로부터 년도만 가지고 각 년도별 입사 인원수 조회
-- 전체 직원 수 , 2001년, 2002년, 2003년, 2004년

SELECT EXTRACT(YEAR FROM HIRE_DATE) "입사년도" ,COUNT(*) "인원"
FROM EMPLOYEE
GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
HAVING EXTRACT(YEAR FROM HIRE_DATE) IN ('2001', '2002', '2003', '2004');


-------------------------------------------------------------------------------------------

-----그룹함수-----
--그룹함수 : 데이터들의 합,평균,최대값,최소값 등등을 구할 수 있는 함수
--N개의 값을 읽어서 1개의 값을 반환해주는 함수(하나의 그룹을 기준으로 실행 결과를 반환한다)

--1. SUM(숫자) : 해당 컬럼값들의 총 합계를 반환해주는 함수
--전체 사원들의 총 급여 합계
SELECT SALARY
FROM EMPLOYEE;

SELECT SUM(SALARY)
FROM EMPLOYEE;

--부서코드가 D5인 사원들의 급여 합계를 구해주세요.

SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- WHERE 절은 조건에 부합할때마다 한 행씩 반환


--남자사원들의 급여합계 조회
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = '1'; -- WHERE 절은 조건에 부합할때마다 한 행씩 반환

--2.AVG(숫자) : 해당 컬럼값들의 평균값을 구해서 반환
--전체사원들의 평균
SELECT AVG(SALARY)
FROM EMPLOYEE;

--3.MIN(아무타입) : 해당 컬럼값들 중 가장 작은 값 반환
SELECT MIN(SALARY) 최저급여
       ,MIN(EMP_NAME) 이름
       ,MIN(EMAIL) 이메일
       ,MIN(HIRE_DATE) 입사일
FROM EMPLOYEE;
--전체사원들 중 최저 급여, 가장 작은 이름, 가장 작은 이메일, 가장 작은 입사날짜
--문자열들은 오름차순시 가장 위에 오는 대상이 MIN으로 처리

--4.MAX(아무타입) : 해당 컬럼값들 중 가장 큰 값 반환
SELECT MAX(SALARY) 최고급여
       ,MAX(EMP_NAME) 이름
       ,MAX(EMAIL) 이메일
       ,MAX(HIRE_DATE) 입사일
FROM EMPLOYEE;

-- MAX 함수는 해당 컬럼을 내림차순 했을 때 가장 위에 올라오는 값

-- 5. COUNT(컬럼명/DISTINCT 컬럼명) : 조회된 행의 개수를 반환
-- COUNT(*) : 조회결과에 해당하는 모든 행의 개수 반환
-- COUNT(컬럼명) : 제시한 해당 컬럼값이 NULL이 아닌 행의 개수를 반환
-- COUNT(DISTINCT 컬럼명) : 제시한 해당 컬럼값이 중복이 있을 경우 하나만 세어 반환(NULL 미포함)

--전체 사원 수
SELECT COUNT(*)
FROM EMPLOYEE;

SELECT *
FROM EMPLOYEE;

--여자 사원 수 구해보기
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) = '2';

--부서배치된 사원 수 구해보기
SELECT COUNT(*)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL;

--COUNT함수에 컬럼명을 넣어 NULL이 아닌 데이터행 수 반환받기
SELECT COUNT(DEPT_CODE)
FROM EMPLOYEE; -- 21

--사수가 있는 사원들 수 조회
SELECT COUNT(MANAGER_ID)
FROM EMPLOYEE; -- 16

SELECT COUNT(*)
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL; -- 16

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; -- 7

SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE; -- 6 (NULL 제외)

--사원들이 속해있는 직급 조회
SELECT JOB_CODE
FROM EMPLOYEE; -- 23

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE; -- 7

SELECT COUNT(JOB_CODE)
FROM EMPLOYEE; -- 23

SELECT COUNT(DISTINCT JOB_CODE)
FROM EMPLOYEE;

--부서별로 사원 수 세어보기
SELECT DEPT_CODE,COUNT(*)
FROM EMPLOYEE;

SELECT DEPT_CODE,COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE;