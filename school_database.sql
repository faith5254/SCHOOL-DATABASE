-- students table
create table students (
  id SERIAL PRIMARY KEY,
  student_number VARCHAR(10),
  first_name VARCHAR(30),
  last_name VARCHAR(30),
  dob DATE
);
-- create new students
insert into students(student_number, first_name, last_name, dob) values 
('STUD001','James','Kimani', '12-12-1990'),
('STUD002','Jane','Doe', '01-07-1999'),
('STUD003','John','Doe', '03-05-1998'),
('STUD004','Alice','Wangui', '09-09-1997'),
('STUD005','Kevin','Wafula', '08-10-2001');

-- stored procedure to register a new student
CREATE OR REPLACE PROCEDURE registerStudent(
  student_number VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR,
  dob DATE
) AS $$
BEGIN
  INSERT INTO students (student_number, first_name, last_name, dob)
  VALUES (student_number, first_name, last_name, dob);
END;
$$ LANGUAGE plpgsql;
-- execute the procedure
call registerStudent('STUD001','MArtin','Luther', '12-12-1989')
select * from students

-- teachers table
create table teachers (
    id SERIAL PRIMARY KEY,
    teacher_id VARCHAR(10),
    first_name VARCHAR(30),
    last_name VARCHAR(30)
);
-- create new teachers
insert into teachers (teacher_id, first_name, last_name)
VALUES ('TR001', 'John', 'Doe'),
       ('TR002', 'Jane', 'Doe'),
       ('TR003', 'David', 'Jones'),
       ('TR004', 'Mary', 'Jane');
	   
-- stored procedure to register new teachers
CREATE OR REPLACE PROCEDURE registerTeacher(
  teacher_id VARCHAR,
  first_name VARCHAR,
  last_name VARCHAR
) AS $$
BEGIN
  INSERT INTO teachers (teacher_id, first_name, last_name)
  VALUES (teacher_id, first_name, last_name);
END;
$$ LANGUAGE plpgsql;
-- execute the procedure to add a new teacher
call registerTeacher('TR005','Melvin','K')
select * from teachers


-- units table
create table  units (
  	id SERIAL PRIMARY KEY,
  	unit_code VARCHAR(10),
  	unit_title VARCHAR(100),
	teacher INTEGER references teachers(id),
  	enrolments INTEGER DEFAULT 0
);
insert into units (unit_code, unit_title, teacher) values 
('BCS101', 'Introduction to Computer Science', 1),
('UCC101', 'Quantitative techniques', 2),
('UCC102', 'Statistics', 3),
('BCS111', 'Introduction to Programming', 4),
('BCS222', 'Software engineering', 2),
('BCS333', 'Ecommerce foundations', 3);

-- stored procedure to register new units
CREATE OR REPLACE PROCEDURE registerUnit(
  unit_code VARCHAR(10),
  unit_title VARCHAR(100)
) AS $$
BEGIN
  INSERT INTO units (unit_code, unit_title)
  VALUES (unit_code, unit_title);
END;
$$ LANGUAGE plpgsql;

-- call the procedure
call registerUnit('BMM101', 'Marketing')
select * from units

-- student units table
create table student_units (
  id SERIAL PRIMARY KEY,
  student_id INTEGER REFERENCES students(id),
  units JSONB
);
insert into student_units (student_id, units) values 
(1, '["BCS111", "BCS222", "BCS333"]'),
(2, '["MATH101","COMP101"]'),
(3, '["MATH101","COMP101","BCS111"]'),
(4, '["BCS333","COMP101"]'),
(5, '["BCS111","BCS222"]');
select * from student_units

-- View to retrieve student records with their selected units
CREATE OR REPLACE VIEW getStudents AS
  select 
	students.id,
	students.student_number,
	students.first_name,  
	students.last_name, 
	student_units.units from students
	right join student_units on students.id = student_units.student_id;
select * from getStudents

-- === Functions
-- Function to retrieve student records
CREATE OR REPLACE FUNCTION getStudents()
  RETURNS SETOF students AS
$$
BEGIN
  RETURN QUERY SELECT * FROM students;
END;
$$ LANGUAGE plpgsql;

select * from getStudents()


-- Function to retrieve records from the teachers table
CREATE OR REPLACE FUNCTION getTeachers()
  RETURNS SETOF teachers AS
$$
BEGIN
  RETURN QUERY SELECT * FROM teachers;
END;
$$ LANGUAGE plpgsql;
select * from getTeachers()


-- Function to retrieve records from the units table
CREATE OR REPLACE FUNCTION getUnits()
  RETURNS SETOF units AS
$$
BEGIN
  RETURN QUERY SELECT * FROM units;
END;
$$ LANGUAGE plpgsql;
select * from getUnits()
