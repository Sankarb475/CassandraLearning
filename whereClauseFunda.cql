/*
Using where clause in Cassandra is not as easy as it is in any other databases.
Query based on where clause is a "thing" to understand in cassandra otherwise you would many times end up getting error in 
where clause.
In Cassandra, you need to build your data model to match your query patterns. This sometimes means duplicating your 
data into additional tables, to attain the desired level of query flexibility.
*/

/*
"where" clause is only can be applied on the Partition key column that too only in limited search, like you are not allowed 
to use range (>, <) on partition key column, it can only be used in clustering columns.
*/

/*
the partition key is the minimum-specifier needed to perform a query using a where clause, i meant all the partition key 
column has to be present. we can query based on all key (both partition and clustering) as well.
*/


/*
If you have a composite partition key, like the following ::

PRIMARY KEY((col1, col2), col10, col4))
You can perform query using where only by passing at least both col1 and col2, these are the 2 columns that define the 
partition key. The "general" rule to make query is you have to pass at least all partition key columns, then you can add 
optionally each clustering key in the order they're set.

so the valid queries are (excluding secondary indexes)::
col1 and col2
col1 and col2 and col10
col1 and col2 and col10 and col 4
*/

cqlsh:test> CREATE TABLE testing2 (id int, age int, roll int, name text, primary key((id,roll),age));

cqlsh:test> INSERT INTO testing2 (id, roll , age , name ) VALUES ( 1,11,23,'Sankar');

cqlsh:test> INSERT INTO testing2 (id, roll , age , name ) VALUES ( 2,11,23,'Sankar');

cqlsh:test> SELECT * from testing2;

 id | roll | age | name
----+------+-----+--------
  2 |   11 |  23 | Sankar
  1 |   11 |  23 | Sankar

(2 rows)

-- error because roll has not been put in where clause which is a primary key

cqlsh:test> SELECT  * from testing2 where id = 1;
InvalidRequest: code=2200 [Invalid query] message="Partition key part roll must be restricted since preceding part is"

-- all the partition key columns are present in the where clause

cqlsh:test> SELECT  * from testing2 where id = 1 and roll = 11;

 id | roll | age | name
----+------+-----+--------
  1 |   11 |  23 | Sankar
 
 -- clustering column condition has been added as well.
 cqlsh:test> SELECT  * from testing2 where id = 1 and roll = 11 and age = 23;

 id | roll | age | name
----+------+-----+--------
  1 |   11 |  23 | Sankar
 
 
 -- ALLOW FILTERING allows you to search based on only clustering column as well
 cqlsh:test> SELECT  * from testing2 where age = 23 ALLOW FILTERING ;

 id | roll | age | name
----+------+-----+--------
  2 |   11 |  23 | Sankar
  1 |   11 |  23 | Sankar

(2 rows)

-- only equal and in operations are allowed in partition key column
cqlsh:test> SELECT  * from testing2 where id > 1 and roll = 11 and age = 23;
InvalidRequest: code=2200 [Invalid query] message="Only EQ and IN relation are supported on the partition key (unless you use 
the token() function)"
 
-- > and < are supported in clutering column 
cqlsh:test> SELECT  * from testing2 where id = 1 and roll = 11 and age > 21;

 id | roll | age | name
----+------+-----+--------
  1 |   11 |  23 | Sankar
 
 
 
 
 
 
 
 
 
 

