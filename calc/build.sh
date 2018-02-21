#!/bin/bash
set -e

source ../build.inc
init
sed "s#SOURCEDIR#$(pwd)#" qmstr.tmpl > qmstr.yaml
run_qmstr_master

JSONC_BRANCH="master"

setup_git_src https://github.com/json-c/json-c.git master json-c

pushd json-c
git clean -fxd

echo "Waiting for qmstr-master server"
qmstr-cli wait

sh autogen.sh
./configure

make -j4
LIBRARY_PATH=$(pwd)/.libs

popd
export C_INCLUDE_PATH="$(pwd)"
pushd Calculator
make clean

export LIBRARY_PATH
make -j4

qmstr-cli analyze
qmstr-cli report

echo "Build finished. Don't forget to quit the qmstr-master server."
