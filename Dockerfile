FROM ubuntu AS clone
LABEL maintainer="Anil Kumar"
RUN apt update && apt install git -y
WORKDIR /mannem
RUN git clone https://github.com/mannem302/AnilKumar.git /mannem

FROM clone AS build
LABEL maintainer="Anil Kumar"
RUN apt update && apt install maven -y
WORKDIR /mannem
COPY --from=clone /mannem/* .
RUN mvn clean package

FROM tomcat
LABEL maintainer="Anil Kumar"
COPY --from=build **/target/*.war /usr/local/tomcat/webapps/anil.war
EXPOSE 8080
