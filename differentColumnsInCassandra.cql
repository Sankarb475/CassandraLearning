/*
Cassandra has many types of column:
primary key,
partition key, 
composite key 
clustering key
*/

/*
The primary key is a general concept to indicate one or more columns used to retrieve data from a Table. They alltogether
represents each row of the column uniquely.

In cassandra if you are trying to insert duplicates using "INSERT INTO" command, it will overwrite the existing value
*/

CREATE TABLE dummy.duplicate_rows (
    age int PRIMARY KEY,
    name text
);

INSERT INTO duplicate_rows (age, name) VALUES (23,'Sankar');

INSERT INTO duplicate_rows (age, name) VALUES (23,'Samrat');

cqlsh:dummy> SELECT * FROM duplicate_rows;

 age | name
-----+--------
  23 | Samrat
  
  --so "Sankar" has been overwritten by "Samrat"


/*
But the primary key can also be COMPOSITE (aka COMPOUND), generated from more than one column.
*/

CREATE TABLE employee(
ID int,
Employer text,
Salary int,
country text,
PRIMARY KEY(ID,country)
);

INSERT INTO employee (id, country) VALUES (1,'India');

--This will have the country and salary column as "null". "ID" and "country" fields has to be entered being part of PK.

/*
In a situation of COMPOSITE primary key, the "first part" of the key is called PARTITION KEY 
(in this example key_part_one is the partition key) and the second part of the key is the CLUSTERING KEY 
(in this example key_part_two)
*/

--if you see the definition of the table, you will get an idea about the structure 

cqlsh:dummy> desc table employee 

CREATE TABLE dummy.employee (
    id int,
    country text,
    employer text,
    salary int,
    PRIMARY KEY (id, country)
) WITH CLUSTERING ORDER BY (country ASC);

INSERT INTO employee (id, country, employer , salary ) VALUES ( 2,'US','Kagel',100000);

--so in this case "id" and "country" together will be defining each row uniquely

INSERT INTO employee (id, country, employer , salary ) VALUES ( 2,'US','Infy',100000);

--this row will overwrite the last line of INSERT

/*
The Partition Key is responsible for data distribution across your nodes. On your partition key, partitioning algorithm will work.
The Clustering Key is responsible for data sorting within the partition.
Also range queries ( < , >) should be performed on clustering keys, it wouldnt work on Partition key.
*/

--also we can have both partition and clustering key made by more columns, here's how::

CREATE TABLE adultData(
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
PRIMARY KEY ((Age,Employer,Salary,education,educationYear),Points1,Points2,Points3,salaryType,gender,jobdesignation,maritalStatus,country,colour)
);

cqlsh:dummy> DESC TABLE adultdata;

CREATE TABLE dummy.adultdata (
    age int,
    employer text,
    salary int,
    education text,
    educationyear int,
    points1 int,
    points2 int,
    points3 int,
    salarytype text,
    gender text,
    jobdesignation text,
    maritalstatus text,
    country text,
    colour text,
    familystatus text,
    PRIMARY KEY ((age, employer, salary, education, educationyear), points1, points2, points3, salarytype, gender, jobdesignation, maritalstatus, country, colour)
) WITH CLUSTERING ORDER BY (points1 ASC, points2 ASC, points3 ASC, salarytype ASC, gender ASC, jobdesignation ASC, maritalstatus ASC, country ASC, colour ASC)

--you can see the clustering key has started with Points1
