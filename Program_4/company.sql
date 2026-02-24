-- 1. Department Table
CREATE TABLE DEPARTMENT (
    Dnumber VARCHAR(5) PRIMARY KEY,
    Dname VARCHAR(50) UNIQUE,
    Mgr_ssn VARCHAR(5),
    Mgr_start_date DATE
);

-- 2. Employee Table
CREATE TABLE EMPLOYEE (
    Ssn VARCHAR(5) PRIMARY KEY,
    Fname VARCHAR(15) NOT NULL,
    Lname VARCHAR(15) NOT NULL,
    Address VARCHAR(50),
    Sex CHAR(1),
    Salary DECIMAL(10, 2),
    Super_ssn VARCHAR(5),
    Dno VARCHAR(5),
    Bdate DATE,
    Phone VARCHAR(15),
    FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber)
);

ALTER TABLE EMPLOYEE
ADD FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);

ALTER TABLE DEPARTMENT
ADD FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);

-- 3. Department Locations
CREATE TABLE DEPT_LOCATIONS (
    Dnumber VARCHAR(5),
    Dlocation VARCHAR(20),
    PRIMARY KEY (Dnumber, Dlocation),
    FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber)
);

-- 4. Project Table
CREATE TABLE PROJECT (
    Pnumber VARCHAR(5) PRIMARY KEY,
    Pname VARCHAR(25) UNIQUE,
    Plocation VARCHAR(20),
    Dnum VARCHAR(5),
    Worth DECIMAL(12,2),
    End_date DATE,
    FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber)
);

-- 5. Works_On Table
CREATE TABLE WORKS_ON (
    Essn VARCHAR(5),
    Pno VARCHAR(5),
    Hours DECIMAL(4,1),
    PRIMARY KEY (Essn, Pno),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
    FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber)
);

-- 6. Dependent Table
CREATE TABLE DEPENDENT (
    Essn VARCHAR(5),
    Dependent_name VARCHAR(20),
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(15),
    PRIMARY KEY (Essn, Dependent_name),
    FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn)
);

-- Insert Departments
INSERT INTO DEPARTMENT VALUES ('D01', 'Headquarters', NULL, '2018-06-19');
INSERT INTO DEPARTMENT VALUES ('D02', 'Administration', NULL, '2017-01-01');
INSERT INTO DEPARTMENT VALUES ('D03', 'R&D', NULL, '2015-05-22');
INSERT INTO DEPARTMENT VALUES ('D04', 'Finance', NULL, '2019-03-01');

-- Insert Employees (E01 Format)
INSERT INTO EMPLOYEE VALUES
('E01','Rajesh','Sharma','12 MG Road, Mumbai','M',75000,NULL,'D01','1965-04-12','9876543210'),
('E02','Amit','Verma','45 Nehru Street, Delhi','M',60000,'E01','D03','1972-09-18','9823456789'),
('E03','Suresh','Patel','78 Brigade Road, Bengaluru','M',45000,'E02','D03','1985-01-15','9812345678'),
('E04','Priya','Iyer','23 Anna Salai, Chennai','F',48000,'E02','D03','1988-07-22','9898765432'),
('E05','Kavita','Reddy','56 Banjara Hills, Hyderabad','F',42000,'E02','D03','1990-03-30','9845012345'),
('E06','Arjun','Singh','101 Park Street, Kolkata','M',52000,'E02','D03','1983-11-05','9831123456'),
('E07','Neha','Agarwal','89 Civil Lines, Jaipur','F',40000,'E06','D04','1992-06-10','9870011223'),
('E08','Rohit','Mehta','67 FC Road, Pune','M',38000,'E06','D04','1991-02-14','9819988776'),
('E09','Vikram','Nair','34 MG Road, Kochi','M',41000,'E02','D03','1989-08-20','9811122334'),
('E10','Snehal','Joshi','21 Tilak Road, Nagpur','F',39000,'E02','D03','1993-04-15','9822233445');

-- Update Managers
UPDATE DEPARTMENT SET Mgr_ssn = 'E01' WHERE Dnumber = 'D01';
UPDATE DEPARTMENT SET Mgr_ssn = 'E06' WHERE Dnumber = 'D02';
UPDATE DEPARTMENT SET Mgr_ssn = 'E02' WHERE Dnumber = 'D03';
UPDATE DEPARTMENT SET Mgr_ssn = 'E07' WHERE Dnumber = 'D04';

-- Insert Projects
INSERT INTO PROJECT VALUES
('P01','ProductX','Mumbai','D03',2000000.00,'2023-12-31'),
('P02','ProductY','Delhi','D03',500000.00,'2024-05-15'),
('P03','ProductZ','Bengaluru','D03',1200000.00,NULL),
('P04','Computerization','Chennai','D02',800000.00,'2022-01-01'),
('P05','NewBenefits','Hyderabad','D04',100000.00,NULL),
('P06','Automation','Kolkata','D03',500000.00,'2023-01-01');

-- Insert Works_On
INSERT INTO WORKS_ON VALUES
('E03','P01',32.5),
('E03','P02',7.5),
('E03','P03',10.0),
('E04','P01',20.0),
('E04','P02',20.0),
('E02','P02',10.0),
('E02','P03',10.0),
('E02','P04',10.0),
('E07','P06',30.0),
('E08','P04',35.0),
('E09','P01',15.0),
('E10','P02',12.0),
('E08','P06',5.0);

