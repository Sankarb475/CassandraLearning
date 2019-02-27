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
                Data in the commit log is purged after its corresponding data in the memtable is flushed to an SSTable. It is 
                part of disk memory.

Mem-table   ==> A mem-table is a memory-resident data structure. After commit log, the data will be written to the mem-table. 
              Sometimes, for a single-column family, there will be multiple mem-tables.

SSTable     ==> It is a disk file to which the data is flushed from the mem-table when its contents reach a threshold value.
                Sorted Strings Table (borrowed from google) is a file of key/value string pairs, sorted by keys.

Bloom filter ==> These are nothing but quick, nondeterministic, algorithms for testing whether an element is a member of a set.
                 It is a special kind of cache. Bloom filters are accessed after every query.
                 
** Memtables and SSTables are maintained per table. SSTables are immutable, not written to again after the memtable is flushed.              
                 
                 
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


--Data Replication in Cassandra
SimpleStrategy ::
Use only for a single datacenter and one rack. SimpleStrategy places the first replica on a node determined by the partitioner. 
Additional replicas are placed on the next nodes clockwise in the ring without considering topology 
(rack or datacenter location).

NetworkTopologyStrategy ::
Use NetworkTopologyStrategy when you have (or plan to have) your cluster deployed across multiple datacenters. This strategy 
specifies how many replicas you want in each datacenter. NetworkTopologyStrategy places replicas in the same datacenter by 
walking the ring clockwise until reaching the first node in another rack. NetworkTopologyStrategy attempts to place replicas 
on distinct racks because nodes in the same rack (or similar physical grouping) often fail at the same time due to power, 
cooling, or network issues.

--Cassandra Replication Factor and Consistency Level
The Cassandra consistency level is defined as the minimum number of Cassandra nodes that must acknowledge a read or write 
operation before the operation can be considered successful. Different consistency levels can be assigned to different Edge 
keyspaces.
LOCAL_QUORUM = (replication_factor/2) + 1  ==> is the minimum number of nodes that has to respond on a read/write request 
operation for the operation to succeed.
If a keyspace used the Cassandra QUORUM value as the consistency level, read/write operations would have to be validated 
across all data centers.

cqlsh> CONSISTENCY ANY
==> A write must be written to at least one node. The write operation would stil be successful if all the replica nodes are 
down after a hinted handoff has been written. If all replica nodes are down at write time, an ANY write is not readable until 
the replica nodes for that partition have recovered.

cqlsh> CONSISTENCY 
Current consistency level is ONE.

cqlsh> CONSISTENCY QUORUM 
Consistency level set to QUORUM.

cqlsh> CONSISTENCY
Current consistency level is QUORUM.

cqlsh> CONSISTENCY LOCAL_QUORUM 
Consistency level set to LOCAL_QUORUM.

-- Key components for configuring Cassandra
Gossip ::
Gossip is a peer-to-peer communication protocol in which nodes periodically exchange state information about themselves and 
about other nodes they know about. The gossip process runs every second and exchanges state messages with up to three other 
nodes in the cluster. The nodes exchange information about themselves and about the other nodes that they have gossiped about, 
so all nodes quickly learn about all other nodes in the cluster.

Partitioner ::
A partitioner determines which node will receive the first replica of a piece of data, and how to distribute other replicas 
across other nodes in the cluster. Each row of data is uniquely identified by a primary key, which may be the same as its 
partition key, but which may also include other clustering columns. A partitioner is a hash function that derives a token from 
the primary key of a row. The partitioner uses the token value to determine which nodes in the cluster receive the replicas of 
that row. The Murmur3Partitioner is the default partitioning strategy for new Cassandra clusters and the right choice for new 
clusters in almost all cases.

Cassandra offers the following partitioners that can be set in the cassandra.yaml file.
Murmur3Partitioner (default): uniformly distributes data across the cluster based on MurmurHash hash values. The 
Murmur3Partitioner uses the MurmurHash function. This hashing function creates a 64-bit hash value of the partition key. 
The possible range of hash values is from -2^63 to +2^63-1.

RandomPartitioner: uniformly distributes data across the cluster based on MD5 hash values.

ByteOrderedPartitioner: keeps an ordered distribution of data lexically by key bytes

Snitch ::
A snitch defines groups of machines into datacenters and racks (the topology) that the replication strategy uses to place 
replicas.


--Data storage life cycle in cassandra
1) Logging data in the commit log
2) Writing data to the memtable
3) Flushing data from the memtable
4) Storing data on disk in SSTables
5) Compaction

*****Internally, a Cassandra index is a data partition. Each Node in Cassandra indexes its own data whatever data it stores 
to make the retrieval process faster.

*****Cassandra treats each new row as an upsert: if the new row has the same primary key as that of an existing row, Cassandra 
processes it as an update to the existing row.

--deletes in cassandra
When you delete a row from Cassandra, it does not try to find the row by scanning the data and then delete it like RDBMS. What
it does is it marks that row as tombstone. After data is marked with a tombstone, the data is automatically removed during the 
normal compaction process. Deleted data can reappear if you do not run node repair routinely.

