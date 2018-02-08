#!/bin/bash
set -e

source ../build.inc
init
run_qmstr_master

JSONC_BRANCH="master"

setup_git_src https://github.com/json-c/json-c.git master json-c

cd json-c
git clean -fxd

qmstr-cli wait

sh autogen.sh
./configure

make -j4
LIBRARY_PATH=$(pwd)/.libs

cd ..
export C_INCLUDE_PATH="$(pwd)"
cd Calculator
make clean

export LIBRARY_PATH
make -j4

echo "Build finished. Don't forget to quit the qmstr-master server."
