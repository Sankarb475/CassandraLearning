/*
Static Column :: In a table that uses clustering columns, non-clustering columns can be declared static in the table 
definition. Static columns are only static within a given partition.
You can use the DISTINCT keyword to select static columns although DISTINCT only works on partition keys.
A table that does not define any clustering columns cannot have a static column. The table having no clustering columns has a 
one-row partition in which every column is inherently static.
A table defined with the COMPACT STORAGE directive cannot have a static column.
A column designated to be the partition key cannot be static.
*/

CREATE TABLE testStatic (
Name text,
random text STATIC,
value int,
PRIMARY KEY (Name,value)
);

INSERT INTO teststatic (name, random, value) VALUES ('PK1','Static value',0)                          
                           
cqlsh:test> select * FROM teststatic ;

 name | value | random
------+-------+--------------
  PK1 |     0 | Static value
  
 
INSERT INTO teststatic (name, random, value) VALUES ('PK1','Static value should not change',1);
 
cqlsh:test> select * FROM teststatic ;

 name | value | random
------+-------+--------------------------------
  PK1 |     0 | Static value should not change
  PK1 |     1 | Static value should not change
  
 --the first row value has automatically changed, because as the partitioning key was same for both the rows, static column 
 --"random" had to be same as well.

INSERT INTO teststatic (name, random, value) VALUES ('PK2','Static value should not change PK2',1);

cqlsh:test> select * from teststatic ;

 name | value | random
------+-------+------------------------------------
  PK2 |     1 | Static value should not change PK2
  PK1 |     0 |     Static value should not change
  PK1 |     1 |     Static value should not change


cqlsh:test> INSERT INTO teststatic (name, random, value) VALUES ('PK2','this is Static value should not change PK2',2);

--again the last last inserted row's random value with PK as "PK2" will be overwritten

cqlsh:test> select * from teststatic ;

 name | value | random
------+-------+--------------------------------------------
  PK2 |     1 | this is Static value should not change PK2
  PK2 |     2 | this is Static value should not change PK2
  PK1 |     0 |             Static value should not change
  PK1 |     1 |             Static value should not change
  
  
