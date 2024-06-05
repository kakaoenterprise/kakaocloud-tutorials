# build stage
FROM docker.io/library/openjdk:21-slim AS builder
WORKDIR /app

COPY . .
RUN ./gradlew build


# run stage
FROM docker.io/library/openjdk:21-slim AS runner

ENV PROFILE "dev"
ENV MYSQL_HOST "localhost"
ENV DB_USERNAME "user"
ENV DB_PASSWORD "password"
ENV DB_NAME "library"
ENV REDIS_HOST "localhost"
ENV REDIS_PORT "6379"

EXPOSE 8080
WORKDIR /app

COPY --from=builder /app/build/libs/*.jar ./app.jar
COPY --from=builder /app/deploy/start-server.sh ./start-server.sh
RUN chmod +x /app/start-server.sh

ENTRYPOINT /app/start-server.sh
