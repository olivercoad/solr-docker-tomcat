FROM tomcat:7.0-jre8 as extractor
ADD http://archive.apache.org/dist/lucene/solr/4.2.1/solr-4.2.1.tgz /
RUN unzip /solr-4.2.1/dist/solr-4.2.1.war -d /solr-war


FROM tomcat:7.0-jre8
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=extractor /solr-4.2.1/example/solr /usr/local/solr
COPY --from=extractor /solr-war /usr/local/tomcat/webapps/solr

RUN echo "export JAVA_OPTS=\"-Djava.security.egd=/dev/./urandom -Djava.awt.headless=true -Xmx1024m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -Dsolr.solr.home=/usr/local/solr\"" > /usr/local/tomcat/bin/setenv.sh

RUN mkdir /usr/local/solr/collection1/data



EXPOSE 8080
ENTRYPOINT [ "catalina.sh" ]
CMD ["run"]