--Finding the details of the columns a columnfamily.
--columnFamily metadata gets stored in the keyspace "system" and columnFamily "schema_columns"

cqlsh:> use system;

cqlsh:system> desc schema_columns

CREATE TABLE system.schema_columns (
    keyspace_name text,
    columnfamily_name text,
    column_name text,
    component_index int,
    index_name text,
    index_options text,
    index_type text,
    type text,
    validator text,
    PRIMARY KEY (keyspace_name, columnfamily_name, column_name)
) WITH CLUSTERING ORDER BY (columnfamily_name ASC, column_name ASC)

--query for finding out the column details of a column Family
select * from system.schema_columns WHERE keyspace_name='keyspace_name' AND columnfamily_name='table_name' allow filtering;

cqlsh:system> select * from system.schema_columns WHERE keyspace_name='system' AND columnfamily_name='schema_columns' allow filtering;

 keyspace_name | columnfamily_name | column_name       | component_index | index_name | index_options | index_type | type           | validator
---------------+-------------------+-------------------+-----------------+------------+---------------+------------+----------------+-------------------------------------------
        system |    schema_columns |       column_name |               1 |       null |          null |       null | clustering_key |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns | columnfamily_name |               0 |       null |          null |       null | clustering_key |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns |   component_index |               2 |       null |          null |       null |        regular | org.apache.cassandra.db.marshal.Int32Type
        system |    schema_columns |        index_name |               2 |       null |          null |       null |        regular |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns |     index_options |               2 |       null |          null |       null |        regular |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns |        index_type |               2 |       null |          null |       null |        regular |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns |     keyspace_name |            null |       null |          null |       null |  partition_key |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns |              type |               2 |       null |          null |       null |        regular |  org.apache.cassandra.db.marshal.UTF8Type
        system |    schema_columns |         validator |               2 |       null |          null |       null |        regular |  org.apache.cassandra.db.marshal.UTF8Type

(9 rows)


--counting number of rows
SELECT COUNT(*) FROM adulttable2;

./cqlsh -e "copy keyspaceName.columnName (age) to '/dev/null'" | sed -n 5p | sed 's/ .*//'


--Cassandra GROUP BY
/*
Group by is currently only supported on the columns of the PRIMARY KEY and
Group by currently only support groups of columns following their declared order in the PRIMARY KEY

that is if we have a PRIMARY KEY ((a,b),c,d)

group by valid combinations :
a,b
a,b,c
a,b,c,d

and the rest combinations are invalid
*/

cqlsh:datatable> CREATE TABLE groupBy(
             ... Name text,
             ... ID int,
             ... age int,
             ... country text,
             ... gender text,
             ... primary key ((ID,country),gender,age));
             
INSERT INTO groupby (id, country ,gender,age,name) VALUES ( 1,'US','Male',23,'Sankar');
INSERT INTO groupby (id, country ,gender,age,name) VALUES ( 2,'India','Male',28,'Shibu');
INSERT INTO groupby (id, country ,gender,age,name) VALUES ( 3,'India','Female',28,'Sudebi');
INSERT INTO groupby (id, country ,gender,age,name) VALUES ( 4,'India','Male',24,'Samarth');
INSERT INTO groupby (id, country ,gender,age,name) VALUES ( 5,'US','Male',29,'Sam');

cqlsh:datatable> INSERT INTO groupby (id, country ,gender,age,name) VALUES ( 5,'US','Male',29,'Sam');
cqlsh:datatable> select * from groupby ;

 id | country | gender | age | name
----+---------+--------+-----+---------
  3 |   India | Female |  28 |  Sudebi
  2 |   India |   Male |  28 |   Shibu
  4 |   India |   Male |  24 | Samarth
  5 |      US |   Male |  29 |     Sam
  1 |      US |   Male |  23 |  Sankar

--all the primary key has to be present in the group by columns
cqlsh:datatable> select country, avg(age) from groupby GROUP BY id;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Group by is not supported on only a part of the partition key"


--only clustering column wouldnt work 
cqlsh:datatable> select country, avg(age) from groupby GROUP BY age;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Group by currently only support groups of columns following their declared order in the PRIMARY KEY"

--primary key "country" is missing
cqlsh:datatable> select country, avg(age) from groupby GROUP BY id,gender;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Group by currently only support groups of columns following their declared order in the PRIMARY KEY"

--clustering column has to be present in their declared order that is "gender" then after "age"
cqlsh:datatable> select id, avg(age) from groupby GROUP BY id,country,age;
InvalidRequest: Error from server: code=2200 [Invalid query] message="Group by currently only support groups of columns following their declared order in the PRIMARY KEY"


--Cassandra Order by
/*
Order by is currently only supported on the clustered columns of the PRIMARY KEY and when the partition key is restricted by 
an Equality or an IN operator in where clause.

That is if you have your primary key defined like this :

PRIMARY KEY ((a,b),c,d)
Then you will be able to use the ORDER BY when & only when your query has :

a where clause with all the primary key restricted either by an equality operator (=) or an IN operator such as :
*/

SELECT * FROM groupby WHERE id = 1 AND country = 'India' ORDER BY gender,age;

SELECT * FROM groupby WHERE id = 1 AND country = 'India' ORDER BY gender;

--These two query are the only valid ones.
--Also this query would not work :

SELECT * FROM groupby WHERE id = 1 AND country = 'India' ORDER BY age,gender;

--because order by currently only support the ordering of columns following their declared order in the PRIMARY KEY that is in 
--primary key definition c has been declared before d and the query violates the ordering by placing d first.


--Cassandra "DISTINCT"



