#!/bin/bash

if [ $1 != "0" ]; then
  exit 0
fi

echo "This host is primary" | sudo tee /tmp/res_check_host.log

check_host() {
  host=$1
  port=$2
  res="1"
  r=$(bash -c 'exec 3<> /dev/tcp/'$host'/'$port';echo $?' 2>/dev/null)
  if [ "$r" = "0" ]; then
    res="0"
  else
    res="1"
  fi
  echo "$res"
}

for ((;;))
do
  node2=$(check_host node2.rs.in 27017)
  node3=$(check_host node3.rs.in 27017)
  code=$((node2 + node3))
  echo $code | sudo tee -a /tmp/res_check_host.log
  if [ "$code" == "0" ]; then
    break
  else
    sleep 3
  fi
done

echo "check_host is done" | sudo tee -a /tmp/res_check_host.log

mongosh --eval \
'rs.initiate( {
   _id : "${replicaset_name}",
   members: [
      { _id: 0, host: "${node1}:27017" },
      { _id: 1, host: "${node2}:27017" },
      { _id: 2, host: "${node3}:27017" }
   ]
})'