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


    
