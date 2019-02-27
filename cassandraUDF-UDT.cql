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
