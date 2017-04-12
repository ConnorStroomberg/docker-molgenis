
create a user defined network

start postgres on the user defined network

view the postgres ip

start the molgenis on the user defined network and use the postgres ip as connection host ip

docker network create --driver bridge mol-net
docker network ls
docker network inspect mol-net
docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name mol-postgres --network mol-net postgres

docker rm -f molgenis-blue
docker image rm mol/tomcat
docker build --no-cache -t mol/tomcat .
docker run -v ~/Code/docker-molgenis/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties -p 8080:8080 --network mol-net --name molgenis-blue mol/tomcat
