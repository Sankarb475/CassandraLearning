1) Can we use where clause while using "COPY" in Cassandra
==> 
No, we can not use where clause and put any restriction, although we can select some specific columns from the table.
COPY cycling.cyclist_name (id,firstname) FROM '../cyclist_firstname.csv' WITH HEADER = TRUE ;

================================================================================================================================
2) Maximum batch size which can be imported into cassandra programmitically?
==> 
Cassandra will warn you if any multiple-partition batch size exceeds this value:
-- batch_size_warn_threshold_in_kb=5
5kb per batch by default. 

Cassandra will fail any multiple-partition batch exceeding this value. 50kb (10x warn threshold) by default.
-- batch_size_warn_threshold_in_kb=50
50kb per batch by default. 

Log when it fails :: 
       ERROR [Native-Transport-Requests-1] 2019-12-16 15:52:26,971 BatchStatement.java:295 - Batch for [project.housingdata] 
       is of size 1.753MiB, exceeding specified threshold of 50.000KiB by 1.704MiB. (see batch_size_fail_threshold_in_kb)
       
================================================================================================================================
3) How to give local Cassandra access to others?
==>
start_rpc: true

rpc_address: 0.0.0.0

broadcast_rpc_address: <IP of your local machine where cassandra server will be running>

listen_address: <IP of your local machine where cassandra server will be running>

seed_provider:
  - class_name: ...
    - seeds: <IP of your local machine where cassandra server will be running, inside double quotes>

