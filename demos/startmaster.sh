#!/bin/bash
set -e

echo "###########################"
echo "#  Running demo"
echo "###########################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc

pushd ${DEMOWD}

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait)
echo "master server up and running"
