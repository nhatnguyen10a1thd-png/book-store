FROM maven:3.9.11-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY pom.xml ./
RUN mvn --batch-mode --no-transfer-progress -DskipTests dependency:go-offline

COPY src ./src
RUN mvn --batch-mode --no-transfer-progress -DskipTests package

FROM tomcat:10.1-jdk21-temurin

ENV PORT=8080 \
    JAVA_TOOL_OPTIONS="-Djava.awt.headless=true -XX:MaxRAMPercentage=75.0"

RUN rm -rf "${CATALINA_HOME}/webapps"/* \
    && groupadd --system bookstore \
    && useradd --system --gid bookstore --home-dir "${CATALINA_HOME}" --shell /usr/sbin/nologin bookstore

COPY --from=build --chown=bookstore:bookstore /workspace/target/KTQTDemo.war "${CATALINA_HOME}/webapps/ROOT.war"
COPY --chown=bookstore:bookstore deploy/tomcat-entrypoint.sh /usr/local/bin/tomcat-entrypoint.sh

RUN chmod 0755 /usr/local/bin/tomcat-entrypoint.sh \
    && chown -R bookstore:bookstore "${CATALINA_HOME}"

USER bookstore

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/tomcat-entrypoint.sh"]
