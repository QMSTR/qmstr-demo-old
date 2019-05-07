#!/bin/bash
set -e

echo "#########################"
echo "# Running Icecream demo #"
echo "#########################"

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

qmstrctl create package:icecream --version $(cd icecream && git describe --tags --dirty --long)

echo "[INFO] Start icecream build"
qmstrctl --verbose spawn qmstr/icecreamdemo qmstr run -i /tmp/inst ./autogen.sh
qmstrctl --verbose spawn qmstr/icecreamdemo qmstr run -i /tmp/inst ./configure --prefix=/opt/icecream
qmstrctl --verbose spawn qmstr/icecreamdemo qmstr run -i /tmp/inst make

qmstrctl connect package:icecream file:icecream/client/icecc file:icecream/daemon/iceccd

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
