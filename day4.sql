SELECT 1234.5678 FROM dual;

-- 숫자 데이터
SELECT 1234.5678, ROUND(1234.5678), ROUND(1234.5678, 1), ROUND(1234.5678, 2);

-- 문자 데이터
-- 조회 시에만 임시로 변경 (실제 DB 변경X)
SELECT phone_number, REPLACE(phone_number, '.', '-') FROM employees;

-- 성 - last_name, 이름 - first_name
SELECT CONCAT("성 - ", last_name, ". 이름 - ", first_name) FROM employees;

/*
-- 자바 표현
"성 - " + last_name + ". 이름 - " + first_name
-- oracle 표현
"성 - " || last_name || ". 이름 - " || first_name
-- maria db 표현
CONCAT("성 - ", last_name, ". 이름 - ", first_name)
*/

-- 자바 - char('') / String("")
-- 일반database - char/varchar : 문자열 표현 ('' - 단일 따옴표만 허용) 
-- maria db - char/varchar (최대256바이트 - 한글 3바이트) : 문자열 표현('', "" - 둘 다 허용)
--				- text (최대 65536문자 - 한글 3바이트) : 문자열 표현('', "")

-- 숫자함수

-- 숫자형 데이터 타입
-- 정수 tinyint(1) smallint(2) int(4) long(8) 상품코드 2
-- 실수 float(4) double(8) 
-- 사용자 구성 decimal(10, 0), decimal(8, 2)

-- round

-- 평균급여, 반올림, 소수점이하 절삭 
SELECT AVG(salary), ROUND(AVG(salary)), TRUNCATE(AVG(salary), 0) FROM employees;

SELECT 123.5678, ROUND(123.5678, 0), ROUND(123.5678, -1), ROUND(123.5678, -2);

-- + - * / %(나머지연산자)

-- MOD
SELECT 1234, MOD(1234, 3), MOD(1234, 7);

-- MOD 사용해서 employees 테이블에서 짝수 사번 사원들만 조회
SELECT employee_id, first_name
FROM employees
WHERE MOD(employee_id, 2) = 0;


-- 100 짝수사번
-- 101 홀수사번

SELECT employee_id, first_name,
case 
when MOD(employee_id, 2)=0 then '짝수사번'
ELSE '홀수사번'
END "사번의 셩격"
FROM employees;

-- 256자리- char / varchar / text
-- 65536 - text 

CREATE TABLE productfunc(
NAME CHAR(100),   
price DOUBLE (10, 2),
detail TEXT,
imagefile VARCHAR(100)
);

INSERT INTO productfunc VALUES('COMPUTER', 1000.99, '........', 'COM.JPG');

SELECT ASCII('A'), CHAR(65);

SELECT "ABCDEF", "가나다라마바", BIT_LENGTH("ABCDEF"), LENGTH("ABCDEF"), LENGTH("가나다라마바");

SELECT "ABCDEF", "가나다라마바", CHAR_LENGTH("ABCDEF"), CHAR_LENGTH("가나다라마바");

-- 문자 찾기 (= 날짜도 문자열 함수 사용)
-- 오라클 + MySQL => 함수 + maria db

-- 인덱싱 -- 
SELECT ELT(2, '일이', '둘', '셋'); -- 자바 INDEX 번호 0 시작 / DB는 1번 INDEX부터 시작

-- 인덱스 찾기 --
SELECT FIELD('일이', '일이', '둘', '셋'); -- 몇번째 인덱스에 있는지 확인 = 1
SELECT FIND_IN_SET('일이', '일이삼사'); -- [0] : 없음
SELECT FIND_IN_SET('일이', '일이,삼사,오육'); -- 1번째 문자(분리자(,) 필요)
SELECT INSTR('일이삼사오육', '삼'); -- 3번째 글자 (대상 : 첫번째 인자)
SELECT LOCATE('삼', '일이삼사오육'); -- 3번째 글자 (대상 : 두번째 인자)

