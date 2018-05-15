DEMOS := $(shell ls demos) 
HOSTDEMODIR := $(shell pwd)/demos

all: $(DEMOS)

$(DEMOS): Dockerfile 
	echo "Building image for $@"
	docker build -t qmstr/demo$@ --target demo$@ .
	docker run --name demo$@ --privileged -v /var/run/docker.sock:/var/run/docker.sock -v ${GOPATH}/src:/go/src -v ${HOSTDEMODIR}:/demos -e HOSTDEMODIR=${HOSTDEMODIR}/$@ --net qmstrnet --rm qmstr/demo$@