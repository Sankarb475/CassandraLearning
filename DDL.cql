/*
In Cassandra, you need to build your data model to match your query patterns. This sometimes means duplicating your 
data into additional tables, to attain the desired level of query flexibility.
*/

--creating keyspace "Dummy"

CREATE KEYSPACE Dummy
WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 3};

--dropping keyspace 
drop KEYSPACE dummy

--creating column family "AdultTable"
CREATE TABLE AdultTable(
Age int,
Employeer text,
Salary int,
education text,
educationYear int,
maritalStatus text,
jobdesignation text,
familyStatus text,
colour text,
gender text,
Points1 int,
Points2 int,
Points3 int,
country text,
salaryType text,
PRIMARY KEY (Age,Employeer,Salary,education,educationYear)
);


--dropping a cassandra table
drop TABLE adulttable;

/*
importing the following dataset using "COPY" command :: 
(UCI Machine Learning Adult dataset) => https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data
I have added header (first row) in the above dataset :: 
Age,employeer,salary,education,educationyear,maritalstatus,jobdesignation,familystatus,colour,gender,points1,points2,points3,country,salarytype
you have to give your file path, my path is :: '/Users/sankar.biswas/Desktop/hello.txt'
*/

COPY AdultTable(Age,
employeer,
salary,
education,
educationyear,
maritalStatus,
jobdesignation,
familystatus,
colour,
gender,
Points1,
Points2,
Points3,
country,
salaryType) FROM '/Users/sankar.biswas/Desktop/hello.txt'
WITH DELIMITER = ',' AND HEADER = TRUE;

--if you do not want to add the header use following commmand

COPY AdultTable(Age,
employeer,
salary,
education,
educationyear,
maritalStatus,
jobdesignation,
familystatus,
colour,
gender,
Points1,
Points2,
Points3,
country,
salaryType) FROM '/Users/sankar.biswas/Desktop/hello.txt'
WITH DELIMITER = ',' AND HEADER = FALSE;

--adding WITH COMPACT STORAGE while defining a table will not let you create a table having more than one column not part
--of primary key of that table.

--so the following will not work, will throw an error instead::
CREATE TABLE AdultTable2(
Age int,
Employer text,
Salary int,
education text,
educationYear int,
maritalStatus text,
jobdesignation text,
familyStatus text,
colour text,
gender text,
Points1 int,
Points2 int,
Points3 int,
country text,
salaryType text,
PRIMARY KEY (Age,Employer,Salary,education,educationYear)
) WITH COMPACT STORAGE;
    
 --but this will work 
CREATE TABLE AdultTable2(
Age int,
Employer text,
Salary int,
education text,
educationYear int,
maritalStatus text,
jobdesignation text,
familyStatus text,
colour text,
gender text,
Points1 int,
Points2 int,
Points3 int,
country text,
salaryType text,
PRIMARY KEY (Age,Employer,Salary,education,educationYear,Points1,Points2,Points3,salaryType,gender,jobdesignation,maritalStatus,country,colour)
) WITH COMPACT STORAGE;

--A compact table that uses a compound primary key must define at least one clustering column. 
--Columns cannot be added nor removed after creation of a compact table.



