//creating a keyspace

cqlsh> CREATE KEYSPACE Dummy
   ... WITH replication = {'class':'SimpleStrategy', 'replication_factor' : 3};
   
