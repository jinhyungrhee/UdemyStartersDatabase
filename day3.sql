-- SUSAN과 같은 급여를 받는 사원의 이름, 급여 조회
SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY=(SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='SUSAN');

-- KELLY 보다 급여를 더 많이 받는 사람의 이름, 급여 조회
SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='WILLIAM');

-- WILLIAM 과 같은 급여를 받는 사원의 이름, 급여 조회
SELECT FIRST_NAME, SALARY
FROM employees
WHERE SALARY = ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME='WILLIAM'); -- IN과 동일한 문법!

-- MARIA DB 변수 사용 (@)
-- CONNECTION이 연결되었을 때만 임시적으로 사용하는 변수
SET @NAME = 'PETER';

SELECT FIRST_NAME, SALARY
FROM EMPLOYEES
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEES WHERE FIRST_NAME=@NAME);

-- 부서의 최대급여 사원 이름 급여 조회
SELECT first_name, salary, department_id 
FROM employees
WHERE (department_id, salary) IN 
(SELECT department_id, MAX(salary) FROM employees GROUP BY department_id)
ORDER BY department_id;

-- subquery 중첩 - 테이블 여러 개 필요

-- locations 테이블 - 각 부서가 위치한 도시 정보
-- departments 테이블 - 부서이름, 부서장, 도시코드 
-- employees 테이블 - 사원이름, ... , 부서코드     

-- 1.런던 도시코드 조회
SELECT location_id FROM locations WHERE city='london';

-- 2. 런던 도시코드와 같은 도시코드, 부서코드 조회
SELECT department_id FROM departments WHERE location_id=2400;

-- 3. .해당 부서에 근무하는 사원 조회
SELECT first_name, department_id FROM employees
WHERE department_id=40;

-- 4. subquery로 변경
SELECT first_name, department_id FROM employees
WHERE department_id=(SELECT department_id FROM departments WHERE location_id=
							(SELECT location_id FROM locations WHERE city='london')
							);
							
						
-- 각 부서별 최대급여 이름, 급여, 부서번호 *****
SELECT first_name, salary, department_id 
FROM employees
WHERE (department_id, salary) IN 
(SELECT department_id, MAX(salary) FROM employees GROUP BY department_id)
ORDER BY department_id;

-- 부서의 평균급여보다 더 많이 받는 사원의 이름,급여,부서번호 조회
SELECT first_name, salary, department_id 
FROM employees
WHERE (department_id, salary) > ANY  
(SELECT department_id, AVG(salary) FROM employees GROUP BY department_id)
ORDER BY department_id;
-- > 내부서번호는 아래 부서번호보다 커야하며 평균 급여보다 커야함(잘못된 쿼리)

-- **연관쿼리 사용**
-- 어느 부서나 1개 부서의 평균 급여보다 더 많이 받는 사원 급여, 부서번호 조회 (의미없는 쿼리)
SELECT salary, department_id , 
(SELECT AVG(salary) FROM employees WHERE ?)
FROM employees 
WHERE salary > ANY (SELECT AVG(salary) FROM employees GROUP BY department_id);
							
-- 내부서의 평균급여보다 더 많이 받는 사원의 급여, 부서번호 조회
SELECT salary, department_id , 
(SELECT AVG(salary) FROM employees WHERE e.department_id=department_id)
FROM employees e 
WHERE salary > ANY (SELECT AVG(salary) FROM employees WHERE e.department_id=department_id);

-- 모든 subquery는 독립적으로 실행가능하지만, 
-- 연관 subquery는 독립적으로 실행될 수 없음 -> 외부쿼리의 내용과 결합(연관)되어 쿼리 진행함
-- -> 바깥쪽에 있는 데이터와 비교가 필요하기 때문! (= 두 부서가 일치할 때만 출력)


-- inline view : from 절에 들어가는 subquery **
/*
select (select)
from (select 결과 1개 가상테이블 -> inline view)
where (select)
*/

-- 10000 이상의 급여를 받는 사람들의 평균
-- 일반 쿼리 (employees 전체에 대해서 조회 가능)
SELECT AVG(salary)
FROM employees
WHERE salary >= 10000;

-- inline view - 한 개의 가상의 테이블처럼 사용
-- 가상의 테이블에 대해서만 조회 가능 (employees 전체에 대해서 조회 불가) -> 미리 제한, alias 사용
-- 데이터베이스 보안 목적, 필요한 데이터만 사용
SELECT SAL_TBL.AVG_SAL AS 고액월급평균
FROM (SELECT AVG(salary) AVG_SAL FROM employees WHERE salary >= 10000) SAL_TBL; -- 일종의 가상의 테이블 역할

