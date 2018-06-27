DEMOS := $(shell ls demos)
HOSTDEMODIR := $(shell pwd)/demos

ifdef http_proxy
	DOCKER_PROXY = --build-arg http_proxy=$(http_proxy)
endif

all: $(DEMOS)

democontainer: container/Dockerfile
	@echo "Building demo image"
	cd container && docker build -t qmstr/demo --target demobase ${DOCKER_PROXY} .

javademocontainer: democontainer
	@echo "Building java demo image"
	cd container && docker build -t qmstr/javademobase --target javademobase ${DOCKER_PROXY} .

$(DEMOS): javademocontainer
	@echo "Building image for $@"
	cd demos/$@ && docker build -t qmstr/demo$@ ${DOCKER_PROXY} .
	@echo "running $@ demo"
	demos/$@/build.sh
