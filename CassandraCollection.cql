/*
Cassandra Collections : Using these Collection types, you can store multiple values in a single column
List
Set
Map
*/

--List
/*
List is used in the cases where
--the order of the elements is to be maintained, and
--more than one value of same type is to be stored
--to store data that has a possible many-to-many relationship with another column
*/

CREATE TABLE data(name text PRIMARY KEY, email list<text>);

INSERT INTO data(name, email) VALUES ('Puja',['pujajha5912@gmail.com','cba@yahoo.com']);
                                              
INSERT INTO data(name, email) VALUES ('Sankar',['sankarb475@gmail.com','bsankar207@gmail.com']);

cqlsh:datatable> SELECT * FROM data;

 name   | email
--------+--------------------------------------------------
 Sankar | ['sankarb475@gmail.com', 'bsankar207@gmail.com']
   Puja |       ['pujajha5912@gmail.com', 'cba@yahoo.com']

                                                
cqlsh:datatable> UPDATE data SET email = email +['xyz@apple.com'] where name = 'Sankar';
                                                
cqlsh:datatable> SELECT * FROM data;

 name   | email
--------+-------------------------------------------------------------------
 Sankar | ['sankarb475@gmail.com', 'bsankar207@gmail.com', 'xyz@apple.com']
   Puja |                        ['pujajha5912@gmail.com', 'cba@yahoo.com']

                                               
cqlsh:datatable> SELECT * FROM data where email CONTAINS 'xyz@apple.com' ALLOW FILTERING;

 name   | email
--------+-------------------------------------------------------------------
 Sankar | ['sankarb475@gmail.com', 'bsankar207@gmail.com', 'xyz@apple.com']

                                                
--Set in Cassandra
A set consists of a group of elements with unique values. Duplicate values will not be stored distinctly. The values of a set 
are stored unordered, but will return the elements in sorted order when queried. Use the set data type to store data that has 
a many-to-one relationship with another column.          

cqlsh:test> CREATE TABLE cyclist_career_teams ( id int PRIMARY KEY, lastname text, teams set<text> );
                                                
cqlsh:test> Insert INTO cyclist_career_teams (id, lastname , teams ) VALUES ( 1, 'Biswas', {'Noah', 'Spark migration'});   
                                                                             
cqlsh:test> CONSISTENCY one;
Consistency level set to ONE.
                                                                             
cqlsh:test> SELECT * FROM cyclist_career_teams ;

 id | lastname | teams
----+----------+-----------------------------
  1 |   Biswas | {'Noah', 'Spark migration'}   
                                                                             
cqlsh:test> UPDATE test.cyclist_career_teams SET teams = teams + {'Knowledge graph'} WHERE id = 1;  
                                                                             
cqlsh:test> SELECT * FROM cyclist_career_teams ;

 id | lastname | teams
----+----------+------------------------------------------------
  1 |   Biswas | {'Knowledge graph', 'Noah', 'Spark migration'}
                                                                             
cqlsh:test> DELETE teams FROM test.cyclist_career_teams WHERE id = 1;
                                                                             
cqlsh:test> SELECT * FROM cyclist_career_teams ;

 id | lastname | teams
----+----------+-------
  1 |   Biswas |  null

                                                                             
-- Map in cassandra 
A map relates one item to another with a key-value pair. For each key, only one value may exist, and duplicates cannot be 
stored. Both the key and the value are designated with a data type.              
                                                                             
cqlsh:test> CREATE TABLE test.cyclist_teams ( id bigint PRIMARY KEY, lastname text, firstname text, teams map<int,text> );

cqlsh:test> INSERT INTO cyclist_teams (id, lastname , firstname , teams ) VALUES ( 1, 'Biswas', 'Sankar', {1: 'Noah'});
                                                                                  
cqlsh:test> SELECT * FROM cyclist_teams ;

 id | firstname | lastname | teams
----+-----------+----------+-------------
  1 |    Sankar |   Biswas | {1: 'Noah'}


                                                                                  
-- Observe the following limitations of collections:
1) Never insert more than 2 billion items in a collection, as only that number can be queried.
                                                                             
2) The maximum number of keys for a map collection is 65,535.
                                                
3) The maximum size of an item in a list or a map collection is 2GB.
                                                
4) The maximum size of an item in a set collection is 65,535 bytes.
                                                
5) Keep collections small to prevent delays during querying.
Collections cannot be "sliced"; Cassandra reads a collection in its entirety, impacting performance. Thus, collections should 
be much smaller than the maximum limits listed. The collection is not paged internally. 

                                                
-- CQL Data Types
inet :: IP address string in IPv4 or IPv6 format, used by the python-cql driver and CQL native protocols
                                               
uuid :: A universally unique identifier (UUID) is a 128-bit number
                                                
timeuuid :: The actual point of TimeUUID, as I understand it, is to give you a unique primary key that sorts by time.                                                
                                                                                  
timestamp :: Date and time with millisecond precision, encoded as 8 bytes since epoch. Can be represented as a string, 
             such as 2015-05-03 13:30:54.234.
                                               
-- Cassandra Counter column
A counter is a special column for storing a number that is changed in increments.
Counters are useful for many data models. Some examples:
      To keep track of the number of web page views received on a company website
      To keep track of the number of games played online or the number of players who have joined an online game      
                                                
Because counters are implemented differently from other columns, counter columns can only be created in dedicated tables. A 
counter column must have the datatype counter data type. This data type cannot be assigned to a column that serves as the 
primary key or partition key. To implement a counter column, create a table that only includes:
      The primary key (can be one or more columns)
      The counter column 
                                                
A counter column cannot be indexed or deleted. To load data into a counter column, or to increase or decrease the value of the 
counter, use the UPDATE command. Cassandra rejects USING TIMESTAMP or USING TTL when updating a counter column.
                                                
To create a table having one or more counter columns:
Use CREATE TABLE to define the counter and non-counter columns. Use all non-counter columns as part of the PRIMARY KEY 
definition.                                                
INSERT statement are not allowed on counter tables, use UPDATE instead.                                               
                                                
-- Cassandra Time-to-live (TTL)
Columns and tables support an optional expiration period called TTL (time-to-live); TTL is not supported on counter columns. 
Define the TTL value in seconds. Data expires once it exceeds the TTL period and is then marked with a tombstone. Expired data
continues to be available for read requests during the grace period, see gc_grace_seconds. Normal compaction and repair 
processes automatically remove the tombstone data.                                                
TTL precision is one second, which is calculated by the coordinator node. When using TTL, ensure that all nodes in the cluster 
have synchronized clocks.
                                                
you can use TTL on a Table level or row level.
On table level we have to configure the following property only :: default_time_to_live    
                                                
cqlsh:test> INSERT INTO cycling.calendar (race_id, race_name, race_start_date, race_end_date) VALUES (200, 'placeholder', 
'2015-05-27', '2015-05-27') USING TTL 86400;
                                                
                                                
                                                
                                                
                                                
