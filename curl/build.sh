#!/bin/bash
set -e

source ../build.inc
init
run_qmstr_master

setup_git_src https://git.fsfe.org/jonas/curl.git reuse-compliant curl 

pushd curl
git clean -fxd
mkdir build
cd build
export CC=$QMSTR_HOME/bin/gcc
export CXX=$QMSTR_HOME/bin/g++
export CMAKE_LINKER=gcc

echo "awaiting master server"
qmstr-cli wait
echo "master server up and running"

echo $PATH
cmake ..
make -j4

echo "curl built"
echo "starting analysis"

popd
sed "s#SOURCEDIR#$(pwd)#" ana.yaml > ana_curl.yaml
qmstr-cli analyze ana_curl.yaml
