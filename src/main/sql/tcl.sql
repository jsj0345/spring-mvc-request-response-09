/*
  -파일명 : 10_TCL(COMMIT,ROLLBACK)_KH계정.SQL

  TCL(TRANSACTION CONTROL LANGUAGE)
  트랜잭션 제어 언어

  *트랜잭션(TRANSACTION)
  -데이터 베이스의 논리적 작업 단위
  -데이터의 변경사항 (DML)들을 하나의 트랜잭션으로 묶어서 처리
  -COMMIT(확정) 하기 전 까지의 변경사항들을 하나의 트랜잭션으로 처리
  -트랜잭션의 대상이 되는 SQL - DML 구문(INSERT,UPDATE,DELETE)

  *트랜잭션
  -COMMIT : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 적용하겠다는 의미
            실제 DB에 반영시킨 후 트랜잭션은 비워진다(확정)

  -ROLLBACK : 하나의 트랜잭션에 담겨있는 변경사항들을 실제 DB에 적용하지 않고
              트랜잭션에 담겨있는 변경사항을 삭제한 뒤 마지막 COMMIT 시점으로 되돌아간다.

  -SAVEPOINT 포인트명 : 현재 시점에 임시 저장점을 정의하는 것

  -ROLLBACK TO 포인트명 : 전체 변경사항들을 삭제하는 것 이 아닌 SAVEPOINT 지점까지만 되돌린다.
*/

SELECT *
FROM EMP_01
ORDER BY 1;

--901번 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID = '901';

DELETE FROM EMP_01
WHERE EMP_ID = '900';

UPDATE EMP_01
SET DEPT_TITLE = '인사부'
WHERE EMP_ID = 214;

INSERT INTO EMP_01 VALUES('999','김구구','운영관리부'); -- 24행

ROLLBACK; --되돌리기

UPDATE EMP_01
SET DEPT_TITLE = '인사부'
WHERE EMP_ID = 214;

INSERT INTO EMP_01 VALUES('999','김구구','운영관리부'); --26행

SELECT * FROM EMP_01;

--COMMIT 해보기
COMMIT;

SELECT * FROM EMP_01 ORDER BY 1;

ROLLBACK; -- 위에서 COMMIT 했기 때문에 기존 트랜잭션 작업에서 UPDATE, INSERT 된 구문이 확정됨.

--SAVEPOINT로 임시지점 기록하기
DELETE FROM EMP_01
WHERE EMP_ID IN (900,901,999); --3개 행 삭제

SELECT * FROM EMP_01 ORDER BY 1; --23행

--SAVEPOINT 지정(3행 삭제 이후 시점)
SAVEPOINT SP1; -- SAVEPOINT가 생성 되었습니다.

SELECT * FROM EMP_01 ORDER BY 1; --23행

DELETE FROM EMP_01
WHERE EMP_ID = '214'; --22행

--SAVEPOINT로 돌아가는것이 아니라 그냥 ROLLBACK 해보기
ROLLBACK;

SELECT * FROM EMP_01 ORDER BY 1; -- 26행 (SAVEPOINT로 돌아간게 아니라 트랜잭션 이전 COMMIT 시점으로 돌아감)

--SAVEPOINT로 돌아가기 확인
DELETE FROM EMP_01
WHERE EMP_ID IN (900,901,999); --3개 행 삭제

SELECT * FROM EMP_01 ORDER BY 1; --23행

--SAVEPOINT 지정(3행 삭제 이후 시점)
SAVEPOINT SP1; -- SAVEPOINT가 생성 되었습니다.

SELECT * FROM EMP_01 ORDER BY 1; --23행

DELETE FROM EMP_01
WHERE EMP_ID = '214'; --22행

--지정한 SAVEPOINT인 SP1로 되돌리기
ROLLBACK TO SP1; --SAVEPOINT로 되돌리기

ROLLBACK; -- 26행

/*
   주의사항
   DDL 구문(CREATE,ALTER,DROP)을 실행하면
   기존 트랜잭션에 있던 변경 사항들이 반영된다(COMMIT)
   그 이후 DDL 구문이 수행됨.
   따라서 DDL 구문을 수행하기 전에 DML 변경 작업이 있었다면
   COMMIT 또는 ROLLBACK으로 확정지어주고 진행해야한다.
*/