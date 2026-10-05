FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN --mount=type=secret,id=maven_settings,target=/root/.m2/settings.xml \
    --mount=type=secret,id=maven_cacerts,target=/opt/maven-cacerts \
    --mount=type=cache,target=/root/.m2/repository \
    if [ -f /opt/maven-cacerts ]; then \
      mvn -B -ntp -Djavax.net.ssl.trustStore=/opt/maven-cacerts -Djavax.net.ssl.trustStorePassword=changeit package; \
    else mvn -B -ntp package; fi

FROM tomcat:9.0-jdk17-temurin
ENV COFFEE_COOKIE_SECURE=true
RUN rm -rf /usr/local/tomcat/webapps/* \
 && sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml \
 && sed -i 's#</Context>#<CookieProcessor sameSiteCookies="strict" /></Context>#' /usr/local/tomcat/conf/context.xml
COPY --from=build /app/target/coffee-shop.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 10000
CMD ["catalina.sh", "run"]
