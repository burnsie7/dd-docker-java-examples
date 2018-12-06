#!/bin/sh

# set path to dd-java-agent and set dd.agent.host to 'datadog-agent' (https://docs.datadoghq.com/tracing/setup/docker/?tab=java#docker-network)
# set jmx remote options if collecting jmx metrics
export JAVA_OPTS="-javaagent:/usr/local/tomcat/bin/dd-java-agent.jar -Ddd.agent.host=datadog-agent -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=7199 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
exec ${CATALINA_HOME}/bin/catalina.sh jpda run
