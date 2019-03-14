1) Can we use where clause while using "COPY" in Cassandra

==> No, we can not use where clause and put any restriction, although we can select some specific columns from the table.

COPY cycling.cyclist_name (id,firstname) FROM '../cyclist_firstname.csv' WITH HEADER = TRUE ;

