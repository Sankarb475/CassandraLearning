/*
you might face this issue in your local cassandra which says connection error or that the cassandar server is already running 
in such cases the best thing we could do is kill all the cassandra related instances from local
*/
--finding out the running cassandra related instances
ps -ax | grep cassandra

--finding out the cassandra instance pid through the usual port cassandra uses : 9160
lsof -i :9160

--once you have the PID just run the following command
kill -9 <PID>

--also one can use this as well to kill the cassandra instances
nodetool drain

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

