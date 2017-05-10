FROM tomcat:7.0-jre8-alpine

# Write tomcat settings to setenv.sh
RUN echo 'CATALINA_OPTS="-Xmx2g -Dmolgenis.home=/usr/local/tomcat/"' > /usr/local/tomcat/bin/setenv.sh

# Remove all (default) app from tomcat
RUN rm -fr $CATALINA_HOME/webapps/*

# Download molgenis war from maven.org
#
# --no-cache allows users to install packages with an index that is updated and used on-the-fly and not cached locally
# This avoids the need to use --update and remove /var/cache/apk/* when done installing packages.
RUN apk --no-cache add openssl \
	&& wget -O wget -O $CATALINA_HOME/webapps/ROOT.war https://repo1.maven.org/maven2/org/molgenis/molgenis-app/4.0.0/molgenis-app-4.0.0.war

# Allow tomcat to read and exec files in webapps (sub)folder
RUN chmod -R 2755 webapps $CATALINA_HOME/webapps

EXPOSE 8080

CMD ["catalina.sh", "run"]