-- 문자열 추출 -- 
SELECT SUBSTRING('김상형의 SQL정복', 5, 3); -- 5번째 글자에서 시작해서 3개 추출(공백 포함)
SELECT SUBSTR('김상형의 SQL정복', 5, 3);  -- 5번째 글자에서 시작해서 3개 추출(공백 포함)
SELECT NOW(); -- 현재 날짜/시간정보 함수 (날짜시간타입형식 확인 : 2022-12-28 13:13:40)
SELECT hire_date 입사시각, SUBSTR(hire_date, 1, 4) 입사년도, SUBSTR(hire_date, 6, 2) 입사월 FROM employees;


-- 월별 입자자수를 조회하되, 입사자 수가 10명 이상인 월만 출력하시오
SELECT SUBSTR(hire_date, 6, 2) 입사월, COUNT(*) 입사자수
FROM employees
GROUP BY SUBSTR(hire_date, 6, 2); -- 입사월으로만 그룹핑 (GROUP BY 안에서 SUBSTR 사용 가능)


-- 암호화
-- 클라이언트 암호 입력-> (암호화) -> db 테이블 저장

SET @pw = "abc가나다123123123123123123123123";

SELECT(@pw);

SELECT INSERT(@pw, 2, 4, "****"); -- 2번째부터 4번째까지의 값을 "****"로 변경 (대체)

SELECT INSERT(@pw, 2, 4, "*"); -- 2번째부터 4번째까지의 값을 "*"로 변경 (축소)

SELECT repeat("*", 4); -- *을 4번 반복 
SELECT repeat("*", CHAR_LENGTH(@pw)); -- @pw 변수의 글자 개수만큼 *을 반복

-- @pw 변수의 모든 값을 *로 바꾸어서 조회
SELECT @pw, INSERT(@pw, 1, CHAR_LENGTH(@pw), repeat("*", CHAR_LENGTH(@pw)));

SELECT @pw, INSERT(@pw, 2, CHAR_LENGTH(@pw)-1, repeat("*", CHAR_LENGTH(@pw)-1)); -- a********

-- 
SELECT "ABCDEF", LEFT("ABCDEF", 3), RIGHT("ABCDEF", 3);

SELECT "mArIa DATABase", UPPER("mArIa DATABase"), LOWER("mArIa DATABase");

-- 포맷 맞추기
-- 자바  : "Maria".toUpperCase()
-- maria : db upper("mArIa")


-- pad : 다른 문자열 채운다
SELECT 'abc', LPAD('abc', 10, "#"), -- 왼쪽으로 #를 채워서 10글자를 만듦
RPAD('abc', 10, "#"); -- 오른쪽으로 #를 채워서 10글자를 만듦

SELECT 'abc', LPAD('abc', 10, " "), -- 왼쪽으로 공백을 채워서 10글자를 만듦
RPAD('abc', 10, " "); -- 오른쪽으로 공백을 채워서 10글자를 만듦

DESC employees; -- 최대 몇글자인지 확인
SELECT first_name, LPAD(first_name, 20, "-") FROM employees;


-- trim : 문자열 잘라냄
SET @pw = "      김상형의 sql 정복       ";
SELECT CHAR_LENGTH(@pw), char_length(LTRIM(@pw)), CHAR_LENGTH(RTRIM(@pw));


SET @pw = "ㅋㅋㅋㅋㅋ웃겨요ㅋㅋㅋㅋㅋㅋㅋ";
SELECT TRIM(LEADING 'ㅋ' FROM @pw), -- LEADING : "왼쪽에서 시작하는"의 의미 
TRIM(TRAILING 'ㅋ' FROM @pw), -- TRAILING : "오른쪽에서 시작하는"의 의미
TRIM(BOTH 'ㅋ' FROM @pw); -- BOTH : 양쪽 모두


-- create table / alter table
-- 문자 char / varchar / text 
-- 숫자 int double decimal(실수, 정수 둘다 가능)  -- decimal(8, 2) : 소수점 둘째자리까지 (실수)
-- 날짜 date, time, datetime


