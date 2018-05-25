#!/bin/bash
set -e

trap cleanup_master EXIT

echo "########################"
echo "# Running OpenSSL demo #"
echo "########################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

echo "DEMOWD: $DEMOWD"
source ${DEMOWD}/../../build.inc

# Use easy mode to create sym link to qmstr-wrapper
newPath=$(qmstr --keep which gcc | head -n 1 | cut -d '=' -f2)
export PATH=$newPath
echo "Path adjusted to enable Quartermaster instrumentation: $PATH"

sed "s#SOURCEDIR#${DEMOWD}#" ${DEMOWD}/qmstr.tmpl > ${DEMOWD}/qmstr.yaml
run_qmstr_master

pushd ${DEMOWD}
setup_git_src https://github.com/openssl/openssl.git master openssl

pushd openssl
git clean -fxd

echo "Waiting for qmstr-master server"
qmstrctl wait -t 300
echo "master server up and running"

./config
make -j4

echo "[INFO] Build finished. Triggering analysis."
qmstrctl analyze

echo "[INFO] Analysis finished. Triggering reporting."
qmstrctl report

docker cp ${MASTER_CONTAINER_NAME}:/var/qmstr/qmstr-reporter-html/qmstr-reports.tar.bz2 ${DEMOWD}

# Remove openssl folder
echo "deleting temporary directory openssl"
rm -rf ${DEMOWD}/openssl

echo "Build finished."
