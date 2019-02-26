Cassandra is a column-oriented NoSQL database, popular for its high performance writability. It can also be considered as 
a key-value NoSQL database. 

why it is column-oriented ?
==> a key-value NoSQL database, the value of which is a row of columns. The model in Cassandra is that rows contain columns 
To access the smallest unit of data (a column) you have to specify first the row name (key), then the column name. 


apple -> colour  weight  price variety
         "red"   100     40    "Cox"

orange -> colour    weight  price  origin
          "orange"  120     50     "Spain"
          
          
         
--- There is no case-sensitivity concept in Cassandra. All the data is stored as byte[], so it's not even a String.         
          
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

CREATE KEYSPACE itunes_eventing_core WITH replication = {'class': 'NetworkTopologyStrategy', 'XXX': '3', 'YYY': '3'}  
AND durable_writes = true;

==> that is for XXX data center the replication factor would be 3 and for YYY 3 as well.

durable_writes ==> Durable Writes provides a means to instruct Cassandra whether to use "commitlog" for updates on the current 
                   KeySpace or not. This option is not mandatory. The default value for durable writes is TRUE.
                   
                   
'NetworkTopologyStrategy' ==> Using this option, you can set the replication factor for each data-center independently.

The cassandra version we are using in our project :: 2.1.18.8

@cqlsh> select peer, release_version from system.peers;

 peer           | release_version
----------------+-----------------
  10.139.103.86 |        2.1.18.8





