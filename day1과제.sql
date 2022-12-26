-- day1 실습

DESCRIBE employees;

-- 기본 -- 
/*
1. 직원 중에서 연봉이 170000 이상인 직원들의 이름, 연봉을 조회하시오.
  연봉은 급여(salary)에 12를 곱한 값입니다.
단, 이름은 "이름", 연봉은 "월급의 12배"로 출력되도록 조회하시오.
*/

SELECT first_name AS '이름', salary * 12 AS '월급의 12배' 
FROM employees
WHERE (salary * 12) >= 170000; 


/*
2. 직원 중에서 manager_id가 없는 직원의 이름과 급여를 조회하시오.
*/

SELECT first_name AS '이름' , salary AS '급여'
FROM employees
WHERE manager_id IS NULL;

/*
3. 2004년 이전에 입사한 직원의 이름, 급여, 입사일을 조회하시오.
*/
SELECT first_name AS '이름', salary AS '급여', hire_date AS '입사일'
FROM employees
WHERE hire_date < '2004-01-01';

/*
4. departments 테이블에서 부서코드, 부서명을 조회하시오.
*/
DESCRIBE departments;

SELECT department_id AS '부서코드',  department_name AS '부서명'
FROM departments;

/*
5. jobs 테이블에서 직종코드와 직종명을 조회하시오.
*/
DESCRIBE jobs;

SELECT job_id AS '직종코드' , job_title AS '직종명'
FROM jobs;

-- 논리 연산자--
/*
1. 80, 50 번 부서에 속해있으면서 급여가 13000 이상인 직원의 이름, 급여, 부서id를 조회하시오.
*/
SELECT first_name AS '이름', salary AS '급여', department_id AS '부서id'
FROM employees
WHERE (department_id = 80 OR department_id = 50) AND salary >= 13000;

/*
2. 2005년 이후에 입사한 직원들 중에서 급여가 1300 이상 20000 이하인 직원들의 
이름, 급여, 부서id, 입사일을 조회하시오.
*/
SELECT first_name AS '이름', salary AS '급여', hire_date AS '입사일'
FROM employees
WHERE hire_date >= '2005-01-01' AND salary BETWEEN 1300 AND 20000; 


-- SQL 비교 연산자 --

/*
3. 2005년도 입사한 직원의 정보(이름, 급여, 부서코드, 입사일)만 출력하시오.
*/
SELECT first_name AS '이름', salary AS '급여', department_id AS '부서코드', hire_date AS '입사일'
FROM employees
WHERE hire_date LIKE '2005%';

/*
4. 직종이 clerk 군인 직원의 이름, 급여, 직종코드를 조회하시오.
(clerk 직종은 job_id에 CLERK을 포함하거나 CLERK으로 끝난다.)
*/

DESCRIBE employees;

SELECT first_name AS '이름', salary AS '급여', job_id AS '직종코드'
FROM employees
WHERE job_id LIKE '%clerk%';

/*
5. 12월에 입사한 직원의 이름, 급여, 입사일을 조회하시오.
*/

SELECT first_name AS '이름', salary AS '급여', hire_date AS '입사일'
FROM employees
WHERE hire_date LIKE '_____12%';

/*
6. 이름에 le 가 들어간 직원의 이름, 급여, 입사일을 조회하시오.
*/
SELECT first_name AS '이름', salary AS '급여', hire_date AS '입사일'
FROM employees
WHERE first_name LIKE '%le%';

/*
7. 이름이 m으로 끝나는 직원의 이름, 급여, 입사일을 조회하시오.
*/
SELECT first_name AS '이름', salary AS '급여', hire_date AS '입사일'
FROM employees
WHERE first_name LIKE '%m';

/*
8. 이름의 세번째 글자가 d인 이름, 급여, 입사일을 조회하시오.
*/
SELECT first_name AS '이름', salary AS '급여', hire_date AS '입사일'
FROM employees
WHERE first_name LIKE '__d%';

/*
9. 커미션을 받는 직원의 이름, 커미션, 급여를 조회하시오.
*/
SELECT first_name AS '이름',  commission_pct AS '커미션', salary AS '급여'
FROM employees
WHERE commission_pct IS NOT NULL;

/*
10. 커미션을 받지 않는 직원의 이름, 커미션, 급여를 조회하시오.
*/
SELECT first_name AS '이름',  commission_pct AS '커미션', salary AS '급여'
FROM employees
WHERE commission_pct IS NULL;

-- 기타 --
/*
1. 30, 50, 80 번 부서에 속해있으면서, 급여를 5000 이상 17000 이하를 받는 직원을 조회하시오. 
단, 커미션을 받지 않는 직원들은 검색 대상에서 제외시키며, 먼저 입사한 직원이 먼저 출력되어야 하며
입사일이 같은 경우 급여가 많은 직원이 먼저 출력되도록 하시오.
*/
SELECT first_name AS '이름', salary AS '급여' , department_id AS '부서번호', hire_date AS '입사일', commission_pct AS '커미션'
FROM employees
WHERE department_id IN('30', '50', '80') AND salary BETWEEN 5000 AND 17000 AND commission_pct IS NOT NULL
ORDER BY hire_date, salary desc;


/*
2. 각 부서별 최대급여와 최소급여를 조회하시오.
   단, 최대급여와 최소급여가 같은 부서는 직원이 한명일 가능성이 높기때문에 조회결과에서 제외시킨다.
*/


SELECT department_id AS '부서번호', MAX(salary) AS '최대급여', MIN(salary) AS '최소급여'
FROM employees
GROUP BY department_id
HAVING MAX(salary) != MIN(salary);



/*
3. 각 부서별 인원수를 조회하되 인원수가 5명 이상인 부서만 출력되도록 하시오.
*/

DESCRIBE employees;

SELECT department_id AS '부서번호', COUNT(employee_id) AS '인원수'
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) >= 5;
