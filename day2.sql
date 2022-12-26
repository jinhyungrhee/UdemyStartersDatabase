-- 6장 데이터 관리 DML
-- employees 테이블 사번, 이름, 성, 급여, 입사일, 부서코드 컬럼 복사 테이블

DESC employees;


CREATE TABLE emp_copy
(SELECT employee_id, first_name, last_name, salary, hire_date, department_id FROM employees);

--
SELECT COUNT(*) FROM emp_copy;

-- 1 이사원 15000 2022-12-26 10
/* insert into 테이블명(컬렴명리스트, , , , ) values (값리스트, , , ,) */
INSERT INTO emp_copy(employee_id, first_name, last_name, salary, hire_date, department_id) 
VALUES(1, "사원", "이", 15000, '2022-12-26', 10);
-- 순서, 개수, 타입 일치 필요!
SELECT * FROM emp_copy ORDER BY employee_id;

-- 2 최사원 15000 2022-12-26 80 삽입 (컬럼에 이름을 주지 않은 경우)
-- 모든 컬럼에 차례대로 들어갈 경우, 컬럼 리스트 생략 가능! (desc emp_copy로 순서 확인)
INSERT INTO emp_copy
VALUES(2, "사원", "최", 15000, '2022-12-26', 80);

SELECT * FROM emp_copy ORDER BY employee_id;

-- 3 홍길동 급여 없음(null) 입사일 모름(null) 부서코드 모름(null) - 사번과 이름만 존재
INSERT INTO emp_copy
VALUES(3, "길동", "홍", null, '2022-12-26', null);

SELECT * FROM emp_copy ORDER BY employee_id;

-- 4 김길동 - 자동 null (컬럼 리스트에 나열되지 않은 컬럼들은 자동으로 null)
INSERT INTO emp_copy(employee_id, first_name, last_name, hire_date)
VALUES(4, "길동", "김", '2022-12-26');

SELECT * FROM emp_copy ORDER BY employee_id;

-- 여러 개 insert - 한번에 여러 개 데이터 저장 방법1
INSERT INTO emp_copy VALUES 
(5, "길동", "홍", 7000, '2012-11-26', NULL),
(6, "길동", "홍", NULL, '2012-10-26', NULL),
(7, "길동", "홍", NULL, '2002-09-26', 50);
SELECT * FROM emp_copy ORDER BY employee_id;

-- 오류
INSERT INTO emp_copy VALUES 
(8, "길동", "홍", 7000, '2012', NULL);

-- 년도4자리-월2자리-일2자리 2시:2분:2초 maria db 기본형식
-- datetime(date, time)

INSERT IGNORE INTO emp_copy VALUES
(8, "길동", "홍", 7000, '2012', NULL);
SELECT * FROM emp_copy ORDER BY employee_id;

-- emp_copy 테이블 생성 + 데이터 복사
CREATE TABLE emp_copy
(SELECT employee_id, first_name, last_name, salary, hire_date, department_id FROM employees);

-- emp_copy 테이블 생성하지 말고 데이터만 복사 (insert문은 괄호 사용X) - 한번에 여러 개 데이터 저장 방법2
INSERT INTO emp_copy
SELECT employee_id, first_name, last_name, salary, hire_date, department_id FROM employees;


DESC emp_copy;

-- 커밋 상태 확인
SHOW VARIABLES LIKE 'auto%'; 

-- 마리아디비 autocommit 기본 : DML 실행하면 자동으로 처리해버림
/*
INSERT
UPDATE
DELETE 
즉각 결과 반영 - 삭제 한 번 하면 결과 복구 불가
*/

-- autocommit 상태 변경
-- SET autocommit = FALSE;

-- DELETE FROM 테이블명 WHERE 삭제조건식;
-- 삭제하기 전에 항상 SELECT * FROM 테이블명으로 조회를 하고 이후에 DELETE 수행 (안전장치)

