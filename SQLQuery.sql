-------------------------------------------------<< VIEWS >>--------------------------------------------

/*1- This is a Summary View for the HR Manger over their department*/

CREATE View HR 
AS
	SELECT 
		COUNT(e.EmployeeID) Total_Employees,
		SUM(e.Salary) Total_Salary,
		AVG(e.Salary) Average_Salary,
		AVG(r.ManagerRate) Average_Performance
	FROM Employee e, Review r
	WHERE e.EmployeeID = r.EmployeeID
	 AND e.Attrition = 'No' and e.DepartmentID = 1
Go
select * from HR



/*2- This is a Summary View for the Sales Manger over their department*/

CREATE View Sales 
AS
	SELECT 
		COUNT(e.EmployeeID) Total_Employees,
		SUM(e.Salary) Total_Salary,
		AVG(e.Salary) Average_Salary,
		AVG(r.ManagerRate) Average_Performance
	FROM Employee e, Review r
	WHERE e.EmployeeID = r.EmployeeID
	 AND e.Attrition = 'No' and e.DepartmentID = 2
Go
select * from Sales



/*3- This is a Summary View for the Technology Manger over their department*/

CREATE View Technology 
AS
	SELECT 
		COUNT(e.EmployeeID) Total_Employees,
		SUM(e.Salary) Total_Salary,
		AVG(e.Salary) Average_Salary,
		AVG(r.ManagerRate) Average_Performance
	FROM Employee e, Review r
	WHERE e.EmployeeID = r.EmployeeID
	 AND e.Attrition = 'No' and e.DepartmentID = 3
Go
select * from Technology


/*4- View to display Active Employees in the company*/

Create view ActiveEmployees
as 
select * from Employee
where Attrition = 'No'
Go
select * from ActiveEmployees

/**************************************************************/

--View --2
/*Rating for employees' satisfaction with their environment. 
(Count 1, 2, 3, 4, and 5) separately.*/
GO
CREATE VIEW environment_satisfaction AS
	SELECT EnvironmentSatisfaction Environment_satisfaction_rate, COUNT(EmployeeID) Employee_count
	FROM Review
	GROUP BY EnvironmentSatisfaction
GO
SELECT * 
FROM environment_satisfaction
ORDER BY Environment_satisfaction_rate
DROP VIEW environment_satisfaction --drop view


/**************************************************************/
--View --3
/*Rating for employees' satisfaction with their job role. 
(Count 1, 2, 3, 4, and 5) separately.*/
GO
CREATE VIEW job_satisfaction AS
	SELECT JobSatisfaction job_satisfaction_rate, COUNT(EmployeeID) employee_count
	FROM Review
	GROUP BY JobSatisfaction
GO
SELECT *
FROM job_satisfaction
ORDER BY job_satisfaction_rate
DROP VIEW job_satisfaction --drop view

/**************************************************************/
--View --4
/*Rating for employees' satisfaction with their relationships at work. 
(Count 1, 2, 3, 4, and 5) separately.*/
GO
CREATE VIEW relationships_satisfaction AS
	SELECT RelationshipSatisfaction relationship_satisfaction_rate, COUNT(EmployeeID) employee_count
	FROM Review
	GROUP BY RelationshipSatisfaction
GO
SELECT *
FROM relationships_satisfaction
ORDER BY relationship_satisfaction_rate
DROP VIEW relationships_satisfaction --drop view


/**************************************************************/
--View --5
/*Rating for employees' satisfaction with their work-life balance. 
(Count 1, 2, 3, 4, and 5) separately.*/
GO
CREATE VIEW work_life_balance_satisfaction AS
	SELECT WorkLifeBalance workLife_balance_rate, COUNT(EmployeeID) employee_count
	FROM Review
	GROUP BY WorkLifeBalance
GO
SELECT *
FROM work_life_balance_satisfaction
ORDER BY workLife_balance_rate
DROP VIEW work_life_balance_satisfaction --drop view


/**************************************************************/
--View --6
/*Rating for employees' performance based on their own views. 
(Count 3, 4, 5) separately.*/
GO
CREATE VIEW self_rate AS
	SELECT SelfRate self_rate, COUNT(EmployeeID) employee_count
	FROM Review
	GROUP BY SelfRate
GO
SELECT *
FROM self_rate
ORDER BY self_rate
DROP VIEW self_rate --drop view





-------------------------------------------------<< Queries >>-------------------------------------------------------------------------------

-- 1- Retrive for each Department its' name , total number of employee , total salary , Cume_Dist and STD

