#!/bin/bash
set -e

echo "#####################"
echo "# Running cURL demo #"
echo "#####################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc

pushd ${DEMOWD}
setup_git_src https://github.com/curl/curl.git master curl

pushd curl
git clean -fxd
mkdir build
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)
echo "master server up and running"

echo "[INFO] Start curl build"
qmstr --verbose --container qmstr/democurl --instdir /tmp/qmstr-bin-123 -- cmake ..
qmstr --verbose --container qmstr/democurl --instdir /tmp/qmstr-bin-123 -- make

echo "[INFO] Build finished. Triggering analysis."
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Triggering reporting."
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
