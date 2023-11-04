FROM tomcat:latest

LABEL maintainer="Anil Kumar"

ADD ./target/AnilKumar-1.0.war /usr/local/tomcat/webapps/

EXPOSE 8080
