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
