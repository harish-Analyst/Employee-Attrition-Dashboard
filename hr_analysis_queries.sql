-- ALL WORKING - IMPORT, AGGREGATION FUNCTION, ATTRITION ANALYSIS, BUSINESS QUERIES -- 
-- IMPORT-- 
create database hr_analytics;
use hr_analytics;
select count(*) from employees;
select * from employees;
drop table employees;
CREATE TABLE employees (
    EmpID INT PRIMARY KEY,                   -- Numeric ID
    Age INT,                                 -- Numeric
    AgeGroup VARCHAR(20),                    -- Text like '20-30'
    Attrition VARCHAR(5),                    -- 'Yes'/'No'
    BusinessTravel VARCHAR(30),     		 -- Text
    DailyRate INT,                           -- Numeric
    Department VARCHAR(50),                  -- Text
    DistanceFromHome INT,                    -- Numeric
    Education INT,                           -- Numeric (1-5)
    EducationField VARCHAR(50),              -- Text
    EmployeeCount INT DEFAULT NULL,          -- Numeric, allow NULL if missing
    EmployeeNumber INT,                       -- Numeric
    EnvironmentSatisfaction INT,             -- Numeric
    Gender VARCHAR(10),                       -- Text ('Male'/'Female')
    HourlyRate INT,                           -- Numeric
    JobInvolvement INT,                       -- Numeric
    JobLevel INT,                             -- Numeric
    JobRole VARCHAR(50),                      -- Text
    JobSatisfaction INT,                      -- Numeric
    MaritalStatus VARCHAR(20),                -- Text
    MonthlyIncome INT,                        -- Numeric
    SalarySlab VARCHAR(20),                   -- Text
    MonthlyRate INT,                          -- Numeric
    NumCompaniesWorked INT DEFAULT NULL,      -- Numeric, allow NULL
    Over18 CHAR(1) DEFAULT 'Y',               -- Single char 'Y' (if always Yes)
    OverTime CHAR(1) DEFAULT NULL,            -- 'Y'/'N'
    PercentSalaryHike INT,                    -- Numeric
    PerformanceRating INT,                    -- Numeric
    RelationshipSatisfaction INT,             -- Numeric
    StandardHours INT,                        -- Numeric
    StockOptionLevel INT,                     -- Numeric
    TotalWorkingYears INT DEFAULT NULL,       -- Numeric, allow NULL
    TrainingTimesLastYear INT,                -- Numeric
    WorkLifeBalance INT,                      -- Numeric
    YearsAtCompany INT,                        -- Numeric
    YearsInCurrentRole INT,                   -- Numeric
    YearsSinceLastPromotion INT,              -- Numeric
    YearsWithCurrManager INT DEFAULT NULL     -- Numeric, allow NULL
);

ALTER TABLE employees
ADD COLUMN temp_id INT AUTO_INCREMENT PRIMARY KEY;

DELETE e1
FROM employees e1
JOIN employees e2
ON e1.EmpID = e2.EmpID
AND e1.temp_id > e2.temp_id;

SELECT EmpID, COUNT(*)
FROM employees
GROUP BY EmpID
HAVING COUNT(*) > 1;

ALTER TABLE employees
DROP COLUMN temp_id;

-- AGGREGATION FUNCTIONS-- 
USE hr_analytics;
DESCRIBE employees;
    
-- change the column name 
ALTER TABLE employees
CHANGE COLUMN ï»¿EmpID EmpID varchar(20);

SELECT * FROM employees;
-- LEVEL (1)

-- Total number of employees in the company.
SELECT 
	count(Empid) 
FROM Employees; 
    
-- Total number of employees in each department.
SELECT 
	department,
    COUNT(Department) AS Total_emp
FROM Employees
GROUP BY Department;

-- How many employees left the company? 
SELECT 
	count(Attrition) AS Left_Compnay
FROM Employees
WHERE Attrition = "Yes";

-- What is the average monthly income of all employees?
SELECT 
	ROUND(AVG(MonthlyIncome),2) AS Avg_Monthly_Income 
FROM Employees;

-- What is the average salary in each department?
SELECT 
	Department,
    round(AVG(Monthlyincome),2)as Each_Dept_salary
FROM Employees
GROUP BY Department;
    
-- What is the maximum and minimum salary in the company?
SELECT
	max(MonthlyIncome) AS Max_Salary,
	min(MonthlyIncome)AS Min_Salary 