-- 날짜 문자 숫자 입력 
-- emp_copy 
DESC emp_copy;

-- ** 테이블 복사 **
-- 제약조건은 복사되지 않음
-- 단, not null 조건은 복사됨!
SELECT MIN(employee_id), MAX(employee_id) FROM employees;

-- 날짜 <---> 문자형 (자동형변환)
INSERT INTO emp_copy VALUES(300, '길동', '최', 10000, NOW(), 200); -- 입사일에 now()함수로 데이터 입력

-- employee_id에 문자열로 입력 -> 정상적으로 입력됨
-- 숫자 <---> 문자형 (자동형변환)
INSERT INTO emp_copy VALUES('301', '길동', '최', 10000, NOW(), 200);

-- 자동형변환 불가 (데이터타입이 섞여있는 경우)
INSERT INTO emp_copy VALUES(302, '길동', '최', '10000a', NOW(), 200);

-- CURRENT_DATE 함수 (시분초는 없는 형태)
INSERT INTO emp_copy VALUES(302, '신입', '최', 10000, CURRENT_DATE, 200);

INSERT INTO emp_copy VALUES(303, '대리', '김', 10000, '2019-12-28 00:00:00', 200);

-- 4개월 전 날짜 입력
INSERT INTO emp_copy VALUES(304, '과장', '김', 10000, DATE_SUB(NOW(), INTERVAL 4 MONTH), 200);


INSERT INTO emp_copy VALUES(305, '대리', '김', 10000, '20221212', 200);

INSERT INTO emp_copy VALUES(306, '대리', '박', 10000, 20221212, 200);

SELECT * FROM emp_copy ORDER BY employee_id DESC;

-- 자동 형변환
SELECT 100 + 200;

SELECT '100' + '200'; -- 숫자로 형변환되어 저장됨

-- 문자열 결합 : CONCAT()
SELECT CONCAT(100, 200); -- 문자로 형변환되어 저장됨
SELECT CONCAT('100', '200');

-- 명시적 형변환 : CAST, CONVERT, FORMAT 
ROUND(123.444) TRUNCATE(123.4444, 0)

-- CAST, CONVERT, FORMAT 
-- 결과는 동일하지만 사용방법이 조금씩 다름
SELECT AVG(salary), 
CAST(AVG(salary) AS SIGNED INTEGER ), -- as 사용 
CONVERT(AVG(salary), SIGNED INTEGER), -- 콤마(,) 사용
FORMAT(AVG(salary), 0) 
FROM employees; 


-- 
IFNULL(컬럼명, 컬럼null 대체값) -- 다른 값으로 바꿔서 연산 
where NULLIF(값1, 값2) IS NULL 

-- if(T/F, T, F) 
SELECT if(20 > 10, "크다", "작거나 같다"); 

-- 사원들 commission_pct null 사원들, 그렇지 않은 사원들 
-- 이름    보너스 유무 
-- kelly   못받는다
 
 -- 단순 조건이면 if() 사용
 -- 복잡한 조건이면 case 사용
 SELECT first_name 이름, if(commission_pct IS NULL, "못받는다", "받는다") 보너스유무
 FROM employees;
 
 
 -- 조건
 -- 급여정보 연말 보너스 지급
 20000 이상이면         5000 증가
 15000 이상 20000 미만  10000 증가
 10000 이상 15000 미만  20000 증가
 나머지                 30000 증가
 
 
 SELECT first_name 이름, salary 급여, 
 case 
 when salary >= 20000 then salary + 5000
 when salary >= 15000 then salary + 10000
 when salary >= 10000 then salary + 20000
 ELSE salary + 30000
 END 연말보너스
 FROM employees;
 
 -- 입사년도 조회 : substr() 사용 --
 SELECT hire_date FROM employees ORDER BY 1;
 
 -- 2002년 이전까지의 입사자 30000
 -- 2005년 이전까지의 입사자 20000
 -- 나머지 10000
 
 SELECT first_name 이름, salary 급여, hire_date 입사년도,
 case 
 when substr(hire_date, 1, 4) < 2002 then salary + 30000
 when substr(hire_date, 1, 4) < 2005 then salary + 20000
 ELSE salary + 10000
 END 연말보너스
 FROM employees;
 
 
 SELECT first_name 이름, salary 급여, hire_date 입사일,
 case SUBSTR(hire_date, 1, 4)
 when '2001' then salary + 30000
 when '2002' then salary + 30000
 when '2003' then salary + 20000
 when '2004' then salary + 20000
 when '2005' then salary + 20000
 ELSE salary + 10000
 END 연말보너스
 FROM employees;
 
 
 SELECT first_name 이름, salary 급여, hire_date 입사일,
 case 
 when SUBSTR(hire_date, 1, 4) IN ('2001', '2002') then salary + 30000
 when SUBSTR(hire_date, 1, 4) IN ('2003', '2004', '2005') then salary + 20000
 ELSE salary + 10000
 END 연말보너스
 FROM employees;
 
 -- maria db decode 없음
 
 -- 날짜함수
 SELECT CURDATE(), CURRENT_DATE, CURTIME(), NOW(), SYSDATE();

