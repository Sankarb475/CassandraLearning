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