-- DELETE 문장은 AUTOCOMMIT 상태 설정만 변경하면 복구 기회가 있음
-- DELETE 문장은 WHERE 절 사용 가능
-- TRUNCATE 문장은 AUTOCOMMIT과 상관없이 복구 불가
-- TRUNCATE 문장은 WHERE 절 사용 불가
-- ex) TRUNCATE emp_copy;

-- UPDATE
/*
UPDATE 테이블명
SET 변경컬럼명=변경값
WHERE 변경조건식 문법 유사
*/

SELECT employee_id, salary FROM emp_copy;

-- 1번 사원의 급여 인상. 10% 인상.
UPDATE emp_copy 
SET salary = salary * 1.1
WHERE employee_id = 1;

SELECT employee_id, salary FROM emp_copy;

-- 입사월이 6월인 사원의 부서 20번 부서로 배정하고 급여 20% 인상 - 테이블 변경


-- UPDATE emp_copy 
-- SET department_id = 20, salary = salary * 1.2
SELECT hire_date, first_name, department_id, salary FROM emp_copy
WHERE hire_date LIKE '_____06%';


-- 7장-제약조건
-- 오류 발생 문장
INSERT INTO emp_copy VALUES (9, "이름", "성", NULL, NULL, NULL);

-- 오류 원인 확인
SELECT * FROM information_schema.table_constraints
WHERE TABLE_NAME = 'employees';

-- employee_id, last_name, hire_date 는 null이면 안 된다는 조건 -> 이미 설정
-- 테이블 구성 - 현실 세계 데이터 그대로 표현(= 사번 반드시 존재, 사번 중복X)
DESC emp_copy;

-- 새로운 테이블 생성
-- 상품코드 상품명 가격 수량 
CREATE TABLE product
(
p_CODE INT PRIMARY KEY,
p_NAME CHAR(30) NOT NULL, 
price DECIMAL,
balance SMALLINT CHECK ( balance  >= 0)
);


-- primary, not null 정보 확인
DESC product;

-- 테이블 제약조건 확인 : not null 제외 제약조건 정보
SELECT * FROM information_schema.table_constraints
WHERE TABLE_NAME = 'product';

INSERT INTO product VALUES(100, '냉장고', 1000000, 10);
-- INSERT INTO product VALUES(101, '키보드', 10000, -10); -- 오류
INSERT INTO product VALUES(102, '마우스', 10000, 5);
INSERT INTO product VALUES(103, '컴퓨터', 1000000, 0);

SELECT * FROM product;

-- p_CODE -> 정수, 자동숫자증가 
-- auto increment 제약조건 추가(MySQL, maria db만 가능)

-- auto increment (컬럼 이미 존재 primarr key ) - 기존 컬럼 속성 수정하기
-- AUTO_INCREMENT를 붙이려면 반드시 앞에 NOT NULL 존재해야 함!
ALTER TABLE product MODIFY p_CODE INT NOT NULL AUTO_INCREMENT; 

INSERT INTO product(p_name, price, balance) VALUES ('컴퓨터2', 1000000, 50);

SELECT * FROM product;

-- 회원 정보 저장 테이블 [users]
/* user_id char(10) 중복x, null 허용x 
	user_pw 문자 5자리 - null 허용X
	user_name 문잘 30자리
	user_email 문자 30자리 중복X
	user_phone 문자 12자리,'010-'시작
	address 문자 100자리
*/

CREATE TABLE users
(
user_id CHAR(10) PRIMARY KEY,
user_pw CHAR(5) NOT NULL, 
user_name CHAR(30),
user_email CHAR(30) UNIQUE,
user_phone CHAR(12) CHECK ( user_phone LIKE '010-%'),
address CHAR(100)
);

INSERT INTO users(user_id, user_pw, user_name, user_email, user_phone, address) 
VALUES ('gildong', '1234', '홍길동', 'gildong@gmail.com', '010-34567890', '서울특별시 용산구 청파로');

SELECT * FROM users;

DESC users; -- 컬럼명, 타입, not null, primary, unique 정보

