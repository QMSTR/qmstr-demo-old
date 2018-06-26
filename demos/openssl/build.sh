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

qmstr --verbose --container qmstr/demoopenssl ./config
qmstr --verbose --container qmstr/demoopenssl make

echo "[INFO] Build finished. Triggering analysis."
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Triggering reporting."
qmstrctl report --verbose
qmstrctl quit
echo "Build finished."
