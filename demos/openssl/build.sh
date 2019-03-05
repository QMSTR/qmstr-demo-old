#!/bin/bash
set -e

echo "########################"
echo "# Running OpenSSL demo #"
echo "########################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc
pushd ${DEMOWD}
setup_git_src https://github.com/openssl/openssl.git master openssl

pushd openssl
git clean -fxd
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --verbose --wait)
echo "master server up and running"

qmstrctl create package:openssl

qmstr --verbose --container qmstr/openssldemo -- ./config
qmstr --verbose --container qmstr/openssldemo -- make

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit
echo "Build finished."
