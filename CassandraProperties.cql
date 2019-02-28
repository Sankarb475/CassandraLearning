cqlsh:test> desc dumdum 

CREATE TABLE test.dumdum (
    id int PRIMARY KEY,
    age int,
    name text,
    role int
) WITH bloom_filter_fp_chance = 0.01
    AND caching = '{"keys":"ALL", "rows_per_partition":"NONE"}'
    AND comment = ''
    AND compaction = {'class': 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'}
    AND compression = {'sstable_compression': 'org.apache.cassandra.io.compress.LZ4Compressor'}
    AND dclocal_read_repair_chance = 0.1
    AND default_time_to_live = 0
    AND gc_grace_seconds = 864000
    AND max_index_interval = 2048
    AND memtable_flush_period_in_ms = 0
    AND min_index_interval = 128
    AND read_repair_chance = 0.0
    AND speculative_retry = '99.0PERCENTILE';
    
--lets see the properties of each table and what it signifies
    
cache :: Caching optimizes the use of cache memory of a table without manual tuning. Cassandra weighs the cached data by 
             size and access frequency.

valid cache values :

caching = {
 'keys' = 'ALL | NONE',
 'rows_per_partition' = 'ALL' | 'NONE' |N}
 
Valid values::
ALL– all primary keys or rows
NONE– no primary keys or rows
N: (rows per partition only) Number of rows; specify a whole number


compaction ::
The compaction option in CREATE TABLE or ALTER TABLE WITH clause defines the strategy for cleaning up data after writes. 

Define a compaction class and properties in simple JSON format:
compaction = { 
   'class' : 'compaction_strategy_name' 
   [, 'subproperty_name' : 'value',...] 
}

default value : SizeTieredCompactionStrategy (STCS)
Triggers a minor compaction when table meets the min_threshold. Minor compactions do not involve all the tables in a keyspace.


compression ::
Configure compression by specifying the compression algorithm class followed by the subproperties in simple JSON format. 
Choosing the right compressor depends on your requirements for space savings over read performance. LZ4 is fastest to 
decompress, followed by Snappy, then by Deflate. Compression effectiveness is inversely correlated with decompression speed. 
The extra compression from Deflate or Snappy is not enough to make up for the decreased performance for general-purpose 
workloads, but for archival data they may be worth considering.  


dclocal_read_repair_chance ::
Probability that a successful read operation triggers a read repair, between 0 and 1; default value: 0.01. 
Unlike the repair controlled by read_repair_chance, this repair is limited to replicas in the same DC as the coordinator.


default_time_to_live ::
TTL (Time To Live) in seconds, where zero is disabled. The maximum configurable value is 630720000 (20 years). If the value is 
greater than zero, TTL is enabled for the entire table and an expiration timestamp is added to each column. A new TTL timestamp
is calculated each time the data is updated and the row is removed after all the data expires.
Default value: 0 (disabled).


gc_grace_seconds ::
Seconds after data is marked with a tombstone (deletion marker) before it is eligible for garbage-collection. 
Default value: 864000 (10 days). The default value allows time for Cassandra to maximize consistency prior to deletion.


memtable_flush_period_in_ms ::
Milliseconds before memtables associated with the table are flushed.


speculative_retry ::
Overrides normal read timeout when read_repair_chance is not 1.0, sending another request to read. Specify the value as a 
number followed by a type, ms (milliseconds) or percentile. For example, speculative_retry = '3ms'.
Use the speculative retry property to configure rapid read protection. In a normal read, Cassandra sends data requests to just 
enough replica nodes to satisfy the consistency level. In rapid read protection, Cassandra sends out extra read requests to 
other replicas, even after the consistency level has been met. The speculative retry property specifies the trigger for these 
extra read requests.
