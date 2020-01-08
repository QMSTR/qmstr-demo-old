#!/bin/bash
set -e

echo "######################"
echo "# Running Guava demo #"
echo "######################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc
pushd ${DEMOWD}
setup_git_src https://github.com/google/guava.git v27.1 guava

pushd guava
git clean -fxd
echo "Applying qmstr plugin to pom"
git am < ${DEMOWD}/0001-Apply-qmstr-plugin.patch
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)

echo THIS IS DA ENV
qmstrctl spawn qmstr/java-guavademo mvn -v
echo "++++++++++"

echo "[INFO] Start gradle build"
qmstrctl spawn qmstr/java-guavademo mvn -pl .,guava clean package

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl wait -t 200
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "[INFO] Build finished."
