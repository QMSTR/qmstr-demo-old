#!/bin/bash
set -e

setup_git_src https://github.com/JabRef/jabref.git v4.3 jabref

pushd jabref
git clean -fxd
echo "Applying qmstr plugin to gradle build configuration"
git am < ${DEMOWD}/add-qmstr.patch
popd

echo "[INFO] Start gradle build"
qmstrctl spawn qmstr/java-jabrefdemo ./gradlew qmstr
