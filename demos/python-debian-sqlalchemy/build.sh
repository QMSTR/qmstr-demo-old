#!/bin/bash
set -e

PY_CMD="python3 setup.py qmstr"

setup_git_src https://salsa.debian.org/python-team/modules/sqlalchemy.git debian/1.3.5+ds1-2 sqlalchemy

pushd sqlalchemy
git clean -fxd
popd

echo "[INFO] Create packages"
qmstrctl create package:python-sqlalchemy-ext_1.3.5+ds1-2_amd64.deb --version $(cd sqlalchemy && git describe --tags --dirty --long)
qmstrctl create package:python3-sqlalchemy-ext_1.3.5+ds1-2_amd64.deb --version $(cd sqlalchemy && git describe --tags --dirty --long)

echo "[INFO] Start sqlalchemy build"
qmstrctl --verbose spawn qmstr/python-debian-sqlalchemydemo qmstr run dpkg-buildpackage -B -us -uc

echo "[INFO] Connecting targets to packages"
./targets.sh
echo "[INFO] Done"
