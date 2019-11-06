# db3

### address 
fthictsql04.ict.op.ac.nz
10.75.100.2:1433
huadb.database.windows.net
docker 10.25.1.150:1423

### start MSSQL SERVER AGENT Services on Docker ubuntu:
1. `docker exec -it hua /bin/bash` # login into Docker
2. `sudo /opt/mssql/bin/mssql-conf set sqlagent.enabled true` # run this enable command
3. logout docker and stop , start container

### To make an image from container then push it to docker hub
1. Login docker hub first `docker login`

2. To commit docker container and generate image
`docker commit <container id> <docker hub repo>:<tag>`
e.g. docker commit e9781a6f3874 yandongqiao/sqlserver:2017-latest

3. To push it
`docker push <docker hub repo>:<tag>`
e.g. docker push yandongqiao/sqlserver:2017-latest
