--download the binary for apache-cassandra and unzip it
--go inside the bin folder from command prompt and run the following commands sequentially

./cassandra

./cqlsh

/*
you might face this issue in your local cassandra which says connection error or that the cassandar server is already running 
in such cases the best thing we could do is kill all the cassandra related instances from local and restart the cassandra server
*/
--finding out the running cassandra related instances
ps -ax | grep cassandra

--finding out the cassandra instance pid through the usual port cassandra uses : 9160
lsof -i :9160

--once you have the PID just run the following command
kill -9 <PID>

--also one can use this as well to kill the cassandra instances
nodetool drain
