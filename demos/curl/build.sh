#!/bin/bash
set -e

source ../build.inc
init
sed "s#SOURCEDIR#$(pwd)#" qmstr.tmpl > qmstr.yaml
run_qmstr_master

setup_git_src https://git.fsfe.org/jonas/curl.git reuse-compliant curl

pushd curl
git clean -fxd
mkdir build
cd build
export CC=$QMSTR_HOME/bin/gcc
export CXX=$QMSTR_HOME/bin/g++
export CMAKE_LINKER=gcc

echo "Waiting for qmstr-master server to connect in qmstr-demo-master:50051"
qmstr-cli --cserv qmstr-demo-master:50051 wait

echo "master server up and running"

echo $PATH
cmake -DOPENSSL_ROOT_DIR=/usr/local/Cellar/openssl/1.0.2l -DOPENSSL_LIBRARIES=/usr/local/Cellar/openssl/1.0.2l/lib ..
make 

echo "curl built"
echo "starting analysis"

qmstr-cli analyze
qmstr-cli report

