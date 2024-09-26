-- BASIC
SELECT * 
FROM employee_demographics;

SELECT *
FROM employee_salary; 

SELECT * 
FROM parks_departments;

-- GROUP BY 
SELECT gender 
FROM Parks_and_Recreation.employee_demographics
GROUP BY gender; 

SELECT gender, SUM(age) as TotalAge
FROM employee_demographics
GROUP BY gender;

SELECT occupation, salary 
FROM employee_salary
GROUP BY occupation, salary;

-- ORDER BY
SELECT * 
FROM employee_demographics
ORDER BY gender desc, age desc;

-- WHERE & HAVING
SELECT gender, AVG(age) as AverageAge
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT occupation, AVG(salary) as AverageSalary
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AverageSalary > 75000;

-- LIMIT
SELECT * 
FROM employee_demographics
WHERE age > 40
ORDER BY age DESC
LIMIT 10;

-- JOIN === INNER JOIN
SELECT dem.employee_id, dem.first_name, gender, age, occupation, salary
FROM employee_demographics as dem
INNER JOIN employee_salary as sal
ON  dem.employee_id = sal.employee_id;

-- LEFT JOIN and RIGHT JOIN
SELECT *
FROM employee_demographics as dem
LEFT JOIN employee_salary as sal
ON  dem.employee_id = sal.employee_id;

SELECT *
FROM employee_demographics as dem
RIGHT JOIN employee_salary as sal
ON  dem.employee_id = sal.employee_id;

-- SELF JOIN
SELECT DISTINCT p1.first_name as employee, p2.occupation 
FROM employee_salary p1
JOIN employee_salary p2
ON p1.employee_id = p2.dept_id;

-- Joining multiple tables together
SELECT * 
FROM employee_demographics emp1
JOIN employee_salary emp2
ON emp1.employee_id = emp2.employee_id
JOIN parks_departments dpt
ON emp2.dept_id = dpt.department_id;

-- UNION & UNION ALL
SELECT first_name, last_name
FROM employee_demographics
UNION
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name, 'Old Man' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'male'
UNION
SELECT first_name, last_name, 'Old Lady' AS Label
FROM employee_demographics
WHERE age > 40 AND gender = 'female'
UNION 
SELECT first_name, last_name, 'Highly Paid Employee' AS Label
FROM employee_salary
WHERE salary > 70000;

-- String Functions
SELECT length('the anh');

SELECT upper('theanh');
SELECT lower('THEANH');

SELECT trim('    theanh      ');
SELECT ltrim('        theanh');
SELECT rtrim('theanh         ');
SELECT left('theanh', 3);
SELECT right('theanh', 2);
SELECT substring('theanh', 2, 4); -- start at 2 position and go on 4 characters

SELECT replace('thwanh', 'w', 'e');
SELECT locate('x','Alexander');

SELECT first_name, last_name, concat(first_name,' ', last_name) AS full_name
FROM employee_demographics;

SELECT first_name, length(first_name)
FROM employee_demographics
ORDER BY 2;   -- Sap xep theo cot thu 2 

-- Case Statements
SELECT first_name, age,
CASE 
	WHEN age <=35 THEN 'Young'
	WHEN age BETWEEN 36 and 50 then 'Old'
    WHEN age >= 50 then "On Death's Door"
END AS Age_Braket
FROM employee_demographics;

SELECT first_name, last_name, salary,
CASE
	WHEN salary < 50000 THEN salary + (salary * 0.05)
    WHEN salary > 50000 THEN salary * 1.07
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS bonus
FROM employee_salary;

-- Subqueries 
SELECT * 
FROM employee_demographics
WHERE employee_id IN (
	SELECT employee_id 
    FROM employee_salary
    WHERE dept_id = 1
);

SELECT gender, `AVG(age)`, max_age
FROM 
(SELECT gender, AVG(age), MAX(age) as max_age, MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender) AS Agg_table;

-- Window Functions
SELECT dem.first_name, gender, SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id ) AS sum_salary
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
SELECT dem.first_name, gender, salary,
ROW_NUMBER() OVER() as row_num,
RANK() OVER(ORDER BY salary DESC) as rank_num,
DENSE_RANK() OVER(ORDER BY salary DESC) as dense_rank_num
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;
    
-- CTEs (Common Table Expressions) 
WITH CTE_Example (Gender, AVG_Age, MAX_Sal) AS
(
SELECT gender, AVG(age), MAX(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT * 
FROM CTE_Example;

WITH CTE_Example1 AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT * 
FROM CTE_Example1 cte1
JOIN CTE_Example2 cte2
	ON cte1.employee_id = cte2.employee_id;
    
-- Temporary Tables
CREATE TEMPORARY TABLE temp_table
(
first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

INSERT INTO temp_table VALUES('Linh', 'Ngo', 'King of kings');

SELECT *
FROM temp_table;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT *
FROM salary_over_50k;

-- Stored Procedures
CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN
	SELECT *
    FROM employee_salary
    WHERE salary >= 50000;
    SELECT * 
    FROM employee_salary
    WHERE salary >= 10000;
END $$
DELIMITER ;

CALL large_salaries2();

CREATE PROCEDURE large_salaries3(salary_num INT)
SELECT *
FROM employee_salary
WHERE salary = salary_num;

CALL large_salaries3(50000);

-- TRIGGERS
DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary
VALUES ('14', 'The Anh', 'Phung', 'Data Analyst CEO', '10000000', NULL);

-- EVENTS
DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
	DELETE
    FROM employee_demgraphics
    WHERE age >= 60;
END $$
DELIMITER ;

SHOW VARIABLES LIKE 'event%';






