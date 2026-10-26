FROM gradle:8.10.2-jdk21-alpine AS builder
WORKDIR /workspace
COPY settings.gradle.kts build.gradle.kts ./
COPY src ./src
RUN gradle bootJar --no-daemon

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY --from=builder /workspace/build/libs/*.jar /app/app.jar
USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "/app/app.jar"]