-- check 포함(not null X)
SELECT * from information_schema.table_constraints WHERE TABLE_NAME='users';

-- check 내용 확인
SELECT *
FROM information_schema.CHECK_CONSTRAINTS;

SELECT TABLE_NAME, CONSTRAINT_NAME, check_clause
FROM information_schema.CHECK_CONSTRAINTS;

-- 제약 조건 효력 발생 - DML 사용시
INSERT INTO users VALUES('MARIA', 'DB', '홍길동', 'HONG@A.COM', '010-23456789', '서울시 용산구');

INSERT INTO users VALUES('MARIA2', 'DB', '홍길동', 'HONG2@A.COM', '010-34567890', '서울시 마포구');

-- INSERT INTO users VALUES('MARIA3', 'DB3', '', 'HONG3@A.COM', '01034567890', '서울시 마포구');


-- 4, 5 SELECT
-- 6 INSERT DELETE UPDATE
-- 7 제약조건 - CREATE TABLE

-- 컬럼 레벌로만 정의 가능(모든 db 동일) : not null
-- 테이블 레벨로만 정의 가능(Maria db만) : foreign key 
-- 그 이외의 것들(PK, UNIQUE, CHECK)은 컬럼 레벨, 테이블 레벨 모두 가능!

CREATE TABLE board(
seq INT NOT NULL AUTO_INCREMENT PRIMARY KEY, -- PK : 컬럼 레벌 정의
title CHAR(100) NOT NULL, -- not null : 컬럼 레벨 정의
contents TEXT, -- TEXT 필드 :  66636 바이트 (한글은 나누기 3)
viewcounts INT DEFAULT 0, -- default : 컬럼 레벨 정의
writer CHAR(10), 
-- FK 제약조건 작성 : 테이블 레벨 정의 ***
CONSTRAINT fk_board_writer FOREIGN KEY(writer) REFERENCES users(user_id)
);

-- foreign key 제약조건--
/* 
1. users 테이블의 user_id는 반드시 PK이어야 참조 가능!
2. writer 컬럼은 users의 user_id 컬럼과 타입과 길이가 일치해야 함! 
*/

DESC board;

-- foreign key 참조 테이블 조회 --
SELECT * FROM information_schema.KEY_COLUMN_USAGE
WHERE table_name='board';


-- 컬럼 레벨 정의 vs 테이블 레벨 정의
CREATE TABLE board2(
seq INT NOT NULL AUTO_INCREMENT,
title CHAR(100) NOT NULL, 
contents TEXT,
viewcounts INT DEFAULT 0, 
writer CHAR(10), 
--  테이블 레벨 정의 ***
-- 제약 조건명은 DB안에서 중복될 수 없음!
CONSTRAINT pk_board_seq PRIMARY KEY(seq),
CONSTRAINT fk_board_writer2 FOREIGN KEY(writer) REFERENCES users(user_id),
);

-- foreign key 참조 테이블 조회 --
SELECT * FROM information_schema.KEY_COLUMN_USAGE
WHERE table_name='board2';


INSERT INTO board(title, contents, writer) VALUES ("제목", '내용', 'MARIA');

INSERT INTO board(title, contents, writer) VALUES ("제목2", '내용2', 'MARIA2');

SELECT * from board;
SELECT * FROM users;

-- 중간에 MARIA가 탈퇴한 경우

-- 2. 자식테이블이 참조중인 데이터 삭제 시 -> (1) 자식도 같이 삭제 / (2) 자식은 null로 변경
-- 테이블 내부에서 조건 변경 필요!
-- 테이블 새로 생성 : CREATE [테이블명]
-- 테이블 일부 구조 변경 : ALTER [테이블명] - 컬럼추가, 삭제, 타입수정, 제약조건 수정

ALTER TABLE 테이블명 ADD  A INT; -- 없던 컬럼 추가
ALTER TABLE 테이블명 MODIFY A CHAR(10); -- 있던 컬럼 타입이나 길이 수정
ALTER TABLE 테이블명 DROP xxxx ; -- 있던 컬럼 삭제

