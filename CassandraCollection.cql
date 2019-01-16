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