SELECT d.DepartmentName, COUNT(e.FirstName) as Number_Employees
       , SUM(e.Salary) as Total_Salary , CUME_DIST() OVER(ORDER BY SUM(e.Salary)) AS CUM_DIST 
       ,STDEV(SUM(e.Salary)) over (order by SUM(e.Salary) DESC) as The_difference_between_your_salary_each_department_and_another
FROM Employee e, Department d 
WHERE d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName
ORDER BY Total_Salary DESC

-- 2- Retrive for each Department its' name , MAX SALARY , Average_Salary, Minumum_Salary

SELECT d.DepartmentName, MAX(e.Salary) Maxmimum_Salary , AVG(e.Salary) Average_Salary ,MIN(e.Salary) Minumum_Salary
FROM Employee e, Department d
WHERE d.DepartmentID = e.DepartmentID
GROUP BY d.DepartmentName


-- 3- Retrive for each Department its' name , Employee_Name , EducationLevel , DepartmentName ,Salary , YearsSinceLastPromotion

SELECT e.FirstName + ' ' +e.LastName as Employee_Name , ed.EducationLevel , ed.EducationField
       ,d.DepartmentName, e.Salary , h.YearsSinceLastPromotion
FROM Employee e, Department d, Education ed, History h
WHERE d.DepartmentID = e.DepartmentID 
 AND e.EmployeeID = ed.EmployeeID 
 AND e.EmployeeID = h.EmployeeID
GROUP BY d.DepartmentName,ed.EducationLevel , e.FirstName , e.LastName , ed.EducationField, h.YearsSinceLastPromotion , e.Salary 
HAVING AVG(e.Salary) < (select AVG(Salary) from Employee)
ORDER BY d.DepartmentName, e.Salary DESC



-- 4- Get the max 5 salaries??? 

SELECT top(5) Salary
FROM Employee
ORDER BY Salary DESC



-- 5- Average of employees' age.

SELECT AVG(Age ) [Average Age for Employee]
FROM Employee 



--  6- How many employees age from 25 to 40 and from 40 to 60?

SELECT COUNT(*) AS 'Number of Employees'
FROM Employee
WHERE Age BETWEEN 25 AND 40 OR Age BETWEEN 40 AND 60;



-- 7- Count the number of employees in each department then rank them in ascending order.

SELECT DepartmentID, COUNT(*) AS NumberOfEmployees
FROM Employee
GROUP BY DepartmentID
ORDER BY NumberOfEmployees ASC;

--Query --9
--What is the most frequently reviewed month for employees?
SELECT TOP 5 MONTH(ReviewDate) review_month, COUNT(ReviewID) no_of_reviews
FROM Review
GROUP BY MONTH(ReviewDate)
ORDER BY no_of_reviews DESC


/**************************************************************/
--Query --10
--What is the job that employees are most satisfied with?
SELECT e.JobRole, COUNT(*) employee_count
FROM Employee e
JOIN Review r
ON r.EmployeeID = e.EmployeeID
WHERE r.JobSatisfaction = 5 AND e.Attrition = 'No'
GROUP BY e.JobRole, r.JobSatisfaction
ORDER BY employee_count DESC


/**************************************************************/
--Query --11
--What is the job that employees are least satisfied with?
SELECT TOP 10 e.JobRole, COUNT(*) employee_count
FROM Employee e
JOIN Review r
ON r.EmployeeID = e.EmployeeID
WHERE r.JobSatisfaction = 1 AND e.Attrition = 'No'
GROUP BY e.JobRole, r.JobSatisfaction
ORDER BY employee_count DESC


/**************************************************************/
--Query --12
/*Who is the best employees in each department (have the same rank)
from the manager's point of view? (ManagerRating)*/
SELECT *
FROM (
	SELECT DISTINCT e.FirstName + ' ' + e.LastName full_name, d.DepartmentName
					,DENSE_RANK() OVER(PARTITION BY d.DepartmentName ORDER BY AVG(r.ManagerRate) DESC) dr_best_average --with duplicates
					,ROW_NUMBER() OVER(PARTITION BY d.DepartmentName ORDER BY AVG(r.ManagerRate) DESC) rn_best_average --without duplicates
	FROM Employee e
	JOIN Department d
	ON e.DepartmentID = d.DepartmentID
	JOIN Review r
	ON r.EmployeeID = e.EmployeeID 
	WHERE e.Attrition = 'No'
	GROUP BY d.DepartmentName, e.FirstName + ' ' + e.LastName
) AS average_table
WHERE dr_best_average = 1


