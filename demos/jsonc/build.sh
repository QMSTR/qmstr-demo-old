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

qmstr --container qmstr/jsoncdemo -- sh autogen.sh
qmstr --container qmstr/jsoncdemo -- ./configure
qmstr --container qmstr/jsoncdemo -- make

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
