#!/bin/bash
set -e

echo "############################"
echo "# Running debian cURL demo #"
echo "############################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

source ${DEMOWD}/../../build.inc
pushd ${DEMOWD}

setup_git_src https://salsa.debian.org/debian/curl.git master curl

pushd curl
git clean -fxd
mkdir build
popd
