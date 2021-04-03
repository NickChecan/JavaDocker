# multi-stage builds

# Compile and build the project
FROM gradle:6.8.3-jdk8 as builder
ARG VERSION=1
ARG JAR_PATH=app/build/libs/app.jar

VOLUME /tmp
WORKDIR /
ADD . .

RUN gradle --stacktrace clean test build
RUN mv /$JAR_PATH /app.jar

# Set up an optimized productive environment for the application execution
FROM openjdk:8-jre-alpine
LABEL maintainer = "nicholas.checan@gmail.com"

WORKDIR /

# Copy only the built jar and nothing else
COPY --from=builder /app.jar /

ENV VERSION=$VERSION
ENV JAVA_OPTS=-Dspring.profiles.active=production

EXPOSE 8080

ENTRYPOINT ["sh","-c","java -jar -Dspring.profiles.active=production /app.jar"]