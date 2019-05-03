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

qmstrctl create package:curl --version $(cd curl && git describe --tags --dirty --long)

echo "[INFO] Start curl build"
qmstr --verbose --container qmstr/curldemo -- cmake ..
qmstr --verbose --container qmstr/curldemo -- make

qmstrctl connect package:curl file:curl/build/src/curl file:curl/build/lib/libcurl.so

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
