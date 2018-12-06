# sudo docker network create <NETWORK_NAME> 
# docker run -d --name app --network <NETWORK_NAME> my-company/my-app:latest

# build servlet and create war file
FROM maven:latest AS warfile
WORKDIR /usr/src/tester
COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

# build tomcat and copy run.sh
FROM tomcat:9.0-jre8-alpine
WORKDIR /usr/local/tomcat/bin
COPY run.sh run.sh
RUN chmod +x run.sh

# copy war file
WORKDIR /usr/local/tomcat/webapps
COPY  --from=warfile /usr/src/tester/target/java-servlet-example-0.0.1-SNAPSHOT.war Tester.war

# set datadog environment variables
# https://docs.datadoghq.com/tracing/setup/docker/?tab=java
ENV DD_SERVICE_NAME="java-tester"

# configure labels for autodiscovery
# https://docs.datadoghq.com/agent/autodiscovery/?tab=docker#template-source-docker-label-annotations
LABEL "com.datadoghq.ad.check_names"='["jmx"]'
LABEL "com.datadoghq.ad.init_configs"='[{}]'
LABEL "com.datadoghq.ad.instances"='[{"host": "%%host%%", "port": "7199", "jmx_url": "service:jmx:rmi:///jndi/rmi://%%host%%:7199/jmxrmi"}]'

# expose ports
EXPOSE 8080
EXPOSE 7199

# copy datadog java agent
# https://docs.datadoghq.com/tracing/setup/java/#installation-and-getting-started
WORKDIR /usr/local/tomcat/bin
COPY dd-java-agent.jar .

# run start script
CMD ["run.sh"]
