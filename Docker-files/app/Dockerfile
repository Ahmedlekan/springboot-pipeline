FROM tomcat:10.1.20-jdk17-temurin

# Optional cleanup for smaller image:
RUN rm -rf /usr/local/tomcat/webapps/*

# Add your WAR as ROOT.war so it is auto-deployed at /
COPY target/*javaspringboot-v2.war /usr/local/tomcat/webapps/ROOT.war


