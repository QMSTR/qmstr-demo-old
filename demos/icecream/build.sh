#!/bin/bash
set -e

echo "#####################"
echo "# Running Icecream demo #"
echo "#####################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc

pushd ${DEMOWD}
setup_git_src https://github.com/icecc/icecream.git master icecream

pushd icecream
git clean -fxd
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)
echo "master server up and running"

echo "[INFO] Start icecream build"
qmstr --verbose --container qmstr/icecreamdemo -- ./autogen.sh
qmstr --verbose --container qmstr/icecreamdemo -- ./configure --prefix=/opt/icecream
qmstr --verbose --container qmstr/icecreamdemo -- make

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
