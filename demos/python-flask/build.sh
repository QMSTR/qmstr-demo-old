#!/bin/bash
set -e

PY_CMD="python3 setup.py qmstr"

setup_git_src https://github.com/pallets/flask.git master flask

pushd flask
git clean -fxd
popd

echo "[INFO] Start flask build"
qmstrctl --verbose spawn qmstr/python-flaskdemo qmstr run ${PY_CMD}