-- 급여 수준에 따라 직급 조회
-- EMPLOYEES 테이블 급여 컬럼 있다, 직급컬럼 없다.
-- 직급 급여 20000 이상 임원, 15000 이상 부장, 10000 이상 과장, 5000 이상 대리, 이하 사원
-- 급여: salary + salary * commission_pct 

SELECT first_name, salary, commission_pct FROM employees;

SELECT MAX(salary), MIN(salary) FROM employees; 

SELECT first_name, 
case 
when salary + salary * IFNULL(commission_pct, 0.1) >= 20000 then '임원'
when salary + salary * IFNULL(commission_pct, 0.1) >= 15000 then '부장'
when salary + salary * IFNULL(commission_pct, 0.1) >= 10000 then '과장'
when salary + salary * IFNULL(commission_pct, 0.1) >= 5000 then '대리'
ELSE	'사원'
END 직급
FROM employees;
-- 올바르지 않은 결과 도출
-- commission_pct 가 null일 경우, 연산식의 결과도 null이 됨!
-- ifnull 함수를 사용하여 다른값으로 변경한 뒤 연산

-- 반복 제거
SELECT first_name,  -- select절은 from절에서 나오는 것만 출력 가능**
case 
when IMSISAL >= 20000 then '임원'
when IMSISAL >= 15000 then '부장'
when IMSISAL >= 10000 then '과장'
when IMSISAL >= 5000 then '대리'
ELSE	'사원'
END 직급
FROM (SELECT first_name, salary + salary * IFNULL(commission_pct, 0.1) AS IMSISAL FROM employees) IMSITABLE; -- 모든 inline from 절은 alias 필요!


-- 최소 급여 받는 사람과 해당 사원 이름 동시 조회 -> subquery 

-- select문 예시
-- SELECT first_name, MIN(salary) FROM employees;
-- select 절에 집계함수가 들어가면 다른 column과 같이 쓸 수 없음
SELECT first_name, salary,
(SELECT MIN(salary) FROM employees) AS 최소급여
FROM employees;

-- update문 예시
-- kelly와 같은 부서의 사원의 부서 100번 부서로 이동
SELECT first_name, department_id FROM emp_copy WHERE department_id=20;

UPDATE emp_copy
SET department_id = 100
WHERE department_id = (SELECT department_id FROM emp_copy WHERE first_name='KELLY');

-- 100번 부서원을 susan의 부서로 이동
UPDATE emp_copy
SET department_id = (SELECT department_id FROM emp_copy WHERE first_name='SUSAN')
WHERE department_id=100;

-- 테이블 조합**
-- 2개의 물리적 테이블로 나누어져 있다가,
-- select 시에만 임시적으로 합쳐서 조회하는 방법

-- 조합할 테이블끼리의 컬럼, 개수, 타입, 순서가 정확히 일치해야 함!
-- 키워드 : UNION, UNION ALL, INTERSECT, MINUS(maria db - EXCEPT)
-- UNION : 합집합 생성
-- INTERSECT : 교집합 생성
-- A MINUS/EXCEPT B : 차집합 (A에서 B를 뺀 나머지 - 순수한 A)

-- test
-- 50번 부서의 모든 부서원 복사해서 emp_dept_50 테이블 생성
CREATE TABLE emp_dept_50
(SELECT * FROM employees WHERE department_id=50);
 
 -- manager 계열 직종에 종사하는 사원들 emp_job_man 테이블 생성
 -- job_id - IT_prog, st_man, it_man
 CREATE TABLE emp_job_man
 (SELECT * FROM employees WHERE job_id LIKE '%man%');
 
 SELECT * FROM emp_dept_50;
 SELECT * FROM emp_job_man;
 
 -- 재난 지원금을 지원하려고 함
 -- 대상은 50번 부서원이거나(or) manager 직종으로 한정하여 조회
 -- union 
SELECT employee_id, first_name, department_id, job_id
FROM emp_dept_50
UNION 
SELECT employee_id, first_name, department_id, job_id
FROM emp_job_man
ORDER BY 1;

