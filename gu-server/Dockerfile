# SECURITY-REVIEWED: 2026-07-02 | RULES: v2.6.0-draft

# ========== 构建阶段 ==========
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn package -DskipTests -B

# ========== 运行阶段 ==========
FROM eclipse-temurin:21-jre

WORKDIR /app
COPY --from=builder /build/target/gu-server-1.0.0.jar app.jar

EXPOSE 8080

RUN groupadd -r app && useradd -r -g app app
USER app

ENTRYPOINT ["java", "-jar", "app.jar"]