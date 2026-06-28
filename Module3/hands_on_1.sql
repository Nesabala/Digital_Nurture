-- TASK-01:Create the Database and Tables

-- DEPARTMENTS
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    hod_name VARCHAR(100),
    budget DECIMAL(12,2)
);


-- STUDENTS
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    date_of_birth DATE,
    department_id INT,
    enrollment_year INT,

    CONSTRAINT fk_student_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


-- COURSES
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE,
    credits INT,
    department_id INT,

    CONSTRAINT fk_course_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);


-- ENROLLMENTS
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    grade CHAR(2),

    CONSTRAINT fk_enrollment_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES courses(course_id)
);

-- PROFESSORS
CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    prof_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),

    CONSTRAINT fk_prof_department
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- Retrieve empty tables as no data has been inserted yet
SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM professors;

-- Insert sample data into the tables
INSERT INTO departments (dept_name, hod_name, budget) VALUES
('Computer Science', 'Dr. Ramesh Kumar', 850000.00),
('Electronics', 'Dr. Priya Nair', 620000.00),
('Mechanical', 'Dr. Suresh Iyer', 540000.00),
('Civil', 'Dr. Ananya Sharma', 430000.00);

INSERT INTO students
(first_name, last_name, email, date_of_birth, department_id, enrollment_year)
VALUES
('Arjun', 'Mehta', 'arjun.mehta@college.edu', '2003-04-12', 1, 2022),
('Priya', 'Suresh', 'priya.suresh@college.edu', '2003-07-25', 1, 2022),
('Rohan', 'Verma', 'rohan.verma@college.edu', '2002-11-08', 2, 2021),
('Sneha', 'Patel', 'sneha.patel@college.edu', '2004-01-30', 3, 2023),
('Vikram', 'Das', 'vikram.das@college.edu', '2003-09-14', 1, 2022),
('Kavya', 'Menon', 'kavya.menon@college.edu', '2002-05-17', 2, 2021),
('Aditya', 'Singh', 'aditya.singh@college.edu', '2004-03-22', 4, 2023),
('Deepika', 'Rao', 'deepika.rao@college.edu', '2003-08-09', 1, 2022);

INSERT INTO courses
(course_name, course_code, credits, department_id)
VALUES
('Data Structures & Algorithms', 'CS101', 4, 1),
('Database Management Systems', 'CS102', 3, 1),
('Object Oriented Programming', 'CS103', 4, 1),
('Circuit Theory', 'EC101', 3, 2),
('Thermodynamics', 'ME101', 3, 3);

INSERT INTO enrollments
(student_id, course_id, enrollment_date, grade)
VALUES
(1, 1, '2022-07-01', 'A'),
(1, 2, '2022-07-01', 'B'),
(2, 1, '2022-07-01', 'B'),
(2, 3, '2022-07-01', 'A'),
(3, 4, '2021-07-01', 'A'),
(4, 5, '2023-07-01', NULL),
(5, 1, '2022-07-01', 'C'),
(5, 2, '2022-07-01', 'A'),
(6, 4, '2021-07-01', 'B'),
(7, 5, '2023-07-01', NULL),
(8, 1, '2022-07-01', 'A'),
(8, 3, '2022-07-01', 'B');

INSERT INTO professors
(prof_name, email, department_id, salary)
VALUES
('Dr. Anand Krishnan', 'anand.k@college.edu', 1, 95000.00),
('Dr. Meena Pillai', 'meena.p@college.edu', 1, 88000.00),
('Dr. Sunil Rajan', 'sunil.r@college.edu', 2, 82000.00),
('Dr. Latha Gopal', 'latha.g@college.edu', 3, 79000.00),
('Dr. Kartik Bose', 'kartik.b@college.edu', 4, 76000.00);


-- Check if all tables have been populated with data
SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM students;
SELECT COUNT(*) FROM courses;
SELECT COUNT(*) FROM enrollments;
SELECT COUNT(*) FROM professors;

-- Retrieve all data from the tables to verify the inserted records
SELECT * FROM departments;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;
SELECT * FROM professors;


-- TASK 02:Normalization Analysis
-- 1NF (First Normal Form)
-- All tables contain atomic (single) values in every column.
-- There are no repeating groups or multiple values stored in one field.
-- For example, storing multiple phone numbers in one column like '9876543210,9123456789'
-- would violate 1NF. Instead, each phone number should be stored separately.

-- 2NF (Second Normal Form)
-- Every non-key attribute is fully dependent on the primary key.
-- In the enrollments table, the logical candidate key is (student_id, course_id).
-- The attribute grade depends on the complete student-course enrollment,
-- not on student_id or course_id individually. Hence the table satisfies 2NF.

-- 3NF (Third Normal Form)
-- There are no transitive dependencies in the schema.
-- Student details do not store department names directly.
-- Instead, students reference department_id, and department details are stored
-- only in the departments table.
-- Therefore, the schema satisfies Third Normal Form (3NF).

--TASK 03:Alter and Extend the Schema
--Add Phone Number to Students Table
ALTER TABLE students
ADD COLUMN phone_number VARCHAR(15);
--Verify the addition of the new column
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'students';

--Add max_seats to Courses Table
ALTER TABLE courses
ADD COLUMN max_seats INT DEFAULT 60;
--Verify the addition of the new column
SELECT column_name FROM information_schema.columns
WHERE table_name = 'courses';

--Add CHECK Constraints on grade
ALTER TABLE enrollments
ADD CONSTRAINT chk_grade
CHECK (
    grade IN ('A', 'B', 'C', 'D', 'F')
    OR grade IS NULL
);
--Verify  the CHECK constraint
INSERT INTO enrollments(student_id, course_id, enrollment_date, grade)
VALUES(1, 3, CURRENT_DATE, 'Z');

--Rename hod_name to head_of_dept
ALTER TABLE departments
RENAME COLUMN hod_name TO head_of_dept;
--Verify the renaming of the column
SELECT column_name FROM information_schema.columns
WHERE table_name = 'departments';

--Rollback the addition of the phone_number column in students table
ALTER TABLE students
DROP COLUMN phone_number;
--Verify the removal of the column
SELECT column_name FROM information_schema.columns
WHERE table_name = 'students';