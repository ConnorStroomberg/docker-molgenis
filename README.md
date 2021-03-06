# Demo running two molgenis instances ( red and blue ) on one ip with https

### If not already done, create a environment variable to point to the molgenis-docker home

* For example is this base for the setup is in "/Users/connorstroomberg/Code/docker-molgenis" :

`export MOLGENIS_DOCKER_HOME=/Users/connorstroomberg/Code/docker-molgenis`

* This environment variable may the set during system start up.


### Create a user defined network for each molgenis-app ( i.e. red and blue)

`docker network create blue`

`docker network create red`


* Show new network(s)

`docker network ls`



### Start a (default) postgres container on each of the networks

`docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name database-blue -v /var/lib/postgresql/data --network blue postgres`

`docker run -e POSTGRES_USER=molgenis -e POSTGRES_PASSWORD=molgenis -e POSTGRES_DB=molgenis -d --name database-red -v /var/lib/postgresql/data --network red postgres`


### Start the molgenis apps
* If not already done, build a molgenis-tomcat image using the buildfile ( in the current dir)

inside the app folder: `docker build -t molgenis/app:4.0.0 . `

* Start a molgenis on the user defined network and use the postgres container name in the db connection string  (replace path with your own path)

`docker run -v $MOLGENIS_DOCKER_HOME/molgenis-blue/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties --network blue --name molgenis-blue -d molgenis/app:4.0.0`

`docker run -v $MOLGENIS_DOCKER_HOME/molgenis-red/molgenis-server.properties:/usr/local/tomcat/molgenis-server.properties --network red --name molgenis-red -d molgenis/app:4.0.0`


### Start the proxy to serve both apps on a single ip

* Build molgenis/nginx:1.0.0 image

inside proxy folder: `docker build -t molgenis/nginx:1.0.0 . `

* Start a nginx to proxy red and blue based on the host name.
* Include volume to certificate and server-config folders on the host machine
* expose 80 ( for http )and 443 for https (replace path with your own path)

`docker run --name proxy -v $MOLGENIS_DOCKER_HOME/sites-enabled:/etc/nginx/sites-enabled:ro -v $MOLGENIS_DOCKER_HOME/certs:/etc/nginx/ssl -p 80:80 -p 443:443 -d molgenis/nginx:1.0.0`

* Add the proxy to both networks ( red and blue ) so the proxy can see both molgenis instances

`docker network connect blue proxy`

`docker network connect red proxy`

`docker restart proxy`

* For demo only on mac edit /etc/hosts file to loop server-name to localhost

`127.0.0.1 molgenis-red`

`127.0.0.1 molgenis-blue`

* Optionaly add selfsigned certs to the keychain to remove warning
