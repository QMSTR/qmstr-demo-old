#!/bin/bash
set -e

PY_CMD="python3 setup.py qmstr"

setup_git_src https://github.com/python-pillow/Pillow.git 6.1.0 Pillow

pushd Pillow
git clean -fxd
popd

echo "[INFO] Start pillow build"
qmstrctl --verbose spawn qmstr/python-pillowdemo qmstr run ${PY_CMD}