FROM Employees;
    
-- Count employees by gender.
SELECT 
	Gender,
	count(EmpID) AS Total_Gender
FROM Employees
GROUP BY Gender;

-- Count employees by education level.
SELECT 
	Education,
    count(EDucation)AS Total_Emp
FROM Employees
GROUP BY Education
ORDER BY Education;

-- Which departments have more than 100 employees?
SELECT 
	Department,
    Count(*) AS Total_Emp
FROM Employees
GROUP BY Department
HAVING Count(*) > 100;

-- Which job roles have average salary greater than 7000?
SELECT 
	JobRole,
    round(AVG(MonthlyIncome),2) AS Avg_Salary
FROM Employees
GROUP BY JobRole
HAVING avg(MonthlyIncome)>7000
ORDER BY Avg_Salary DESC;
    
-- What is the total salary expense per department?
SELECT 
	Department,
    sum(MonthlyIncome)AS Total_Salary_Expense
FROM Employees
GROUP BY Department
ORDER BY Total_Salary_Expense DESC;

-- Show departments where attrition count is greater than 20.
SELECT
	Department,
    count(*) AS Total_Attrition
FROM Employees
WHERE Attrition ="yes"
GROUP BY Department
HAVING Count(*)>20;

-- What is the average years at company per department?
SELECT 
	Department,
    round(AVG(YearsAtCompany),2) AS Avg_Years_at_company
FROM Employees
GROUP BY Department;

-- Which job level has the highest average salary?
SELECT 
	JobLevel,
    round(Avg(MonthlyIncome),2) AS Avg_Salary
FROM Employees
GROUP BY JobLevel
ORDER BY Avg_Salary DESC
LIMIT 1;

-- Count employees who work overtime in each department.
SELECT 
	Department,
    count(*) AS Total_Emp
FROM Employees
WHERE overtime ="yes"
GROUP BY Department;

-- Show employees and label them as:
-- "Senior" - if JobLevel ≥ 4
-- "Mid Level" - if JobLevel = 2 or 3
-- "Junior" - otherwise
SELECT 
	JobLevel,
	(CASE 
		WHEN JobLevel >=4 THEN "Senior"
        WHEN JobLevel IN(2,3) THEN "Mid Level"
	ELSE "Junior"
    END) AS Employee_Level
    FROM Employees
    GROUP BY JObLevel
    ORDER BY JobLevel DESC;
    
-- Count how many employees:
-- Work Overtime
-- Do NOT work Overtime

SELECT 
	sum(CASE WHEN OverTime ="Yes" THEN 1 ELSE 0 END) AS Overtime,
    sum(CASE WHEN OverTime ="No" THEN 1 ELSE 0 END) AS Do_Not_Work_Overtime
    FROM Employees;
    

-- Calculate attrition rate (%) per department.
SELECT 
    Department,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*),
    2) AS Attrition_Rate_Percentage
FROM Employees
GROUP BY Department;

-- Which department has the highest total salary payout?
SELECT 
	department,
    sum(MonthlyIncome) AS Total_Salary
FROM Employees
GROUP BY Department 
ORDER BY Total_Salary DESC
LIMIT 1;

-- Compare average salary of employees who left vs stayed.
SELECT 
	Attrition,
    round(avg(MonthlyIncome),2) AS Avg_salary
FROM Employees
GROUP BY Attrition;

-- Find departments where:
-- Average PerformanceRating >= 3
SELECT 
	Department,
	round(Avg(PerformanceRating)) AS Avg_PerformanceRating
FROM Employees
GROUP BY Department
HAVING avg(PerformanceRating) >=3
ORDER BY Avg_PerformanceRating DESC;

-- average MonthlyIncome > 6000
SELECT 
	Department,
    round(avg(MonthlyIncome)) AS Avg_MonthlyIncome
FROM Employees 
GROUP BY Department 
HAVING avg(MonthlyIncome) > 6000;

-- Find the departments with 2nd highest average salary.
SELECT 
	Department,
    avg(monthlyIncome) As Avg_Salary
