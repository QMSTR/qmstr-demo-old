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
setup_git_src https://github.com/JabRef/jabref.git v4.3 jabref

pushd jabref
git clean -fxd
echo "Applying qmstr plugin to gradle build configuration"
git am < ${DEMOWD}/add-qmstr.patch
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)

echo "[INFO] Start gradle build"
qmstrctl spawn qmstr/java-jabrefdemo ./gradlew qmstr

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "[INFO] Build finished."
