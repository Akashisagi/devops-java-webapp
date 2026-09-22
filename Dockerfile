# Build Base Runtime
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

# Copy built JAR artifact from Maven target directory
COPY target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
