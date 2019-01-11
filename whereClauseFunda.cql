/*
Using where clause in Cassandra is not as easy as it is in any other databases.
Query based on where clause is a "thing" to understand in cassandra otherwise you would many times end up getting error in where
clause.
In Cassandra, you need to build your data model to match your query patterns. This sometimes means duplicating your 
data into additional tables, to attain the desired level of query flexibility.
*/

/*
"where" clause is only can be applied on the Partition key column that too only in limited search, like you are not allowed 
to use range (>, <) on partition key column, it can only be used in clustering columns.
*/

/*
the partition key is the minimum-specifier needed to perform a query using a where clause. we can query based on all key 
(both partition and clustering) as well.
*/


/*
If you have a composite partition key, like the following ::

PRIMARY KEY((col1, col2), col10, col4))
You can perform query using where only by passing at least both col1 and col2, these are the 2 columns that define the partition key. 
The "general" rule to make query is you have to pass at least all partition key columns, then you can add optionally each 
clustering key in the order they're set.

so the valid queries are (excluding secondary indexes)::
col1 and col2
col1 and col2 and col10
col1 and col2 and col10 and col 4
*/