FROM Employees
GROUP BY Department
ORDER BY Avg_salary DESC
LIMIT 1 OFFSET 1;
-- Find department with highest attrition rate.
SELECT 
	Department,
    round(sum(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attrition_Rate
FROM Employees
GROUP BY Department
ORDER BY Attrition_Rate DESC
LIMIT 1;
    
-- Which job role has:
-- Highest attrition
-- But lowest average salary
SELECT 
    JobRole,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 
    2) AS Attrition_Rate,
    AVG(MonthlyIncome) AS Avg_Salary
FROM Employees
GROUP BY JobRole
ORDER BY Attrition_Rate DESC,Avg_Salary ASC
LIMIT 1;

-- Find gender-wise average salary difference in each department.
SELECT 
	Department,
    Gender,
	round(Avg(MonthlyIncome)) AS Avg_salary
FROM Employees
GROUP BY Department,Gender
ORDER BY Department,Avg_salary;

-- Find departments where:
-- Overtime employees > Non-overtime employees   
SELECT 
    Department,
    SUM(CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END) AS Overtime_Count,
    SUM(CASE WHEN OverTime = 'No' THEN 1 ELSE 0 END) AS Non_Overtime_Count
FROM Employees
GROUP BY Department
HAVING 
    SUM(CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END) >
    SUM(CASE WHEN OverTime = 'No' THEN 1 ELSE 0 END);

-- ATTRITION ANALYSIS-- 
use hr_analytics;
-- Attrition Analysis 

-- Total number of employees who left the company.
SELECT 
count(*) AS Total_Empployees
FROM Employees
WHERE Attrition = "Yes";

-- What is the overall attrition rate (%)?
SELECT
	round(
	count(CASE WHEN Attrition = "yes" THEN 1 END)*100/count(*),2) AS Attrition_Rate
FROM Employees;

-- Attrition count by department.
SELECT 
	Department,
    count(*) AS Attrition_count
FROM Employees
WHERE Attrition = "yes"
GROUP BY Department
ORDER BY Attrition_count DESC;

-- Attrition count by gender.
SELECT 
	gender,
    Count(*) AS Attrition_count
FROM Employees
WHERE Attrition = "yes"
GROUP BY gender;
-- Attrition count by job role.
SELECT 
	Jobrole,
    count(*) AS Attrition_Count
FROM Employees
WHERE Attrition = "yes" 
GROUP BY Jobrole
ORDER BY Attrition_Count DESC;

-- Attrition count by job role.
SELECT 
	Jobrole,
    count(*) AS Attrition_Count
FROM Employees
WHERE Attrition = "yes" 
GROUP BY Jobrole
HAVING Jobrole = "Sales Executive"
ORDER BY Attrition_Count DESC;

-- How many employees left who worked overtime?
SELECT 
	count(*) AS Attrition_overtime_count
FROM Employees
WHERE Attrition = "yes" 
AND Overtime = "yes";
    
-- Attrition by marital status.
SELECT 
	Maritalstatus,
    Count(*) AS Attrition_count
FROM Employees
WHERE Attrition = "yes" 
GROUP BY Maritalstatus; 
    
-- Attrition by education level. -- Change column coulmn name educatio to educationLevel.
	ALTER TABLE employees
	CHANGE COLUMN Education EducationLevel INT; 
SELECT 
	EducationLevel,
    Count(*) AS Attrition_count
FROM Employees
WHERE Attrition = "yes"
GROUP BY EducationLevel
ORDER BY EducationLevel;

-- Attrition rate per department.
SELECT 
	Department,
    round(
		count(CASE WHEN Attrition = "yes" THEN 1 END)
		*100/count(*),
	2) AS Attrition_Rate
FROM Employees
GROUP BY Department
ORDER BY Attrition_rate DESC;

-- Compare attrition between:
-- Overtime employees
-- Non-overtime employees
SELECT * FROM EMPLOYEES;
SELECT 
	Overtime,
    count(*) AS Total_Employees,
    sum(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END) AS Attriton_count,
    ROUND
		(sum(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END)
		*100/count(*),2) AS Attrition_rate
    FROM Employees
    GROUP BY Overtime
    ORDER BY Attrition_rate;

-- Average salary of employees who left vs stayed.
SELECT 
    CASE 
		WHEN Attrition = "Yes" THEN "Left" 
		ELSE "Stayed"
	END As Employees_status,
    round(Avg(MonthlyIncome),2) AS Avg_Monthly_Salary
FROM Employees
GROUP BY Attrition
ORDER BY Avg_monthly_Salary DESC;

-- Average job satisfaction of employees who left vs stayed.
SELECT * FROM EMPLOYEES;
SELECT 
	CASE WHEN Attrition ="yes" THEN "Left" ELSE "Stayed" END AS Employee_status,
    Round(avg(JobSatisfaction),2) AS Avg_JObsatisfaction
FROM Employees
GROUP BY Attrition 
ORDER BY Avg_JobSatisfaction DESC;

-- Average years at company for employees who left.
SELECT 
	round(avg(YearsAtCompany),2) AS Avg_YearsAtCompany
FROM Employees
WHERE Attrition ="Yes";

-- Which age group has highest attrition?
SELECT 
	AgeGroup,
    Count(*) AS Attrition_Count
FROM Employees
WHERE Attrition ="yes"
GROUP BY AgeGroup
ORDER BY Attrition_Count DESC
LIMIT 1;

-- Attrition by job level.
SELECT 
	JobLevel,
    Count(*) As Total_Employees,
    SUM(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END) AS Attrition_Count,
    round(sum(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END)*100/Count(*),2) AS Attrition_Rate
FROM Employees
GROUP BY JobLevel
ORDER BY Attrition_Rate DESC;
    
-- Find departments where attrition rate > company average attrition rate.
SELECT 
	Department,
    round(avg(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attrition_Rate
FROM Employees
GROUP BY Department
HAVING 
	avg(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END)
	> 
    ( SELECT 
		avg(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END)
        FROM Employees);

-- Identify high-risk employees:
-- JobSatisfaction <= 2
-- EnvironmentSatisfaction <= 2
-- OverTime = 'Yes'

SELECT 
	count(*) AS High_risk_employees
FROM Employees
WHERE JobSatisfaction <=2
AND EnvironmentSatisfaction <=2
AND OverTime = "Yes";

SELECT 
	JobSatisfaction,
    EnvironmentSatisfaction,
    OverTime,
    Attrition
FROM Employees
WHERE JobSatisfaction <=2
AND EnvironmentSatisfaction <=2
AND OverTime = "Yes";

-- Which job role has:
-- High attrition
-- But low average salary.

SELECT 
	Jobrole,
    count(Attrition) AS Attrition_count,
    Avg(MonthlyIncome) Avg_Monthly_Salary
FROM Employees
WHERE Attrition = "yes" 
GROUP BY Jobrole
ORDER BY Attrition_count DESC, Avg_Monthly_Salary;

-- Compare attrition rate between:
-- High performers (PerformanceRating >= 3)
-- Low performers (PerformanceRating <= 2)

SELECT 
	Count(*) AS Total_Employees,
    CASE WHEN PerformanceRating >=3 THEN "High performers" ELSE "Low performers" END AS Performance_rating,
    	round(sum(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attrition_rate
FROM Employees
GROUP BY Performance_Rating;
    
-- Find correlation insight:
-- Do employees with more YearsSinceLastPromotion have higher attrition?
SELECT 
    Count(*) As Total_Employees,
    YearsSinceLastPromotion,
round(sum(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attrition_Rate
FROM Employees
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;	

-- Find top 3 departments contributing most to total attrition.
SELECT 
	Department AS Departments_contributing,
    sum(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END) AS total_attrition
FROM Employees
GROUP BY Departments_contributing
ORDER BY Total_Attrition DESC;
    
-- Create a query to calculate:
-- Total Employees
-- Total Attrition
-- Attrition Rate
-- In one single result table.
SELECT 
	count(EmpID) AS Total_Employees,
    sum(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END) AS Total_Attrition,
    Round(sum(CASE WHEN Attrition = "yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attriton_Rate
FROM Employees;

-- Find departments where:
-- Attrition rate is high
-- And average salary is below company average
SELECT 
	Department,
    Round(Sum(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attrition_Rate,
    Round(Avg(MonthlyIncome),2) AS Avg_Dept_Salary,
    Avg(MonthlyRate) AS Company_Average
FROM Employees
GROUP BY Department
HAVING Avg_Dept_Salary < Company_Average;

-- Rank job roles based on attrition rate (highest to lowest).
SELECT 
	Jobrole,
    Round(Sum(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END)*100/count(*),2) AS Attrition_Rate,
	RANK() OVER(order by Sum(CASE WHEN Attrition ="yes" THEN 1 ELSE 0 END)*100/count(*) DESC) AS Attrition_Rank
FROM Employees
GROUP BY JobRole
ORDER BY Attrition_Rate DESC;


-- BUSINESS QUERIES--
USE hr_analytics;
-- BUSIENSS QUERIES--

-- Find the top 3 highest-paid employees in each department.
SELECT * FROM Employees;
SELECT
	EmpID,
	Department,
    RN,
	MonthlyIncome
FROM 
	(SELECT 
	EmpID,
	Department,
	MonthlyIncome,
    ROW_NUMBER() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) AS RN
FROM Employees
) AS RANKED
WHERE RN <=3
ORDER BY Department,MonthlyIncome DESC;

-- If two employees have the same salary, include both (no skipping rank).
SELECT 
	Department,
    MonthlyIncome,
    Rnk
FROM 
	(SELECT 
	Department,
    MonthlyIncome,
    DENSE_RANK() OVER(PARTITION BY Department ORDER BY MonthlyIncome DESC) AS Rnk
    FROM Employees
    ) x
WHERE Rnk<=3
ORDER BY Department,MonthlyIncome DESC;

-- Find top 3 highest-paid employees who are still working (Attrition = 'No').
SELECT
	EmpID,
    MonthlyIncome,
    Attrition
FROM Employees
WHERE Attrition = "No" 
ORDER BY MonthlyIncome DESC
LIMIT 3;

-- EMPLOYEES WHO DESERVE PROMOTION-- 
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    JobLevel,
    PerformanceRating,
    YearsAtCompany,
    YearsSinceLastPromotion
FROM Employees
WHERE 
    PerformanceRating = 4
    AND JobLevel < 5
    AND YearsAtCompany >= 5
    AND YearsSinceLastPromotion >= 3
    AND Attrition = 'No'
ORDER BY Department, YearsAtCompany DESC;

-- Find employees who:
-- PerformanceRating ≥ 4
-- YearsSinceLastPromotion ≥ 3
-- JobInvolvement ≥ 3
SELECT 
	 EmployeeNumber,
	 Department,
	 PerformanceRating,
     YearsSinceLastPromotion,
     JobInvolvement
FROM Employees
WHERE 
    PerformanceRating >=4
    AND YearsSinceLastPromotion >= 3
    AND JobInvolvement >=3
ORDER BY Department;
    
-- Find employees who:
-- Have been in company more than 5 years
-- Never promoted
-- PerformanceRating ≥ 3
SELECT 
    EmployeeNumber,
    Department,
    YearsAtCompany,
    YearsSinceLastPromotion,
    PerformanceRating
FROM Employees
WHERE 
    YearsAtCompany > 5
    AND YearsSinceLastPromotion = YearsAtCompany
    AND PerformanceRating >= 3
ORDER BY Department, YearsAtCompany DESC;

-- Rank employees within each department based on:
-- PerformanceRating (high to low)
-- YearsAtCompany (high to low)
SELECT 
    EmployeeNumber,
    Department,
    PerformanceRating,
    YearsAtCompany,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY PerformanceRating DESC, YearsAtCompany DESC
    ) AS Dept_Rank
FROM Employees
ORDER BY Department, Dept_Rank;

-- Find job roles with:
-- High attrition rate
-- Low average salary
SELECT
	jobRole,
	count(*) AS Total_employees,
    Avg(MonthlyIncome) AS Avg_Salary,
    Round(Sum(CASE WHEN Attrition = "Yes" THEN 1 ELSE 0 END)*100/Count(*),2) AS Attrition_Rate
FROM Employees
GROUP BY JobRole;

-- Find employees who:
-- YearsSinceLastPromotion ≥ 4
-- JobSatisfaction ≤ 2
SELECT 
	EmployeeNumber,
    Department,
    JobRole,
	YearsSinceLastPromotion,
    JobSatisfaction
FROM Employees
WHERE YearsSinceLastPromotion >=4
AND   JobSatisfaction <=2
ORDER BY YearsSinceLastPromotion DESC;

-- Which department is: High salary, High attrition
SELECT 
    Department,
    AVG(MonthlyIncome) AS Avg_Salary,
    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100,
    2) AS Attrition_Rate
FROM Employees
GROUP BY Department
HAVING 
    AVG(MonthlyIncome) > (SELECT AVG(MonthlyIncome) FROM Employees)
    AND
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) >
        (SELECT AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) FROM Employees);
        
 -- Find departments with above-average salary.      
 
WITH Dept_Salary AS (
    SELECT 
        Department,
        AVG(MonthlyIncome) AS Avg_Salary
    FROM Employees
    GROUP BY Department
)
SELECT *
FROM Dept_Salary
WHERE Avg_Salary > (SELECT AVG(MonthlyIncome) FROM Employees);

