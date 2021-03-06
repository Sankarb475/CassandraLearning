/*
Cassandra has many types of key:
primary key,
partition key, 
composite key 
clustering key
*/

-- Partition Key: Is the part of a record (one or more columns) that is used to create its hash that is then used to 
select the node(s) that will store it. so partition key is the key which creates the hash value based on which the row gets
stored.

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

/*
A primary key uniquely identifies a row.
A composite key is a key formed from multiple columns.
A partition key is the primary lookup to find a set of rows, i.e. a partition.
A clustering key is the part of the primary key that isn't the partition key (and defines the ordering within a partition).
Examples:

PRIMARY KEY (a): The partition key is a.
PRIMARY KEY (a, b): The partition key is a, the clustering key is b.
PRIMARY KEY ((a, b)): The composite partition key is (a, b).
PRIMARY KEY (a, b, c): The partition key is a, the composite clustering key is (b, c).
PRIMARY KEY ((a, b), c): The composite partition key is (a, b), the clustering key is c.
PRIMARY KEY ((a, b), c, d): The composite partition key is (a, b), the composite clustering key is (c, d).
*/

--we can use ordering on the clustering keys while defining the table::

CREATE TABLE timeseries (
  event_type text,
  insertion_time timestamp,
  event blob,
  PRIMARY KEY (event_type, insertion_time)
)
WITH CLUSTERING ORDER BY (insertion_time DESC);


