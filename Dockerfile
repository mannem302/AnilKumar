FROM tomcat:latest

LABEL maintainer="Anil Kumar"

COPY ./target/AnilKumar-1.0.war /usr/local/tomcat/webapps/Anil

EXPOSE 8080
