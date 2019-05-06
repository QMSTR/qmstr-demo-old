#!/bin/bash
set -e

echo "#######################"
echo "# Running json-c demo #"
echo "#######################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

pushd ${DEMOWD}
source ../../build.inc
setup_git_src https://github.com/json-c/json-c.git master jsonc

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait)
echo "master server up and running"

qmstrctl create package:jsonc --version $(cd jsonc && git describe --always)

qmstr --container qmstr/jsoncdemo -- sh autogen.sh
qmstr --container qmstr/jsoncdemo -- ./configure
qmstr --container qmstr/jsoncdemo -- make -j4

qmstrctl connect package:jsonc file:$(find jsonc -name "libjson-c.so.?.*")

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
