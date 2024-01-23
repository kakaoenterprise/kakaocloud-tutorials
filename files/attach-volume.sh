#!/bin/bash

while [ ! -b /dev/vdb ]; do sleep 1; done

cat <<EOF | sudo fdisk /dev/vdb
n
p
1


w
EOF

sudo mkfs -t xfs /dev/vdb1

sudo mkdir -p /data
sudo mount /dev/vdb1 /data