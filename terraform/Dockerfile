# Base image with OpenJDK 17
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the JAR file from the build output
COPY conversations/target/conversations-*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/conversations || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]