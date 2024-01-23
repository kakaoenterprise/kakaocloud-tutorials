#!/bin/bash

# Import the public key used by the package management system.
sudo apt-get install gnupg
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Create a /etc/apt/sources.list.d/mongodb-enterprise.list file for MongoDB.
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.com/apt/ubuntu focal/mongodb-enterprise/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-enterprise.list

# Install a specific release of MongoDB Enterprise.
sudo apt-get update
sudo apt-get install -y mongodb-enterprise=6.0.3

cat << EOF | sudo tee /etc/hosts
${local_dns_file}
EOF

sudo service mongod stop

sudo mkdir -p /data/mongodb
sudo mkdir -p /data/log/mongodb
sudo chown -R mongodb:mongodb /data/*
sudo chown mongodb:mongodb /tmp/mongodb-27017.sock

cat <<EOF | sudo tee /etc/mongod.conf
${mongod_config_file}
EOF

sudo service mongod start