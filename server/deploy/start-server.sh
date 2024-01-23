#!/bin/sh

JAVA_OPT=" -Dspring.profiles.active=${PROFILE} "
JAVA_OPT=${JAVA_OPT}" -DMYSQL_HOST=${MYSQL_HOST} "
JAVA_OPT=${JAVA_OPT}" -Dspring.datasource.hikari.username=${DB_USERNAME} "
JAVA_OPT=${JAVA_OPT}" -Dspring.datasource.hikari.password=${DB_PASSWORD} "
JAVA_OPT=${JAVA_OPT}" -DHOSTNAME=${DB_NAME} "

echo "JAVA_OPT=${JAVA_OPT}"
java -jar ${JAVA_OPT} /app/app.jar