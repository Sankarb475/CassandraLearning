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


select * from system.schema_columns WHERE keyspace_name='keyspace_name' AND columnfamily_name='table_name' allow filtering;
