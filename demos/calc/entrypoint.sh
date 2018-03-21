#!/bin/bash
set -e

function cleanup {
    docker rm -f qmstr-demo-master
}
trap cleanup EXIT

BASEDIR="$(dirname "$(readlink -f "$0")")"
echo "BASEDIR:"
echo $BASEDIR

# Use easy mode to create sym link to qmstr-wrapper
newPath=$(qmstr -keep which gcc | head -n 1 | cut -d '=' -f2)
export PATH=$newPath
echo $PATH
source ${BASEDIR}/../../build.inc
echo "PWD_DEMOS:"
echo $PWD_DEMOS
sed "s#SOURCEDIR#${PWD_DEMOS:-$(pwd)}#" ${BASEDIR}/qmstr.tmpl >  ${BASEDIR}/qmstr.yaml
run_qmstr_prod

JSONC_BRANCH="master"

setup_git_src https://github.com/json-c/json-c.git master json-c

pushd json-c
git clean -fxd

echo "[INFO]Waiting for qmstr-master server to connect in qmstr-demo-master:50051"
qmstr-cli --cserv qmstr-demo-master:50051 wait

sh autogen.sh
./configure

make -j4
LIBRARY_PATH=$(pwd)/.libs

popd
export C_INCLUDE_PATH="$(pwd)"
pushd ${BASEDIR}/Calculator
make clean

export LIBRARY_PATH
make -j4

echo "[INFO]Build finished. Triggering analysis."
qmstr-cli --cserv qmstr-demo-master:50051 analyze

echo "[INFO]Build finished. Don't forget to quit the qmstr-master server."
