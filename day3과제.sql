-- join subquery 실습 --
-- 1. 80번부서의 평균급여보다 많은 급여를 받는 직원의 이름, 부서id, 급여를 조회하시오.
SELECT AVG(salary) FROM employees WHERE department_id=80; -- 8955.88

SELECT first_name, department_id, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id=80);

-- 2. 'South San Francisco'에 근무하는 직원의 최소급여보다 급여를 많이 받으면서 
-- 50 번부서의 평균급여보다 많은 급여를 받는 직원의 이름, 급여, 부서명, 부서id를 조회하시오.

DESC employees;
DESC departments;
DESC locations;
SELECT * FROM locations;

-- SELECT department_id FROM departments WHERE location_id=(SELECT location_id FROM locations WHERE city='South San Francisco');

SELECT first_name, salary, d.department_name, d.department_id
FROM employees e 
JOIN departments d ON e.department_id=d.department_id
WHERE salary > (SELECT MIN(salary) FROM employees WHERE department_id=(SELECT department_id FROM departments WHERE location_id=(SELECT location_id FROM locations WHERE city='South San Francisco'))) -- 2100
AND salary > (SELECT AVG(salary) FROM employees WHERE department_id=50); -- 3,475.555

-- 3-1.각 직급별(job_title) 인원수를 조회하되 사용되지 않은 직급이 있다면 해당 직급도 출력결과에 포함시키시오. 

DESC jobs;
DESC employees;

SELECT * FROM employees;
SELECT * FROM jobs;

SELECT COUNT(employee_id), job_title
FROM employees e right outer JOIN jobs j ON e.job_id=j.job_id
GROUP BY j.job_id;

-- 3-2. 직급별 인원수가 10명 이상인 직급만 출력결과에 포함시키시오.
SELECT COUNT(employee_id), job_title
FROM employees e right outer JOIN jobs j ON e.job_id=j.job_id
GROUP BY j.job_id
HAVING COUNT(employee_id) >= 10;


-- 4. 각 부서별 최대급여를 받는 직원의 이름, 부서명, 급여를 조회하시오.
SELECT first_name, d.department_name, salary
FROM employees e
JOIN departments d ON e.department_id=d.department_id
WHERE (e.department_id, salary) IN (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id);


-- 5. 직원의 이름, 부서id, 급여를 조회하시오. *****
-- 그리고 직원이 속한 해당 부서의 최소급여를 마지막에 포함시켜 출력 하시오.
SELECT e.first_name, e.department_id, e.salary, tmpSalary
FROM employees e
JOIN 
(SELECT MIN(salary) AS tmpSalary, department_id
FROM employees
GROUP BY department_id) TEMP
ON e.department_id=TEMP.department_id;




-- 6. 월별 입사자 수를 조회하되, 입사자 수가 10명 이상인 월만 출력하시오. ******
SELECT MONTH(hire_date) 입사월, COUNT(employee_id) 입사자수
FROM employees
GROUP BY MONTH(hire_date)
HAVING COUNT(employee_id) >= 10;


-- 7. 자신의 관리자(상사)보다 많은 급여를 받는 직원의 이름과 급여를 조회하시오.
SELECT ME.first_name, ME.salary
FROM employees ME 
JOIN employees MAN ON ME.manager_id=MAN.employee_id
WHERE ME.salary > MAN.salary;

-- 8. 'Southlake'에서 근무하는 직원의 이름, 급여, 직책(job_title)을 조회하시오.
SELECT first_name, salary, job_title
FROM employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN jobs j ON e.job_id=j.job_id
WHERE l.city='Southlake';


-- 9. 국가별 근무 인원수를 조회하시오. 단, 인원수가 3명 이상인 국가정보만 출력되어야함.

SELECT l.country_id, COUNT(employee_id)
FROM employees e
JOIN departments d ON d.department_id=e.department_id
JOIN locations l ON d.location_id=l.location_id
GROUP BY country_id
HAVING COUNT(employee_id) >= 3;

-- 10. 직원의 폰번호, 이메일과 상사의 폰번호, 이메일을 조회하시오.
-- 단, 상사가 없는 직원은 '<관리자 없음>'이 출력되도록 해야 한다.
SELECT * FROM employees;

SELECT ME.phone_number, ME.email, MAN.phone_number, MAN.email
FROM employees ME
LEFT OUTER JOIN employees MAN ON ME.manager_id=MAN.employee_id;

-- 11. 각 부서 이름별로 최대급여와 최소급여를 조회하시오. 
-- 단, 최대/최소급여가 동일한 부서는 출력결과에서 제외시킨다.
SELECT MIN(salary), MAX(salary), d.department_name
FROM employees e
JOIN departments d ON e.department_id=d.department_id
GROUP BY e.department_id
HAVING MIN(salary) != MAX(salary);


-- 12. 부서별, 직급별, 평균급여를 조회하시오. 
-- 단, 평균급여가 50번부서의 평균보다 많은 부서만 출력되어야 합니다.
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees WHERE department_id=50); -- 3.475.55

