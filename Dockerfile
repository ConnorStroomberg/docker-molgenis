FROM tomcat:8.5

RUN echo 'CATALINA_OPTS="-Xmx2g -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -Dmolgenis.home=/usr/local/tomcat/"' > /usr/local/tomcat/bin/setenv.sh

RUN rm -fr $CATALINA_HOME/webapps/*

COPY molgenis-app-3.0.1.war $CATALINA_HOME/webapps/ROOT.war
RUN chmod -R 2755 webapps $CATALINA_HOME/webapps

EXPOSE 8080

CMD ["catalina.sh", "run"]