--hinted handoff writes
cassandra consistency has to be set as ANY to enable hinted handoff. 
During a write if replica nodes are down, hinted handoff has been taken so that when they get back up it will get written.
A hint indicates that a write needs to be replayed to one or more unavailable nodes. The hint consists of:
The location of the replica that is down
Version metadata
The actual data being written

By default, hints are saved for three hours after a replica fails because if the replica is down longer than that, it is likely 
permanently dead. You can configure this interval of time using the max_hint_window_in_ms property in the cassandra.yaml file


-- Cassandra Read
To satisfy a read, Cassandra must combine results from the active memtable and potentially mutliple SSTables.

First, Cassandra checks the Bloom filter. Each SSTable has a Bloom filter associated with it that checks the probability of 
having any data for the requested partition in the SSTable before doing any disk I/O. If Bloom filter does not rule out the
SSTable, Cassandra checks the partition key cache and try to find the index and fetches the compressed output from disk.

-- A Cassandra column family has the following attributes −

keys_cached − It represents the number of locations to keep cached per SSTable.

rows_cached − It represents the number of rows whose entire contents will be cached in memory, because those are being fetched
              by client frequently.

preload_row_cache − It specifies whether you want to pre-populate the row cache.



--The commit log receives every write made to a Cassandra node, and these durable writes survive permanently even if power 
fails on a node. Data in the commit log is purged after its corresponding data in the memtable is flushed to an SSTable on 
disk. You can manually flush a table using nodetool flush or nodetool drain to SSTable.

--Storing data on disk in SSTables--
Memtables and SSTables are maintained per table. The commit log is shared among tables. SSTables are immutable, not written to 
again after the memtable is flushed.

The partition key columns are the first part of primary key and their role is to spread data evenly around the cluster. Rows 
will be spread around the cluster based on the hash of the partition keys.
The clustering key columns are used to cluster the data of a partition, allowing a very efficient retrival of rows.
Due to the differences in the role that they are playing, partition key, clustering and normal columns support different sets 
of restrictions within the WHERE clause. Futhermore, those sets of restrictions differ depending of the type of query: SELECT, 
UPDATE or DELETE.

Cassandra will require that you either restrict all the partition key columns, or none of them unless the query can use a 
secondary index. The reason why is that Cassandra needs all the partition key columns to be able to compute the hash that 
will allow it to locate the nodes containing the partition.

If you are running a query restricting the clustering column, the query would not work because Cassandra knows it would be a
very inefficient process which will end up taking a lot of resources, but if you mention "ALLOW FILTERING" that means you are
ok with the inefficiency and thus will get executed successfully.

Cassandra distributes the partition accross the nodes using the selected partitioner. As only the ByteOrderedPartitioner keeps
an ordered distribution of data Cassandra does not support >, >=, <= and < operator directly on the partition key. Because, if
Cassandra has to allow >, <, >= then the cassandra has to scan all the data based on the primary key which will be an 
inefficient processing.

If you use a ByteOrderedPartitioner, you will then be able to perform some range queries over multiple partitions. You should 
nevertheless be careful. Using a ByteOrderedPartitioner is not recommended as it can result in unbalanced clusters.

Cassandra allows you to use the >, >=, <= and < operator on the partition key through the use of the token function.

The clustering columns has to be restricted in a sequential order, the way the clustering columns has been defined in the 
creation of the table otherwise Cassandra will reject the query as it has to scan the entire partition to find the requested 
data, which is inefficient.

*** When you are restricting more than one clustering column in a single select query, only the last clustering column can
take >, < or >= etc restrictions. example ::

cqlsh:test> CREATE TABLE dum (id int, age int, role int, primary key(id,age,role));
                                                                     
cqlsh:test> INSERT INTO dum (id, age, role) VALUES ( 1, 23, 3);
                                                                     
cqlsh:test> INSERT INTO dum (id, age, role) VALUES ( 2, 23, 4);
                                                                     
cqlsh:test> INSERT INTO dum (id, age, role) VALUES ( 3, 23, 5); 

-- in the below query age clustering column age has been restricted with >                                                                     
cqlsh:test> SELECT * FROM dum where id in (1,2) and age > 21;

 id | age | role
----+-----+------
  1 |  23 |    3
  2 |  23 |    4

-- here it is not working because only last clustering column role can take > restriction.
cqlsh:test> SELECT * FROM dum where id in (1,2) and age > 21 and role = 3;
InvalidRequest: code=2200 [Invalid query] message="PRIMARY KEY column "role" cannot be restricted (preceding column "age" is 
restricted by a non-EQ relation)"

 --this query is working because role is restricted.                                                                    
cqlsh:test> SELECT * FROM dum where id in (1,2) and age =23 and role>=3;

 id | age | role
----+-----+------
  1 |  23 |    3
  2 |  23 |    4







