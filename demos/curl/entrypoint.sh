#!/bin/bash
set -e

trap cleanup_master EXIT

source ../../build.inc
BASEDIR="$(dirname "$(readlink -f "$0")")"
echo "BASEDIR: $BASEDIR"

# Use easy mode to create sym link to qmstr-wrapper
newPath=$(qmstr -keep which gcc | head -n 1 | cut -d '=' -f2)
export PATH=$newPath
echo "Path adjusted to enable Quartermaster instrumentation: $PATH"

sed "s#SOURCEDIR#$(pwd)#" ${BASEDIR}/qmstr.tmpl > ${BASEDIR}/qmstr.yaml
run_qmstr_master

setup_git_src https://git.fsfe.org/jonas/curl.git reuse-compliant curl

mv ../../curl ${BASEDIR}
pushd ${BASEDIR}/curl
git clean -fxd
mkdir build
cd build
GCCPATH=$(qmstr -keep which gcc | tail -n 1)
echo "GCCPATH: $GCCPATH"
GCCBINPATH=${GCCPATH%/*}
echo "GCCBINPATH: $GCCBINPATH"
export CC=$GCCPATH
export CXX=$GCCBINPATH/g++
export CMAKE_LINKER=gcc

echo "Waiting for qmstr-master server to connect in ${QMSTR_ADDRESS}"
qmstr-cli --cserv ${QMSTR_ADDRESS} wait
echo "master server up and running"

cmake ..
make 

echo "curl built"
echo "starting analysis"
qmstr-cli --cserv ${QMSTR_ADDRESS} analyze

echo "Analysis finished."
#echo "[INFO] start reporting process"
#echo "[INFO] create report skeleton"
#sh /qmstr/cmd/qmstr-reporter-html/setup.sh /usr/local/share/qmstr /qmstr

#echo "[INFO] call cli report"
#qmstr-cli --cserv ${QMSTR_ADDRESS} report

echo "Build finished. Don't forget to quit the qmstr-master server."