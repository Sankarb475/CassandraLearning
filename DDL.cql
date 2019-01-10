--creating keyspace "Dummy"

CREATE KEYSPACE Dummy
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 3};

--creating column family "AdultTable"
CREATE TABLE AdultTable(
Age int,
Employer text,
Salary int,
education text,
educationYear int,
maritalStatus text,
jobDesiognation text,
familyStatus text,
colour text,
gender text,
Points1 int,
Points2 int,
Points3 int,
country text,
salaryType text,
PRIMARY KEY (Age,Employer,Salary,education,educationYear)
);
