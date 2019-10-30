#!/bin/bash
set -e

setup_git_src https://github.com/curl/curl.git master curl

pushd curl
git clean -fxd
mkdir build
popd

qmstrctl create package:curl --version $(cd curl && git describe --tags --dirty --long)

echo "[INFO] Start curl build"
qmstrctl --verbose spawn qmstr/curldemo qmstr run -i /tmp/inst cmake ..
qmstrctl --verbose spawn qmstr/curldemo qmstr run -i /tmp/inst make

qmstrctl connect package:curl file:curl/build/src/curl file:curl/build/lib/libcurl.so
