#!/bin/bash
set -e

IFS=':' read -ra ADDR <<< "${QMSTRADDRENV}"

retries=0
while [ $retries -le 6 ]
do
  nc -z ${ADDR[0]} ${ADDR[1]}
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

echo $BUILDPATH
echo $QMSTRADDRENV

echo ""
echo ""
echo "###########################"
echo "# Running Calculator demo #"
echo "###########################"

socat tcp-l:50051,fork,reuseaddr tcp:${QMSTRADDRENV} &
qmstrctl create package:calc --cserv ${QMSTRADDRENV}
qmstr run make

qmstrctl connect package:calc file:name:libcalc.a file:name:calcs file:name:libcalc.so file:hash:$(sha1sum calc | awk '{ print $1 }') --cserv ${QMSTRADDRENV}

echo "[INFO] Build finished."
qmstrctl analyze --verbose --cserv ${QMSTRADDRENV}

echo "[INFO] Analysis finished."


