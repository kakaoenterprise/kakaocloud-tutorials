#!/bin/bash

# install docker / docker-compose

sudo apt-get update
sudo apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo apt-get -y install docker-compose

# run docker compose - nginx proxy manager

mkdir ~/nginx-proxy-manager
cat << EOF > ~/nginx-proxy-manager/docker-compose.yaml
version: "3"
services:
  app:
    image: 'jc21/nginx-proxy-manager:2.9.20'
    restart: unless-stopped
    ports:
      # These ports are in format <host-port>:<container-port>
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
      - '10000-10199:10000-10199' # User Port
      - '3306:3306'
      # Add any other Stream port you want to expose
      # - '21:21' # FTP
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "npm"
      DB_MYSQL_NAME: "npm"
      # Uncomment this if IPv6 is not enabled on your host
      # DISABLE_IPV6: 'true'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
    depends_on:
      - db

  db:
    image: 'jc21/mariadb-aria:latest'
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: 'npm'
      MYSQL_DATABASE: 'npm'
      MYSQL_USER: 'npm'
      MYSQL_PASSWORD: 'npm'
    volumes:
      - ./data/mysql:/var/lib/mysql
EOF

sudo docker-compose -f ~/nginx-proxy-manager/docker-compose.yaml up -d

sleep 30

# update stream

TOKEN=$(curl -XPOST http://localhost:81/api/tokens \
    -H 'Content-Type: application/json' \
    -d '{"identity":"admin@example.com", "secret":"changeme"}' | \
      python3 -m json.tool | \
      grep '"token":' | \
      sed 's/^.*"token": "\(.*\)".*$/\1/')

curl -XPOST -H "Authorization: Bearer $TOKEN" \
    "http://localhost:81/api/nginx/streams" \
    -H 'Content-Type: application/json' \
    -d "{\"incoming_port\":10000, \"forwarding_host\":\"${web1}\", \"forwarding_port\":22, \"tcp_forwarding\":true}"

curl -XPOST -H "Authorization: Bearer $TOKEN" \
    "http://localhost:81/api/nginx/streams" \
    -H 'Content-Type: application/json' \
    -d "{\"incoming_port\":10001, \"forwarding_host\":\"${web2}\", \"forwarding_port\":22, \"tcp_forwarding\":true}"

curl -XPOST -H "Authorization: Bearer $TOKEN" \
    "http://localhost:81/api/nginx/streams" \
    -H 'Content-Type: application/json' \
    -d "{\"incoming_port\":10002, \"forwarding_host\":\"${app1}\", \"forwarding_port\":22, \"tcp_forwarding\":true}"

curl -XPOST -H "Authorization: Bearer $TOKEN" \
    "http://localhost:81/api/nginx/streams" \
    -H 'Content-Type: application/json' \
    -d "{\"incoming_port\":10003, \"forwarding_host\":\"${app2}\", \"forwarding_port\":22, \"tcp_forwarding\":true}"