ALTER TABLE 테이블명 ADD CONSTRAINT ... ; -- 존재하는 컬럼에 제약조건 추가
ALTER TABLE 테이블명 MODIFY CONSTRAINT ...; -- 제약조건 수정
ALTER TABLE 테이블명 DROP CONSTRAINT ... ; -- 제약조건 삭제


-- ALTER
-- 외래키 제약조건 있는 상태에서
-- 외래키 제약조건 삭제 후 - 추가(ON DELETE CASCADE)
ALTER TABLE board DROP CONSTRAINT fk_board_writer;
ALTER TABLE board add CONSTRAINT fk_board_writer FOREIGN KEY (writer) REFERENCES users(USER_id) ON DELETE CASCADE;


DELETE FROM users
-- SELECT * FROM users
WHERE user_id = 'MARIA';


-- 

INSERT INTO board (title, contents, writer) VALUES ('새제목', '새내용', 'maria2');

-- contents 컬럼도 null이 입력될 수 없게 수정(not null 추가) - not null인지 아닌지만 판단 -> (예외) modify만 사용!
ALTER TABLE board MODIFY contents TEXT NOT NULL;

INSERT INTO board (title, writer) VALUES ('새제목', 'maria2');


-- 작성시간 컬럼 추가 (새로운 컬럼 추가)
alter table board add writingtime DATETIME; 


-- 작성시간 칼럼 삭제
ALTER TABLE board DROP writingtime;

-- 기존 테이블 삭제
-- DROP TABLE board;
-- DROP TABLE users;

DESC board;

-- 9장. Subquery

DESC employees;

-- 단일행 서브쿼리 : '=' 사용 (in도 사용 가능)
-- first_name이 Kelly인 사원과 동일 부서 근무자의 부서코드, 급여, 이름 조회
SELECT department_id, salary, first_name
FROM employees
WHERE department_id=(SELECT department_id FROM employees WHERE first_name='Kelly');

-- kally 부서명 먼저 조회
-- SELECT department_id FROM employees WHERE first_name='Kelly';

-- 다중행 서브쿼리 : 'in' 사용
-- first_name이 Peter인 사원과 동일 부서 근무자의 부서코드, 급여, 이름 조회
SELECT department_id, salary, first_name
FROM employees
WHERE department_id IN (SELECT department_id FROM employees WHERE first_name='Peter');


-- 전체 사원  최대 급여 조회 (단일행) 
SELECT MAX(salary) FROM employees;


-- 최대 급여 부서별 조회 (다중행)
SELECT department_id,  MAX(salary) FROM employees
GROUP BY department_id;


-- 전체 사원 최소 급여의 주인 찾기
-- 잘못된 쿼리
SELECT first_name, min(salary) FROM employees; -- 잘못된 결과 나올 가능성 : Steven

-- 올바른 쿼리
SELECT first_name, salary FROM employees
WHERE salary=(SELECT min(salary) FROM employees); -- TJ


-- Peter와 같은 부서 사람의 부서코드, 급여 , 이름 조회
SELECT department_id, salary, first_name
FROM employees
WHERE department_id IN (SELECT department_id FROM employees WHERE first_name='Peter');


-- Peter와 같은 부서이고, 같은 입사일에 입사한 사원의 부서코드, 급여, 이름 조회
SELECT department_id, salary, first_name, hire_date
FROM employees
WHERE department_id IN (SELECT department_id FROM employees WHERE first_name='Peter')
AND hire_date IN (SELECT hire_date FROM employees WHERE first_name='Peter');

-- 중복 제거
-- 다중열 서브쿼리 ( 컬럼이 여러개 인 경우 - 두 개의 열(컬럼)을 비교!)
SELECT department_id, salary, first_name, job_id
FROM employees
WHERE (department_id, job_id) 
IN (SELECT department_id, job_id FROM employees WHERE first_name='Kelly');