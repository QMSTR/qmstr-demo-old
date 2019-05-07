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

qmstrctl create package:calc
pushd Calculator
make clean
popd

qmstrctl spawn qmstr/calcdemo qmstr run make -j4

qmstrctl connect package:calc file:Calculator/libcalc.a file:Calculator/calcs file:Calculator/libcalc.so file:Calculator/calc

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
