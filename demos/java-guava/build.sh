#!/bin/bash
set -e

setup_git_src https://github.com/google/guava.git v27.1 guava

pushd guava
git clean -fxd
echo "Applying qmstr plugin to pom"
git am < ${DEMOWD}/0001-Apply-qmstr-plugin.patch
popd

echo THIS IS DA ENV
qmstrctl spawn qmstr/java-guavademo mvn -v
echo "++++++++++"

echo "[INFO] Start gradle build"
qmstrctl spawn qmstr/java-guavademo mvn -pl .,guava clean package
