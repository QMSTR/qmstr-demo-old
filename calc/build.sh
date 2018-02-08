#!/bin/bash
set -e

JSONC_BRANCH="master"

function run_qmstr_prod() {
    docker run --rm -d -p 50051:50051 -v $(pwd):/buildroot qmstr/master
}

function run_qmstr_dev() {
    if [ -z "$QMSTR_SRC" ]; then
        echo "Please set QMSTR_SRC to point to your qmstr source directory."
        exit 2
    fi
    docker run --rm -d -p 50051:50051 -p 8081:8081 -p 8080:8080 -v "${QMSTR_SRC}":/go/src/github.com/QMSTR/qmstr -v $(pwd):/buildroot qmstr/dev

}

if [ -z "$QMSTR_HOME" ]; then
    echo "Please set QMSTR_HOME. See github.com/QMSTR/qmstr-demo."
    exit 1
fi

export PATH=$QMSTR_HOME/bin:$PATH

if [ -z "$QMSTR_DEBUG" ]; then
    run_qmstr_prod
else
    run_qmstr_dev
fi

git clone -b ${JSONC_BRANCH} https://github.com/json-c/json-c.git || (cd json-c; git fetch; git reset --hard origin/${JSONC_BRANCH})
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
