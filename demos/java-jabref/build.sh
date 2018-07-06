#!/bin/bash
set -e

echo "#######################"
echo "# Running JabRef demo #"
echo "#######################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc
pushd ${DEMOWD}
setup_git_src https://github.com/JabRef/jabref.git master jabref

pushd jabref
git clean -fxd
echo "Applying qmstr plugin to gradle build configuration"
patch -p1  < ${DEMOWD}/add-qmstr.patch
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)

echo "[INFO] Start gradle build"
qmstr --container qmstr/java-jabrefdemo ./gradlew qmstr

echo "[INFO] Build finished. Triggering analysis."
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Triggering reporting."
qmstrctl report --verbose

qmstrctl quit

echo "[INFO] Build finished."
