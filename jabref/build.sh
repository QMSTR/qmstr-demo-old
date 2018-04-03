#!/bin/bash
set -e

source ../build.inc
init
sed "s#SOURCEDIR#$(pwd)#" qmstr.tmpl > qmstr.yaml
run_qmstr_master

setup_git_src https://github.com/JabRef/jabref.git master jabref

pushd jabref
git clean -fxd
echo "Applying qmstr plugin to gradle build configuration"
git am --signoff < ../add-qmstr.patch

echo "Waiting for qmstr-master server"
qmstr-cli wait

echo "Start gradle build"
./gradlew qmstr

echo "Build finished. Triggering analysis."
qmstr-cli analyze
echo "Analysis finished. Triggering reporting."
qmstr-cli report

echo "Build finished. Don't forget to quit the qmstr-master server."
