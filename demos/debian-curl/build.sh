#!/bin/bash
set -e

setup_git_src https://salsa.debian.org/debian/curl.git debian/7.64.0-3 curl

echo "[INFO] Create packages"
PACKAGEVERSION="$(cd curl && git describe --tags --dirty --long)"
qmstrctl create package:curl_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}
qmstrctl create package:libcurl4_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}
qmstrctl create package:libcurl3-gnutls_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}
qmstrctl create package:libcurl3-nss_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}
qmstrctl create package:libcurl4-openssl-dev_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}
qmstrctl create package:libcurl4-gnutls-dev_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}
qmstrctl create package:libcurl4-nss-dev_7.64.0-3_amd64.deb --version ${PACKAGEVERSION}

echo "[INFO] Start debian curl build"
qmstrctl --verbose spawn qmstr/debian-curldemo qmstr run dpkg-buildpackage -B -us -uc
qmstrctl snapshot -O priortargets-snapshot.tar -f

echo "[INFO] Connecting targets to packages"
./targets.sh
echo "[INFO] Done"
