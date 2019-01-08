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