-- Insert Dependents
INSERT INTO DEPENDENT VALUES
('E03','Ananya','F','2008-12-30','Daughter'),
('E03','Aryan','M','2010-10-25','Son'),
('E02','Sneha','F','1998-05-03','Spouse'),
('E06','Kabir','M','1990-02-28','Spouse');

-- Insert Department Locations
INSERT INTO DEPT_LOCATIONS VALUES
('D01','Mumbai'),
('D02','Chennai'),
('D03','Mumbai'),
('D03','Delhi'),
('D03','Bengaluru'),
('D04','Hyderabad'),
('D04','Jaipur');




/* ============================================================
   QUERY 1
List the f_Name, l_Name, dept_Name of the employee who draws a salary greater than the average salary of employees working for Finance department.

Expected Output:
First Name Second Name Dept_Name salary
Value-1 Value-1 Value-1 Value-1
Value-2 Value-2 Value-2 Value-2
============================================================ */
SELECT
    e.Fname AS "First Name",
    e.Lname AS "Second Name",
    d.Dname AS Dept_Name,
    e.Salary AS salary
FROM
    employee e,
    department d
WHERE
    e.Dno = d.Dnumber
    AND e.Salary > (
        SELECT AVG(e2.Salary)
        FROM
            employee e2,
            department d2
        WHERE
            e2.Dno = d2.Dnumber
            AND d2.Dname = 'Finance'
    );


/* ============================================================
   QUERY 2
List the name and department of the employee who is currently working on more than two projects controlled by R&D department.

Expected Output:
First Name Second Name Dept_Name Number of Projects
Value-1 Value-1 Value-1 Value-1
Value-2 Value-2 Value-2 Value-2
============================================================ */
SELECT
    e.Fname AS "First Name",
    e.Lname AS "Second Name",
    d.Dname AS Dept_Name,
    counts.cnt AS "Number of Projects"
FROM
    employee e,
    department d,
    (
        SELECT
            w.Essn,
            COUNT(w.Pno) AS cnt
        FROM
            works_on w,
            project p,
            department d2
        WHERE
            w.Pno = p.Pnumber
            AND p.Dnum = d2.Dnumber
            AND d2.Dname = 'R&D'
        GROUP BY
            w.Essn
    ) AS counts
WHERE
    e.Dno = d.Dnumber
    AND e.Ssn = counts.Essn
    AND counts.cnt > 2;


/* ============================================================
   QUERY 3
List all the ongoing projects controlled by all the departments.

Expected Output:
Project_id Project_title Dept_Name Date of completion
Value-1 Value-1 Value-1 Value-1
Value-2 Value-2 Value-2 Value-2
============================================================ */
SELECT
    p.Pnumber AS Project_id,
    p.Pname AS Project_title,
    d.Dname AS Dept_Name,
    p.End_date AS "Date of completion"
FROM
    project p,
    department d
WHERE
    p.Dnum = d.Dnumber
    AND (
        p.End_date IS NULL
        OR p.End_date >= CURRENT_DATE
    );


/* ============================================================
   QUERY 4
Give the details of the supervisor who is supervising more than 3 employees who have completed at least one project.

Expected Output:
Supervisor_id supervisor_name
Value-1 Value-1
Value-2 Value-2
============================================================ */
SELECT
    e.Ssn AS Supervisor_id,
    e.Fname AS supervisor_name
FROM
    employee e,
    (
        SELECT
            e2.Super_ssn,
            COUNT(DISTINCT e2.Ssn) AS cnt
        FROM
            employee e2,
            project p,
            works_on w
        WHERE
            e2.Ssn = w.Essn
            AND p.Pnumber = w.Pno
            AND p.End_date < CURRENT_DATE
            AND e2.Super_ssn IS NOT NULL
        GROUP BY
            e2.Super_ssn
    ) AS counts
WHERE
    counts.Super_ssn = e.Ssn
    AND counts.cnt > 3;


/* ============================================================
   QUERY 5
List the name of the dependents of employee who has completed total projects worth 10 Lakhs (10,00,000) or more.

Expected Output:
Employee_id Employee_name Project_Amount Dependent_Name
Value-1 Value-1 Value-1 Value-1
Value-2 Value-2 Value-2 Value-2
============================================================ */
SELECT
    e.Ssn AS Employee_id,
    e.Fname AS Employee_name,
    SUM(p.Worth) AS Project_Amount,
    d.Dependent_name AS Dependent_Name
FROM
    employee e,
    dependent d,
    works_on w,
    project p
WHERE
    e.Ssn = d.Essn
    AND e.Ssn = w.Essn
    AND w.Pno = p.Pnumber
    AND p.End_date < CURRENT_DATE
GROUP BY
    e.Ssn,
    e.Fname,
    d.Dependent_name
HAVING SUM(p.Worth) >= 1000000;


/* ============================================================
   QUERY 6
List the department and employee details whose project is in more than one city.

Expected Output:
Employee_id Department_id Project_id City
Value-1 Value-1 Value-1 Value-1
Value-2 Value-2 Value-2 Value-2
============================================================ */
SELECT
    e.Ssn AS Employee_id,
    d.Dnumber AS Department_id,
    p.Pnumber AS Project_id,
    p.Plocation AS City
FROM
    employee e,
    project p,
    department d,
    works_on w,
    (
        SELECT Dnum
        FROM project
        GROUP BY Dnum
        HAVING COUNT(DISTINCT Plocation) > 1
    ) AS multi_city_dept
WHERE
    e.Dno = d.Dnumber
    AND p.Dnum = d.Dnumber
    AND d.Dnumber = multi_city_dept.Dnum
    AND w.Essn = e.Ssn
    AND w.Pno = p.Pnumber;