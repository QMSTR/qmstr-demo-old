DEMOS := $(shell ls demos | grep -v java)
JAVA_DEMOS := $(patsubst java-%, %, $(shell ls demos | grep java))
IMAGE_PREFIX := qmstr
DEMO_IMAGES := $(foreach demo, $(DEMOS), $(demo)demo)
JAVADEMO_IMAGES := $(foreach demo, $(JAVA_DEMOS), java-$(demo)demo)

ifdef http_proxy
	DOCKER_PROXY = --build-arg http_proxy=$(http_proxy)
endif

all: $(DEMOS) $(JAVA_DEMOS)

.PHONY: demobase javademobase demoimage

demobase: container/Dockerfile
	@echo "Building demo image"
	cd container && docker build -t qmstr/demo --target demobase ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

javademobase: container/Dockerfile
	@echo "Building java demo image"
	cd container && docker build -t qmstr/javademobase --target javademobase ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

$(DEMO_IMAGES): demobase
	@echo "Building image $@"
	cd demos/$(@:%demo=%) && docker build -t $(IMAGE_PREFIX)/$@ ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

$(JAVADEMO_IMAGES): javademobase
	@echo "Building image $@"
	cd demos/$(@:%demo=%) && docker build -t $(IMAGE_PREFIX)/$@ ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

demos/%: %demo
	@echo "running $@ demo"
	$@/build.sh

$(DEMOS): %: demos/%

$(JAVA_DEMOS): %: demos/java-%
