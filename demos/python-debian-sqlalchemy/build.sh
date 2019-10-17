#!/bin/bash
set -e

echo "############################"
echo "# Running Sql Alchemy demo #"
echo "############################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

PY_CMD="python3 setup.py qmstr"

source ${DEMOWD}/../../build.inc

pushd ${DEMOWD}
setup_git_src https://salsa.debian.org/python-team/modules/sqlalchemy.git debian/1.3.5+ds1-2 sqlalchemy

pushd sqlalchemy
git clean -fxd
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)
echo "master server up and running"

echo "[INFO] Create packages"
qmstrctl create package:python-sqlalchemy-ext_1.3.5+ds1-2_amd64.deb --version $(cd sqlalchemy && git describe --tags --dirty --long)
qmstrctl create package:python3-sqlalchemy-ext_1.3.5+ds1-2_amd64.deb --version $(cd sqlalchemy && git describe --tags --dirty --long)

echo "[INFO] Start sqlalchemy build"
qmstrctl --verbose spawn qmstr/python-debian-sqlalchemydemo qmstr run dpkg-buildpackage -B -us -uc

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."

