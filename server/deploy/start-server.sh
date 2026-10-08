#!/bin/sh

exec java \
  "-Dspring.profiles.active=${PROFILE}" \
  "-DMYSQL_HOST=${MYSQL_HOST}" \
  "-DDB_USERNAME=${DB_USERNAME}" \
  "-DDB_PASSWORD=${DB_PASSWORD}" \
  "-DDB_NAME=${DB_NAME}" \
  "-DREDIS_HOST=${REDIS_HOST}" \
  "-DREDIS_PORT=${REDIS_PORT}" \
  -jar /app/app.jar
