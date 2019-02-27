/*
Cassandra doesnt have a trim() function, and so as left trim and right trim.
often when working with cassandra you will find the need of specific function which doesnt really exist, which is why we have
user defined function(UDF)
*/

--before getting into UDF or UDA, we need to set one property true in cassandra config file that is cassandra.yaml:
~cassandra/conf/cassandra.yaml

--go to the above path and set the following property from "false" to "true"

enable_user_defined_functions: true

--now lets try to create a trim() function in cassandra

CREATE OR REPLACE FUNCTION trim (input text) CALLED ON NULL INPUT RETURNS text 
LANGUAGE java AS 
'String ltrim = input.replaceAll("^\\s+","");
return ltrim;'
;

--this is an example of UDF, now lets use it, the below query will return employer column values trimming the space

SELECT trim(employer) AS Employer FROM adultdata limit 5;


-- User-defined type (UDT)
User-defined types (UDTs) can attach multiple data fields, each named and typed, to a single column. Once created, 
UDTs may be used to define a column in a table.

cqlsh:test> CREATE TYPE basic_info ( birthday timestamp, nationality text, weight text, height text );
cqlsh:test> CREATE TABLE cyclist_stats ( id uuid PRIMARY KEY, lastname text, basics FROZEN<basic_info>); 


cqlsh:test> CREATE TYPE flagtype (data map<text,text>,working text);

cqlsh:test> CREATE TABLE table1 (abc text, hello text, flag frozen<flagtype>, PRIMARY KEY (abc));
