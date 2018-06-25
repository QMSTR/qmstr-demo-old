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
source ../../container/build.inc
setup_git_src https://github.com/json-c/json-c.git master jsonc

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait)
echo "master server up and running"

qmstr --container qmstr/demojsonc sh autogen.sh
qmstr --container qmstr/demojsonc ./configure
qmstr --container qmstr/demojsonc make

echo "[INFO] Build finished. Triggering analysis."
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Triggering reporting."
qmstrctl report --verbose

echo "Build finished."
