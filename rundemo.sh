#!/bin/bash
set -e

DEMO=${1:-curl}
HOSTDEMODIR=$(pwd)/demos

docker run --name demo --privileged -v /var/run/docker.sock:/var/run/docker.sock -v $GOPATH/src:/go/src -v $HOSTDEMODIR:/demos -e HOSTDEMODIR=$HOSTDEMODIR/$DEMO --net qmstrnet --rm qmstr/demo$DEMO
