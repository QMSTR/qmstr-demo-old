#!/bin/bash
set -e

setup_git_src https://github.com/openssl/openssl.git master openssl

pushd openssl
git clean -fxd
popd

qmstrctl create package:openssl --version $(cd openssl && git describe --tags --dirty --long)

qmstrctl --verbose spawn qmstr/openssldemo qmstr run -i /tmp/inst ./config
qmstrctl --verbose spawn qmstr/openssldemo qmstr run -i /tmp/inst make

qmstrctl connect package:openssl file:openssl/apps/openssl