-- union all : 50번 부서이면서 manager이면 두번 조회(중복조회)
SELECT employee_id, first_name, department_id, job_id
FROM emp_dept_50
UNION ALL 
SELECT employee_id, first_name, department_id, job_id
FROM emp_job_man
ORDER BY 1;

-- intersect 
-- 대상은 50번 부서원이고(and) manager 직종으로 한정하여 조회
SELECT employee_id, first_name, department_id, job_id
FROM emp_dept_50
INTERSECT
SELECT employee_id, first_name, department_id, job_id
FROM emp_job_man
ORDER BY 1;

-- ** except(차집합) : 순서 중요 **
-- 대상은 50번 부서원인데 이중 manager 직종은 제외하여 조회
SELECT employee_id, first_name, department_id, job_id
FROM emp_dept_50
EXCEPT 
SELECT employee_id, first_name, department_id, job_id
FROM emp_job_man
ORDER BY 1;

-- manager 직종 중에 50번 부서원 제외하여 조회
SELECT employee_id, first_name, department_id, job_id
FROM emp_job_man
EXCEPT
SELECT employee_id, first_name, department_id, job_id
FROM emp_dept_50;


-- 집합 연산자 - 2개 테이블의 행 개수 합병 - 행개수 변화
-- join - 2개 테이블 컬럼 개수 합병 - 1개 레코드 열개수 변화
-- subquery, join query

-- 사원명 부서명 조회. 2개 테이블에는 동일한 값을 표현하는 컬럼 존재.
SELECT first_name, department_id FROM employees;

SELECT department_name, department_id FROM departments;

-- inner join
-- 한쪽은 employees에 존재, 다른 하나는 departments에 존재
-- on 조건만 있으면 inner join이든 cross join이든 상관없음 
-- cross join에서 on 조건이 없으면 잘못된 결과가 나옴!
SELECT first_name, department_name
FROM employees INNER JOIN departments 
ON employees.department_id=departments.department_id; 


SELECT first_name, department_name
FROM employees JOIN departments 
ON employees.department_id=departments.department_id; 

-- join에 참여하는 column을 조회할 경우 어느 테이블의 column인지 명시
SELECT e.first_name, e.department_id, d.department_id, d.department_name 
FROM employees e JOIN departments d
ON e.department_id=d.department_id;

/*
select
from a join b on a.컬럼=b.컬럼;
*/ 


-- jobs 테이블 - JOB_ID(직종코드) -> IT_PROG , JOB_TITLE(직종이름) -> ""
-- employees job_id references jobs(job_id)

DESC jobs;
DESC employees;
DESC departments;
DESC locations;

-- 사원 이름, 직종 이름, 급여 조회
SELECT first_name 사원이름, job_title 직종이름, salary 급여
FROM employees e JOIN jobs j
ON e.job_id=j.job_id;

-- 사원이름, 직종이름, 부서이름 조회 (3개 테이블-> join 두 번 사용) : 106명 (총 107명)
-- 단, 급여가 10000 이상인 사원만 대상으로 함
SELECT first_name, job_title, department_name, salary
FROM employees e 
JOIN jobs j ON e.job_id=j.job_id
JOIN departments d ON e.department_id=d.department_id
WHERE salary >= 10000;

-- subquery 중첩 = join 으로 표현 가능
-- seattle 도시에 근무하는 사원의 사원명, 부서명, 도시명 조회
SELECT first_name, department_name, city
FROM departments d
JOIN employees e ON d.department_id=e.department_id
JOIN locations l ON d.location_id=l.location_id
WHERE city='seattle';

-- db 표준 문법 join(=ansi join)
SELECT a, b
FROM atbl JOIN btbl ON a=b;

-- db 종속 (db 종류에 따라 다름)
SELECT a, b
FROM atbl, btbl WHERE a=b;

-- INNER JOIN
-- 기본적인 join = inner join
-- 양쪽 테이블 조건 만족하는 데이터들만 조인해서 가져옴
SELECT first_name, department_name
FROM employees e JOIN departments d ON e.department_id=d.department_id;


SELECT first_name
FROM employees
WHERE department_id IS NULL;


SELECT first_name, department_name
FROM employees e INNER JOIN departments d ON e.department_id=d.department_id;

-- outer join
-- 조건 범위 외부에 있어도 조인(=모든 employees 다 보여줘야 함)
-- 부서 배정되지 않은 사원도 포함해서 보여줌
SELECT first_name, department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id=d.department_id;

-- 부서정보
SELECT * FROM departments;