/**************************************************************/
--Query --13
/*Know the number of male employees and the number of female employees in the company.  
(in each department)*/
SELECT e.DepartmentID, d.DepartmentName, e.Gender, COUNT(e.gender) gender_count
FROM Employee e
JOIN Department d
ON e.DepartmentID = d.DepartmentID
WHERE e.Gender = 'Male' OR e.Gender = 'Female' AND e.Attrition = 'No'
GROUP BY e.Gender, e.DepartmentID, d.DepartmentName
ORDER BY e.DepartmentID, gender_count DESC


/**************************************************************/
--Query --16
/*How many employees' age is greater than the average of all employees' age?*/
SELECT COUNT(*)
FROM Employee
WHERE Age > (
	SELECT AVG(Age)
	FROM Employee
) AND Attrition = 'No'


/**************************************************************/
--Query --17
/*Count Frequency of the three categories of business travel*/
SELECT BusinessTravel, COUNT(*) business_travel_frequency 
FROM Employee
WHERE BusinessTravel IS NOT NULL AND Attrition = 'No'
GROUP BY BusinessTravel
ORDER BY COUNT(*) DESC


/**************************************************************/
--Query --19
/*How many employees are more than 35 km away from work? and What is their average age?*/
SELECT COUNT(EmployeeID) employee_count, AVG(Age) average_age
FROM Employee
WHERE DistanceFromHome > 35 AND Attrition = 'No'


/**************************************************************/
--Query --20
/*What is the number of employees in each state and what are their departments?*/
SELECT d.DepartmentName, e.State, COUNT(e.EmployeeID) employees_number
FROM Employee e, Department d
WHERE e.DepartmentID = d.DepartmentID
AND e.State IS NOT NULL AND e.Attrition = 'No'
GROUP BY e.State, d.DepartmentName


/**************************************************************/
--Query --21
/*Does the level of education affect the job role or salary?*/
--From the result we fined that level 5 in education affects the salay in a good way
SELECT ed.EducationLevel, AVG(em.Salary) average_salary
FROM Employee em, Education ed
WHERE ed.EmployeeID = em.EmployeeID
AND em.Attrition = 'No'
GROUP BY EducationLevel
ORDER BY AVG(em.Salary) DESC


/**************************************************************/
--Query --22
/*How many employees are in each job role?*/
SELECT JobRole, COUNT(EmployeeID) employees_count
FROM Employee
WHERE JobRole IS NOT NULL AND Attrition = 'No'
GROUP BY JobRole
ORDER BY employees_count DESC


/**************************************************************/
--Query --23
/*What is the average salary for each job role?*/
SELECT JobRole, AVG(Salary) average_salary
FROM Employee
WHERE JobRole IS NOT NULL AND Attrition = 'No'
GROUP BY JobRole
ORDER BY AVG(Salary) DESC


/**************************************************************/
--Query --24
/*What is the count of "yes" and"no" in overtime for each job role?*/
SELECT JobRole, COUNT(OverTime) yes_OverTime
FROM Employee
WHERE OverTime = 'Yes' AND Attrition = 'No'
GROUP BY JobRole
ORDER BY COUNT(OverTime) DESC

SELECT JobRole, COUNT(OverTime) no_OverTime
FROM Employee
WHERE OverTime = 'No' AND Attrition = 'No'
GROUP BY JobRole
ORDER BY COUNT(OverTime) DESC


/**************************************************************/
--Query --25
/*What is the most and least hiring year?*/
--From the insights we see that 2022 is the most hiring year and 2017 is the least hiring year
SELECT YEAR(HireDate) hiring_year, COUNT(EmployeeID) employee_count
FROM Employee
WHERE YEAR(HireDate) IS NOT NULL
GROUP BY YEAR(HireDate)
ORDER BY employee_count DESC


/**************************************************************/
--Query --26
/*Does gender affect performance?*/
--From the insights we see that gender doesn't affect the performance
SELECT Gender, AVG(ManagerRate) average_manager_rate
FROM Employee e, Review r
WHERE r.EmployeeID = e.EmployeeID
AND Gender IN ('Male', 'Female') AND e.Attrition = 'No'
GROUP BY Gender


/**************************************************************/
--Query --27
/*What is the state which has the best employees?*/
--We see that all states have the same average employees rate, so there is not the best state
SELECT State, AVG(ManagerRate) average_manager_rate
FROM Employee e, Review r
WHERE r.EmployeeID = e.EmployeeID
AND State IS NOT NULL AND e.Attrition = 'No'
GROUP BY State

