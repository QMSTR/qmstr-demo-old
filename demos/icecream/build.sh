#!/bin/bash
set -e

setup_git_src https://github.com/icecc/icecream.git master icecream

pushd icecream
git clean -fxd
popd

qmstrctl create package:icecream --version $(cd icecream && git describe --tags --dirty --long)

echo "[INFO] Start icecream build"
qmstrctl --verbose spawn qmstr/icecreamdemo qmstr run -i /tmp/inst ./autogen.sh
qmstrctl --verbose spawn qmstr/icecreamdemo qmstr run -i /tmp/inst ./configure --prefix=/opt/icecream
qmstrctl --verbose spawn qmstr/icecreamdemo qmstr run -i /tmp/inst make

qmstrctl connect package:icecream file:icecream/client/icecc file:icecream/daemon/iceccd
