-- day3 과제 리뷰

-- 1. 80번 부서의 평균급여보다 많은 급여를 받는 직원
-- 27개
SELECT first_name, department_id, salary, (SELECT AVG(salary) FROM employees WHERE department_id=80)
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id=80); -- 8955

-- 2
-- 69개
SELECT first_name, salary, d.department_name, e.department_id
FROM employees e
JOIN departments d
ON e.department_id=d.department_id
WHERE salary > (SELECT MIN(salary) -- join / subquery 둘다 동일한 결과 리턴
from locations l 
JOIN departments d ON l.location_id=d.location_id
JOIN employees e ON d.department_id=e.department_id
WHERE city="South San Francisco"
)
AND salary > (SELECT AVG(salary) FROM employees WHERE department_id=50);


SELECT first_name, salary, d.department_name, e.department_id
FROM employees e
JOIN departments d
ON e.department_id=d.department_id
WHERE salary > (SELECT AVG(salary) FROM employees WHERE department_id=50);


-- 3-1
-- 19개
SELECT job_title, COUNT(*)
FROM jobs j LEFT OUTER JOIN employees e ON e.job_id=j.job_id
GROUP BY job_title;

-- 3-2
-- 3개
SELECT job_title, COUNT(*)
FROM jobs j LEFT OUTER JOIN employees e ON e.job_id=j.job_id
GROUP BY job_title
HAVING COUNT(*) >= 10;

-- 4
-- 11개
SELECT first_name, department_name, salary
FROM employees e JOIN departments d ON e.department_id=d.department_id
WHERE (e.department_id, salary) = ANY (SELECT department_id, MAX(salary) FROM employees GROUP BY department_id); 
-- subquery는 다중열도 비교 가능
-- =ANY() 와 IN은 동일한 문법! (다중열 subquery에 사용)

-- 5
-- 107개
-- 상관형 subquery 사용
SELECT first_name 직원이름, department_id 부서코드, salary 내급여,
(SELECT MIN(salary) FROM employees WHERE e.department_id=department_id) 내부서의최소급여 -- 상관형(연관형) 서브쿼리 -> 바깥쪽 메인쿼리와 관련되기 때문에 단독 실행 불가
FROM employees e

-- 6
SELECT hire_month, COUNT(hire_month)
FROM  (SELECT -- inline view
case 
when hire_date LIKE '_____01%' then '01'
when hire_date LIKE '_____02%' then '02'
when hire_date LIKE '_____03%' then '03'
when hire_date LIKE '_____04%' then '04'
when hire_date LIKE '_____05%' then '05'
when hire_date LIKE '_____06%' then '06'
when hire_date LIKE '_____07%' then '07'
when hire_date LIKE '_____08%' then '08'
when hire_date LIKE '_____09%' then '09'
when hire_date LIKE '_____10%' then '10'
when hire_date LIKE '_____11%' then '11'
when hire_date LIKE '_____12%' then '12'
END hire_month FROM employees) imsi
GROUP BY hire_month
ORDER BY 1;


-- 7
-- 2개
SELECT e1.first_name 직원이름, e1.salary 직원급여, e2.first_name 상사이름, e2.salary 상사급여
FROM employees e1 JOIN employees e2 ON e1.manager_id=e2.employee_id
WHERE e1.salary > e2.salary;

-- 8
-- 5개
SELECT first_name, salary, job_title
FROM employees e 
JOIN departments d ON d.department_id=e.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN jobs j ON e.job_id=j.job_id
WHERE city="Southlake";

-- 9
-- 2개
SELECT country_name, COUNT(*)
FROM employees e
JOIN departments d ON d.department_id=e.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN countries c ON l.country_id=c.country_id
GROUP BY c.country_name
HAVING COUNT(*) >= 3;

-- 10
-- 107개
SELECT e1.phone_number 직원폰번호, e1.email 직원이메일, 
IFNULL(e2.phone_number, '<관리자없음>') 상사폰번호, IFNULL(e2.email, '<관리자없음>') 상사이메일
FROM employees e1 left outer JOIN employees e2 ON e1.manager_id=e2.employee_id;

-- 11
-- 8개
SELECT department_name, MAX(salary), MIN(salary)
FROM departments D JOIN employees E ON d.department_id=e.department_id
GROUP BY department_name
HAVING MAX(salary) != MIN(salary);

-- 12
-- 17개
SELECT department_id, job_id, AVG(salary)
FROM employees
GROUP BY department_id, job_id
HAVING AVG(salary) > (SELECT AVG(salary) FROM employees WHERE department_id=50);