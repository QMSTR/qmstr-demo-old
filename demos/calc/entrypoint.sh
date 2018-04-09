#!/bin/bash
set -e

BASEDIR="$(dirname "$(readlink -f "$0")")"
echo "BASEDIR: $BASEDIR"

# Use easy mode to create sym link to qmstr-wrapper
newPath=$(qmstr -keep which gcc | head -n 1 | cut -d '=' -f2)
export PATH=$newPath
echo "Path adjusted to enable Quartermaster instrumentation: $PATH"

source ${BASEDIR}/../../build.inc

echo "PWD_DEMOS: $PWD_DEMOS"
sed "s#SOURCEDIR#${PWD_DEMOS:-$(pwd)}#" ${BASEDIR}/qmstr.tmpl >  ${BASEDIR}/qmstr.yaml
run_qmstr_prod

JSONC_BRANCH="master"

setup_git_src https://github.com/json-c/json-c.git master json-c

pushd json-c
git clean -fxd

echo "[INFO]Waiting for qmstr-master server to connect in ${QMSTR_ADDRESS}"
qmstr-cli --cserv ${QMSTR_ADDRESS} wait

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
qmstr-cli --cserv ${QMSTR_ADDRESS} analyze

echo "[INFO] start reporting process"
echo "[INFO] create report skeleton"
sh /qmstr-master/cmd/qmstr-reporter-html/setup.sh /usr/local/share/qmstr /qmstr-master

echo "[INFO] call cli report"
qmstr-cli --cserv ${QMSTR_ADDRESS} report

echo "[INFO]Build finished. Don't forget to quit the qmstr-master server."
