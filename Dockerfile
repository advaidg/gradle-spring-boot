# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled Spring Boot JAR file(s) with a wildcard into the container
COPY build/libs/*.jar /app/

# Expose the port that your Spring Boot application listens on (default is 8080)
EXPOSE 8080
# Command to run your Spring Boot application when the container starts
CMD ["sh", "-c", "java -jar /app/*.jar"]
