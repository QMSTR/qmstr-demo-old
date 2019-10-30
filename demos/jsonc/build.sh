#!/bin/bash
set -e

setup_git_src https://github.com/json-c/json-c.git master jsonc

qmstrctl create package:jsonc --version $(cd jsonc && git describe --always)

qmstrctl spawn qmstr/jsoncdemo qmstr run -i /tmp/inst sh autogen.sh
qmstrctl spawn qmstr/jsoncdemo qmstr run -i /tmp/inst ./configure
qmstrctl spawn qmstr/jsoncdemo qmstr run -i /tmp/inst make -j4

qmstrctl connect package:jsonc file:$(find jsonc -name "libjson-c.so.?.*")