-- CAST CONVERT FORMAT + DATE_FORMAT(쉽다)

-- 자바 SimpleDateFormat : 'yyyy-MM-dd HH:mm:ss'
-- maria db : '%Y/%m/%d'(= 년도4자리, 월2자리, 일2자리)
SELECT NOW(), DATE_FORMAT(NOW(), '%Y/%m/%d'), DATE_FORMAT(NOW(), '%y/%M/%D'); 
-- %Y : 4자리 연도 V
-- %y : 2자리 연도 (0-49 : 2000년도, 50-99 : 1900년도)
-- %M : 영문명 월
-- %m : 2자리 숫자 월 V 
-- %D : 서수형(몇번째 일)
-- %d : 2자리 숫자 일 V

SELECT NOW(), DATE_FORMAT('2022-01-01', '%Y/%c/%e'); 
-- %m : 01
-- %c : 1
-- %d : 01
-- %e : 1

SELECT NOW(), DATE_FORMAT(NOW(), '%Y/%m/%d %W %H:%i:%s'); 
-- %W : 영문 요일 

-- 정리
/*
%Y, %y     - 4자리 년도 / 2자리 년도
%m, %M, %c - 2자리 숫자 월 / 영문 월이름 / 1자리 숫자 월
%d, %e 	  - 2자리 숫자 일 / 1자리 숫자 일
%W 		  - 영문 요일
%a  		  - 영문 3글자 요일(축약형)

%H, %h     - 24시간 단위 / 12시간 단위
%i 		  - 분
%s 		  - 초
*/

-- 2006년도 입사자 급여조회
-- (0)
SELECT hire_date, salary
FROM employees
WHERE hire_date >= '2006-01-01 : 00:00:00'
AND hire_Date < '2007-01-01 00:00:00';

-- (1)
SELECT hire_date, salary
FROM employees
WHERE hire_date LIKE '2006%';

-- (2)
SELECT hire_date, salary
FROM employees
WHERE SUBSTR(hire_date, 1, 4) = '2006';

-- (3)
SELECT hire_date, salary
FROM employees
WHERE INSTR(hire_date, '2006') = 1;

-- (4)
SELECT hire_date, salary
FROM employees
WHERE DATE_FORMAT(hire_date, '%Y') = '2006';

-- 입사 연도만 가져올 경우
SELECT SUBSTR(hire_date, 1, 4), DATE_FORMAT(hire_date, '%Y'), YEAR(hire_date), salary
FROM employees;

-- 날짜에서 연도만 추출하는 함수
SELECT YEAR(NOW()), MONTH(NOW()), DAY(NOW()), HOUR(NOW()), MINUTE(NOW()), SECOND(NOW());


-- 6월 입사자 찾기
-- (1) : 11개
SELECT hire_date, salary
FROM employees
WHERE hire_date LIKE '_____06%';

