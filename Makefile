DEMOS := $(shell ls demos)
HOSTDEMODIR := $(shell pwd)/demos

all: $(DEMOS)

democontainer: container/Dockerfile
	@echo "Building demo image"
	cd container && docker build -t qmstr/demo --target demobase .

javademocontainer: democontainer
	@echo "Building java demo image"
	cd container && docker build -t qmstr/javademobase --target javademobase .

$(DEMOS): javademocontainer
	@echo "Building image for $@"
	cd demos/$@ && docker build -t qmstr/demo$@ .
	@echo "running $@ demo"
	demos/$@/build.sh
