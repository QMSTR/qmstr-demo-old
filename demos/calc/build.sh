#!/bin/bash
set -e

echo "###########################"
echo "# Running Calculator demo #"
echo "###########################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

pushd ${DEMOWD}

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait)
echo "master server up and running"

pushd Calculator
make clean
popd

qmstr --container qmstr/calcdemo -- make -j4

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
