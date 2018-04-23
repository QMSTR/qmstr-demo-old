#!/bin/bash
set -e

trap cleanup_master EXIT

echo "####################"
echo "Running Calculator demo"
echo "####################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

echo "DEMOWD: $DEMOWD"
# Use easy mode to create sym link to qmstr-wrapper
newPath=$(qmstr -keep which gcc | head -n 1 | cut -d '=' -f2)
export PATH=$newPath
echo "Path adjusted to enable Quartermaster instrumentation: $PATH"

source ${DEMOWD}/../../build.inc

sed "s#SOURCEDIR#${DEMOWD}#" ${DEMOWD}/qmstr.tmpl >  ${DEMOWD}/qmstr.yaml
run_qmstr_master

JSONC_BRANCH="master"

pushd ${DEMOWD}
setup_git_src https://github.com/json-c/json-c.git master json-c

pushd json-c
git clean -fxd

ADDRESS=$(check_qmstr_address)

echo "Waiting for qmstr-master server"
qmstr-cli $ADDRESS wait
echo "master server up and running"

sh autogen.sh
./configure

make -j4
LIBRARY_PATH=$(pwd)/.libs

popd
export C_INCLUDE_PATH="${DEMOWD}"
pushd ${DEMOWD}/Calculator
make clean

export LIBRARY_PATH
make -j4

echo "[INFO] Build finished. Triggering analysis."
qmstr-cli $ADDRESS analyze

echo "[INFO] Analysis finished. Triggering reporting."
qmstr-cli $ADDRESS report

# Remove json-c folder
echo "deleting temporary directory json-c"
rm -rf ${DEMOWD}/json-c 

echo "Build finished. Don't forget to quit the qmstr-master server."
