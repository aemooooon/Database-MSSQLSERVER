# db3

### address 
fthictsql04.ict.op.ac.nz

10.75.100.2:1433


huadb.database.windows.net

start MSSQL SERVER AGENT Services on Docker ubuntu:
1. `docker exec -it hua /bin/bash` # login into Docker
2. `sudo /opt/mssql/bin/mssql-conf set sqlagent.enabled true` # run this enable command
3. logout docker and stop , start container
