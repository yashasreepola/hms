# Stage 1: Build
# We use a Maven image that includes Java 21
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run
# CRITICAL CHANGE: We use openjdk:21 (not 17) to match the build version
FROM openjdk:21-jdk-slim
WORKDIR /app
COPY --from=build /app/target/hms-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]