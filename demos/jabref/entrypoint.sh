#!/bin/bash
set -e

trap cleanup_master EXIT

echo "####################"
echo "Running JabRef demo"
echo "####################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

echo "DEMOWD: $DEMOWD"
source ${DEMOWD}/../../build.inc

# Use easy mode to create sym link to qmstr-wrapper
newPath=$(qmstr -keep which gcc | head -n 1 | cut -d '=' -f2)
export PATH=$newPath
echo "Path adjusted to enable Quartermaster instrumentation: $PATH"

sed "s#SOURCEDIR#${DEMOWD}#" ${DEMOWD}/qmstr.tmpl >  ${DEMOWD}/qmstr.yaml
run_qmstr_master

pushd ${DEMOWD}
setup_git_src https://github.com/JabRef/jabref.git master jabref

pushd jabref
git clean -fxd
echo "Applying qmstr plugin to gradle build configuration"
patch -p1  < ${DEMOWD}/add-qmstr.patch

ADDRESS=$(check_qmstr_address)
echo "Waiting for qmstr-master server"
qmstr-cli $ADDRESS wait

echo "[INFO] Start gradle build"
./gradlew qmstr

echo "[INFO] Build finished. Triggering analysis."
qmstr-cli $ADDRESS analyze

echo "[INFO] Analysis finished. Triggering reporting."
qmstr-cli $ADDRESS report

docker cp ${MASTER_CONTAINER_NAME}:/qmstr-reports.tar.bz2 ${DEMOWD}

# Remove jabref folder
echo "deleting temporary directory jabref"
rm -rf ${DEMOWD}/jabref

echo "[INFO] Build finished."