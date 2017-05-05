# Demo running two molgenis instances ( red and blue ) on one ip with https

* Create a user defined network for each molgenis-app ( i.e. red and blue)

`docker network create --driver bridge mol-net-red`

`docker network create --driver bridge mol-net-blue`

* Show new network(s)


`docker network ls`


* Start a (default) postgres container on each of the networks

`docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name mol-postgres-blue --network mol-net-blue postgres`

`docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name mol-postgres-red --network mol-net-red postgres`


* View network and see the containers

`docker network inspect mol-net-blue mol-net-red`


* If not already done, build a molgenis-tomcat image using the buildfile ( in the current dir)

optionaly remove container: `docker rm -f molgenis-blue`
optionaly remove container: `docker rm -f molgenis-red`

optionaly remove image: `docker image rm molgenis/app:4.0.0`

`docker build --no-cache -t molgenis/app:4.0.0 . `

* View the images
`docker images`

* Start a molgenis on the user defined network and use the postgres container name in the db connection string  (replace path with your own path)

`docker run -v ~/Code/docker-molgenis/molgenis-blue/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties --network mol-net-blue --name molgenis-blue -d molgenis/app:4.0.0`

`docker run -v ~/Code/docker-molgenis/molgenis-red/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties --network mol-net-red --name molgenis-red -d molgenis/app:4.0.0`


* For demo only on mac edit /etc/hosts file to loop server-name to localhost

`127.0.0.1 molgenis-red`

`127.0.0.1 molgenis-blue`

* Start a nginx to proxy red and blue based on the host name, include volume to certs connect proxy to both networks
expose 80 ( for http )and 443 for https (replace path with your own path)

`docker run --name nginx -v /Users/connorstroomberg/Code/docker-molgenis/nginx/myconf.conf:/etc/nginx/nginx.conf:ro -v /Users/connorstroomberg/Code/docker-molgenis/nginx/certs:/etc/nginx/ssl -p 80:80 -p 443:443 -d nginx`

* Add the nginx to both networks ( red and blue ) so the proxy can see both molgenis instances

`docker network connect mol-net-blue nginx`

`docker network connect mol-net-blue nginx`

`docker restart nginx`

* Optionaly add selfsigned certs to the keychain to remove warning
