#!/bin/bash
set -e

DEMO=${1:-curl}
HOSTDEMODIR=$(pwd)/demos
echo "docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock -v $GOPATH/src:/go/src -v $HOSTDEMODIR:/demos -e MASTER_CONTAINER_NAME=${MASTER_CONTAINER_NAME} -e HOSTDEMODIR=$HOSTDEMODIR/$DEMO --net qmstrnet --rm qmstr/demo$DEMO"
docker run --privileged -v /var/run/docker.sock:/var/run/docker.sock -v $GOPATH/src:/go/src -v $HOSTDEMODIR:/demos -e MASTER_CONTAINER_NAME=${MASTER_CONTAINER_NAME} -e HOSTDEMODIR=$HOSTDEMODIR/$DEMO --net qmstrnet --rm qmstr/demo$DEMO
