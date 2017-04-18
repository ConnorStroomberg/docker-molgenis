
* Create a user defined network

`docker network create --driver bridge mol-net`

* Show new network


`docker network ls`


* Start postgres on the user defined network

`docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name mol-postgres-blue --network mol-net postgres`

`docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name mol-postgres-red --network mol-net postgres`


* View network and see the containers

`docker network inspect mol-net`


* Start a molgenis on the user defined network and use the postgres container name in the db connection string

`docker rm -f molgenis-blue`

`docker image rm mol/tomcat`

`docker build --no-cache -t mol/tomcat . `

`docker run -v ~/Code/docker-molgenis/molgenis-blue/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties --network mol-net --name molgenis-blue mol/tomcat`

`docker run -v ~/Code/docker-molgenis/molgenis-red/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties --network mol-net --name molgenis-red mol/tomcat`


* On mac edit /etc/hosts file to loop server-name to localhost

`127.0.0.1 molgenis-red`

`127.0.0.1 molgenis-blue`

docker run --name nginx -v /Users/connor/Code/docker-molgenis/nginx/myconf.conf:/etc/nginx/nginx.conf:ro -p 80:80 -p 443:443 -d --network mol-net nginx
