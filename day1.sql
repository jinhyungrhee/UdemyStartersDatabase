# 주석
-- 주석
/* 
여러줄 주석 
*/

-- EMPOYEES 테이블 데이터 조회
SELECT * FROM employees ;
SELECT * FROM departments;
SELECT employee_id, first_name FROM employees;
SELECT employee_id '사 번', first_name '이   름' FROM employees;

DESCRIBE employees;

-- salary (8, 2);

SELECT first_name, salary FROM employees;

-- 연봉 : salary * 12

SELECT first_name, salary AS '월봉', salary*12 AS '연봉' FROM employee


-- 사원이 속한 부서 코드 종류 조회  = 중복말고 1번

SELECT distinct department_id FROM employees;

SELECT last_name, department_id
FROM employees
WHERE department_id = 80;

SELECT employee_id, salary, first_name
FROM employees
WHERE salary >= 10000 AND employee_id < 200;

select salary, first_name
from employees
where salary >= 10000 and salary <= 15000; 

select salary, first_name
from employees
where salary between 10000 and 15000;

select employee_id, salary*1.1 as 인상급여
from employees
where employee_id=10 or employee_id=30 or employee_id=200 or employee_id=150;


select employee_id, salary*1.1 as 인상급여
from employees
where employee_id IN(100, 200, 150, 222);

-- db(maria db - 대소문자 구분X , ' '  , " ") 

SELECT first_name FROM employees WHERE first_name = 'steven'; 

-- s로 시작하는 사원 first_name 조회
SELECT first_name
FROM employees
WHERE first_name LIKE 's%';

-- er로 끝나는 사원의 first_name 조회 
SELECT first_name
FROM employees
WHERE first_name LIKE '%er';


-- 이름이 5글자이면서 er로 끝나는 사원
SELECT first_name
FROM employees
WHERE first_name LIKE '___er';



SELECT first_name, hire_date FROM employees;

DESC employees;

-- 2002년 입사자의 이름, 입사일 조회
SELECT first_name, hire_date 
FROM employees
WHERE hire_date LIKE '2002%';


-- 6월 입사자 조회
SELECT first_name, hire_date 
FROM employees
WHERE hire_date LIKE '_____06%';

-- 커미션 받는 사원

SELECT first_name, commission_pct
FROM employees
WHERE commission_pct IS NOT NULL;


SELECT employee_id FROM employees ORDER BY employee_id LIMIT 10, 10;

-- null 우선(오름차순)
SELECT employee_id, commission_pct FROM employees ORDER BY commission_pct;

-- 내림차순 : null 나중 
SELECT employee_id, commission_pct FROM employees ORDER BY commission_pct DESC;

-- null 먼저 보여주면서 역순으로 보여주기-> 오라클만 가능
-- SELECT employee_id, commission_pct FROM employees ORDER BY commi ssion_pct DESC nulls FIRST;

-- 부서코드 오름차순 , 동일 부서코드인 경우 다음 기준 '급여' (많은 사람부터 조회 - 내림차순)
SELECT first_name, salary, department_id FROM employees ORDER BY department_id, salary DESC;


-- 급여 총합계 평균 , 사원수 ,최대월급, 최저월급 
SELECT SUM(salary), AVG(salary), COUNT(salary), MAX(salary), MIN(salary) FROM employees;

-- 입사일 
SELECT COUNT(hire_date), MAX(hire_date), MIN(hire_date) FROM employees;

-- 커미션 ( NULL 많다) - count() : null 제외 
SELECT COUNT(commission_pct) FROM employees;

-- null 포함 전체 테이블 레코드 수 출력 
SELECT COUNT(*) FROM employees;


--  소속 부서 없는 사원 이름 조회 
SELECT first_name, department_id FROM employees
WHERE department_id IS NULL;

-- 소속 부서가 있는 사원 수 
SELECT COUNT(department_id) FROM employees;


-- 사원 이름, 전체 사원 급여 총합 조회

SELECT first_name, SUM(salary) FROM employees;


-- 부서코드 개수 : Null 제외 
SELECT COUNT( DISTINCT department_id) FROM employees;


-- 50번 부서 사원들의 급여 총합 조회 
SELECT SUM(salary) FROM employees WHERE department_id=50;

-- 각 부서별 사원들의 급여 총합 - GROUP BY [ 컬렴명] 
SELECT department_id, SUM(salary)
FROM employees
GROUP BY department_id;


-- 각 부서별 부서 사원 급여 총합 조회, 단 부서코드 없는 사원 제외 (Null그룹 빼기)
-- where dewartment_id is not null
SELECT department_id, SUM(salary)
FROM employees
WHERE department_id IS NOT null
GROUP BY department_id;

-- 각 부서별, 직종별 부서 사원 급여 총합 조회, 단 부서코드 없는 사원 제외
SELECT department_id, job_id, SUM(salary)
FROM employees
WHERE department_id IS NOT NULL AND job_id IS NOT NULL 
GROUP BY department_id, job_id;

-- 각 부서별 부서 사원 급여총합 조회 
-- 단 부서 코드 없는 사원 제외하고, 급여총합 10만 이상인 부서만 조회 
SELECT department_id, SUM(salary) -- 1번 조회대상 d_id , 2번 조회대상 : sum(salary)
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING SUM(salary) >= 100000
ORDER BY 2 DESC; -- 2번 조회 대상 
-- ORDER BY SUM(salary) DESC;