-- (2) : 11개
SELECT hire_date, salary
FROM employees
WHERE SUBSTR(hire_date, 6, 2) = '06';

-- (3) : 10개 **
-- 2006-06 -> 3 리턴하고 끝남! (= 1개가 부족한 이유)
SELECT hire_date, salary
FROM employees
WHERE INSTR(hire_date, '06') = 6;

-- 수정
-- right() 사용해서 연도부분 빼고 찾기
SELECT hire_date, salary
FROM employees
WHERE INSTR(right(hire_date, CHAR_LENGTH(hire_date)-5), '06') = 1;

-- (4) : 11개
SELECT hire_date, salary
FROM employees
WHERE DATE_FORMAT(hire_date, '%m') = '06';

-- 입사 월만 가져올 경우
SELECT SUBSTR(hire_date, 6, 2), DATE_FORMAT(hire_date, '%m'), MONTH(hire_date), salary
FROM employees;


-- 2006년 '이후' 입사자 - 2006, 2007, 2008 
-- (0)
SELECT hire_date, salary
FROM employees
WHERE hire_date >= '2006-01-01 : 00:00:00'
ORDER BY hire_date;

-- (2)
SELECT hire_date, salary
FROM employees
WHERE SUBSTR(hire_date, 1, 4) >= '2006'
ORDER BY hire_date;

-- (4)
SELECT hire_date, salary
FROM employees
WHERE DATE_FORMAT(hire_date, '%Y') >= '2006'
ORDER BY hire_date;


-- 
SELECT WEEKDAY(NOW());

-- 이름 입사요일
SELECT upper(first_name) 이름,
case WEEKDAY(hire_date)
when 0 then '월요일'
when 1 then '화요일'
when 2 then '수요일'
when 3 then '목요일'
when 4 then '금요일'
when 5 then '토요일'
when 6 then '일요일'
END 입사요일
FROM employees;

-- 두 날짜 사이 계산 : subdate(), adddate()
-- 오늘 - 내일 : 1일
-- 오늘 - 한달전 : 30일
SELECT CURDATE() 오늘날짜,
SUBDATE( CURDATE(), INTERVAL 1 DAY ) 어제날짜,
ADDDATE( CURDATE(), INTERVAL 1 DAY ) 내일날짜, 
ADDDATE( CURDATE(), INTERVAL 1 MONTH ) 한달후날짜,
ADDDATE( CURDATE(), INTERVAL 1 YEAR ) 1년후날짜;

-- NOW(), hire_date() -> 입사한지 얼마나 경과일수 계산
-- datediff() : 숫자(날짜수)로 리턴
-- period_diff() : yyyymm 포맷끼리 비교 가능- 두 날짜 사이의 경과개월수 계산
SELECT DATEDIFF(NOW(), hire_date), 
truncate(DATEDIFF(NOW(), hire_date)/7, 0) 경과주수, 
truncate(DATEDIFF(NOW(), hire_date)/365, 0) 경과년수,
PERIOD_DIFF(date_format(NOW(), "%Y%m"), DATE_FORMAT(hire_date, "%Y%m")) 경과개월수
FROM employees;


-- 트랜잭션 - 여러 개 작업 논리 결합
-- 여러개 sql 실행 - (1개의 분리할 수 없는 덩어리) : 계좌이체 1개 작업
-- a-b 이체 도중
-- a 출금(ok)-(x)-> b 입금(x)  // 이미 처리 sql 취소
-- a 출금(ok)-----> b 입금(ok) // 2개 sql db 영구 반영
-- all or nothing 
-- tcl -> transaction control language
-- commit / rollback 
-- tcl 명령어1 :  commit : 영구 반영
-- tcl 명령어2 : rollback : 최초 상태로 리셋

-- 마리아 db 변수
SHOW VARIABLES LIKE '%auto%';
-- autocommit ON : maria db는 모든 sql문 실행시 자동적으로 commit함 (사용자가 제어X)

-- autocommit OFF 하는법
SET autocommit = FALSE;