-- 부서명, 사원명 조회 : 단, 한명의 사원도 소속되지 않은 부서도 포함하여 조인
SELECT first_name, department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id=d.department_id;


SELECT first_name, department_name
FROM departments d RIGHT OUTER JOIN employees e  ON e.department_id=d.department_id;

-- 부서명 사원명 조회,
-- 단 1명의 사원도 소속되지 않은 부서도, 소속 부서 없는 사원도 포함하여 조인
-- maria db에는 full outer join은 없음! -> left outer join과 right outer join을 union으로 묶어줌
SELECT first_name, department_name
FROM employees e LEFT OUTER JOIN departments d ON e.department_id=d.department_id
UNION
SELECT first_name, department_name
FROM employees e RIGHT OUTER JOIN departments d ON e.department_id=d.department_id;


-- 모든 컬럼 다(*) 보여주기
SELECT e.*, department_name
FROM employees e JOIN departments d ON e.department_id=d.department_id;

-- subquery와 join은 같은 결과(쿼리)
DESC countries;
DESC regions;


-- seattle에서 근무하는 사원의 이름, 부서명, 국가, 대륙, 조회
-- kimberely 제외한 106명(inner 조인)에 대해서 결과를 가져옴
SELECT first_name, department_name,  country_name, region_name
FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
JOIN regions r ON c.region_id=r.region_id;

/*
SELECT inform.emp, dept, coun, re, city
FROM (
	SELECT first_name emp, department_name dept, city,  country_name coun, region_name re
	FROM employees e
	JOIN departments d ON e.department_id=d.department_id
	JOIN locations l ON d.location_id=l.location_id
	JOIN countries c ON l.country_id=c.country_id
	JOIN regions r ON c.region_id=r.region_id
) inform -- inline view를 사용할 때는 alias 반드시 필요!
WHERE city='seattle';
*/

-- join과 inline view를 함께 사용하는 경우 - 조금 더 단순화하여 표현 **
SELECT inform.emp, dept, coun, re, city
FROM (
	SELECT first_name emp, department_name dept, city,  country_name coun, region_name re
	FROM employees e
	JOIN departments d ON e.department_id=d.department_id
	JOIN locations l ON d.location_id=l.location_id
	JOIN countries c ON l.country_id=c.country_id
	JOIN regions r ON c.region_id=r.region_id
	WHERE l.city='seattle'
) inform;
-- inform에 seattle만 포함해서 가져오는 것!


-- 자체조인(SELF JOIN)
-- 조인 대상 테이블이 자신 테이블임
DESC employees;

SELECT employee_id, manager_id FROM employees;

-- 각 사원의 정보 중에서 상사 사번 컬럼 포함
-- 내 상사의 이름, 급여 조회
SELECT manager_id FROM employees WHERE employee_id=150; -- 101

SELECT first_name, salary, employee_id FROM employees WHERE employee_id=145;

-- 두 번에 나눠서 하던 것을 한번에 합침
-- 1. subquery 사용
SELECT first_name, salary, employee_id FROM employees 
WHERE employee_id IN (SELECT manager_id FROM employees WHERE employee_id=150);


-- 2. self join (반드시 alias 필요!)
SELECT ME.employee_id 내사번, ME.first_name 내이름, ME.manager_id, MAN.employee_id, MAN.first_name 상사이름
FROM employees ME JOIN employees MAN
ON ME.manager_id=MAN.employee_id

SELECT * FROM employees WHERE manager_id IS NULL;

-- 내 사번, 내 이름, 내 상사의 사번, 상사의 이름 조회하되 상사가 없는 사원 포함하여 조회(outer join)
SELECT ME.employee_id 내사번, ME.first_name 내이름, ME.manager_id, MAN.employee_id, MAN.first_name 상사이름
FROM employees ME left outer JOIN employees MAN
ON ME.manager_id=MAN.employee_id

-- (NULL 없애기)
SELECT ME.employee_id 내사번, ME.first_name 내이름, ME.manager_id, MAN.employee_id, IFNULL(MAN.first_name, 'BOSS') 상사이름
FROM employees ME left outer JOIN employees MAN
ON ME.manager_id=MAN.employee_id

-- 부하직원이 없는 상사들 함께 조회
SELECT ME.employee_id 내사번, ME.first_name 내이름, ME.manager_id, MAN.employee_id, MAN.first_name 상사이름
FROM employees ME right outer JOIN employees MAN
ON ME.manager_id=MAN.employee_id