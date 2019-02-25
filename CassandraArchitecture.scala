Cassandra is a column-oriented NoSQL database, popular for its high performance writability. It can also be considered as 
a key-value NoSQL database. 

Cassandra follows "eventually consistent", that is eventually the database will be consistent.

Cassandra supports ACID property(Atomicity, Consistency, Isolation, Durability).

Cassandra has peer-to-peer distributed system across its nodes, that is it doesnt follow master-slave architecture.

All the nodes in a cluster play the same role. Each node is independent and at the same time interconnected to other nodes.

Each node in a cluster can accept read and write requests, regardless of where the data is actually located in the cluster.


key Components of Cassandra ::

Node        ==> It is the place where data is stored.

Data center ==> It is a collection of related nodes.

Cluster     ==> A cluster is a component that contains one or more data centers.

Commit log  ==> The commit log is a crash-recovery mechanism in Cassandra. Every write operation is written to the commit log.

Mem-table   ==> A mem-table is a memory-resident data structure. After commit log, the data will be written to the mem-table. 
              Sometimes, for a single-column family, there will be multiple mem-tables.

SSTable     ==> It is a disk file to which the data is flushed from the mem-table when its contents reach a threshold value.

Bloom filter ==> These are nothing but quick, nondeterministic, algorithms for testing whether an element is a member of a set.
                 It is a special kind of cache. Bloom filters are accessed after every query.
                 
                 
Cassandra stores data replicas on multiple nodes to ensure reliability and fault tolerance. The replication strategy for each 
Edge keyspace determines the nodes where replicas are placed. As a general rule, the replication factor should not exceed the 
number of Cassandra nodes in the cluster.

the keyspace details of my project cassandra database::
@cqlsh> DESCRIBE KEYSPACE itunes_eventing_core;

CREATE KEYSPACE itunes_eventing_core WITH replication = {'class': 'NetworkTopologyStrategy', 'PV': '3', 'ST': '3'}  
AND durable_writes = true;





