FROM maven:3.9.11-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml ./
COPY src ./src
RUN mvn -B -ntp package

FROM tomcat:9.0-jdk17-temurin
ENV COFFEE_COOKIE_SECURE=true
RUN rm -rf /usr/local/tomcat/webapps/* \
 && sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml \
 && sed -i 's#</Context>#<CookieProcessor sameSiteCookies="strict" /></Context>#' /usr/local/tomcat/conf/context.xml
COPY --from=build /app/target/coffee-shop.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 10000
CMD ["catalina.sh", "run"]
