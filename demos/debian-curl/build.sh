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

setup_git_src https://salsa.debian.org/debian/curl.git debian/7.64.0-3 curl

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)
echo "master server up and running"

echo "[INFO] Create packages"
qmstrctl create package:curl_7.64.0-3_amd64.deb --version $(cd curl && git describe --tags --dirty --long)
qmstrctl create package:libcurl4_7.64.0-3_amd64.deb
qmstrctl create package:libcurl3-gnutls_7.64.0-3_amd64.deb
qmstrctl create package:libcurl3-nss_7.64.0-3_amd64.deb
qmstrctl create package:libcurl4-openssl-dev_7.64.0-3_amd64.deb
qmstrctl create package:libcurl4-gnutls-dev_7.64.0-3_amd64.deb
qmstrctl create package:libcurl4-nss-dev_7.64.0-3_amd64.deb

echo "[INFO] Start debian curl build"
qmstrctl --verbose spawn qmstr/debian-curldemo qmstr run dpkg-buildpackage -B -us -uc

echo "[INFO] Connect targets to packages"
./targets.sh

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."
