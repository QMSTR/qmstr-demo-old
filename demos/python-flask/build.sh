#!/bin/bash
set -e

echo "######################"
echo "# Running Flask demo #"
echo "######################"

if [ "$(uname -s)" = 'Linux' ]; then
DEMOWD="$(dirname "$(readlink -f "$0")")"
else
DEMOWD="$(dirname "$(greadlink -f "$0")")"
fi

PY_CMD="python3 setup.py qmstr"

source ${DEMOWD}/../../build.inc

pushd ${DEMOWD}
setup_git_src https://github.com/pallets/flask.git master flask

pushd flask
git clean -fxd
popd

echo "Waiting for qmstr-master server"
eval $(qmstrctl start --wait --verbose)
echo "master server up and running"

echo "[INFO] Start flask build"
qmstrctl --verbose spawn qmstr/python-flaskdemo qmstr run ${PY_CMD}

echo "[INFO] Build finished. Creating snapshot and triggering analysis."
qmstrctl snapshot -O postbuild-snapshot.tar -f
qmstrctl analyze --verbose

echo "[INFO] Analysis finished. Creating snapshot and triggering reporting."
qmstrctl snapshot -O postanalysis-snapshot.tar -f
qmstrctl report --verbose

qmstrctl quit

echo "Build finished."

