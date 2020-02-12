#!/bin/bash

set -e

retries=0
while [ $retries -le 6 ]
do
  nc -z master 50051
  result=$?
  if [[ ${result} -eq 0 ]]
  then
    echo "[INFO] Connected to master."
    break
  else
    echo "[INFO] Waiting for master..."
    sleep 3
    retries=$(( $retries + 1 ))
  fi
done

if [ $retries -eq 6 ]
then
  echo "[ERROR] Could not connect to master. Exiting."
  exit 1
fi

cd ${BUILDPATH}

echo "[INFO] Cleaning codebase."
make clean

echo ""
echo ""
echo "###########################"
echo "# Running Calculator demo #"
echo "###########################"

socat tcp-l:50051,fork,reuseaddr tcp:${MASTER_ADDRESS} &
qmstrctl create package:calc --cserv ${MASTER_ADDRESS}
qmstr run make -j4

qmstrctl connect package:calc file:libcalc.a file:calcs file:libcalc.so file:hash:$(sha1sum calc | awk '{ print $1 }') --cserv ${MASTER_ADDRESS}

echo "[INFO] Build finished."
qmstrctl analyze --verbose --cserv ${MASTER_ADDRESS}

echo "[INFO] Analysis finished."


