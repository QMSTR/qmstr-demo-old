#!/bin/bash
set -e

# Build Calculator project
qmstrctl create package:calc
pushd Calculator
make clean
popd

qmstrctl spawn qmstr/calcdemo qmstr run make -j4

# Connect targets to the package node
qmstrctl connect package:calc file:Calculator/libcalc.a file:Calculator/calcs file:Calculator/libcalc.so file:hash:$(sha1sum Calculator/calc | awk '{ print $1 }')
