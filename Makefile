DEMOS := $(shell ls demos | grep -v java | grep -v py)
JAVA_DEMOS := $(patsubst java-%, %, $(shell ls demos | grep java))
PYTHON_DEMOS := $(patsubst python-%, %, $(shell ls demos | grep python))
IMAGE_PREFIX := qmstr
DEMO_IMAGES := $(foreach demo, $(DEMOS), $(demo)demo)
JAVADEMO_IMAGES := $(foreach demo, $(JAVA_DEMOS), java-$(demo)demo)
PYTHONDEMO_IMAGES := $(foreach demo, $(PYTHON_DEMOS), python-$(demo)demo)

ifdef http_proxy
	DOCKER_PROXY = --build-arg http_proxy=$(http_proxy)
endif

all: $(DEMOS) $(JAVA_DEMOS) $(PYTHON_DEMOS)

.PHONY: demobase javademobase demoimage pythondemobase

demobase: container/Dockerfile
	@echo "Building demo image"
	cd container && docker build -t qmstr/demo --target demobase ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

container/Full%.Dockerfile: container/Dockerfile container/%.Dockerfile
	cat $^ > $@

javademobase: container/FullJava.Dockerfile
	@echo "Building java demo image"
	docker build -f $^ -t qmstr/javademobase --target javademobase ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) container

pythondemobase: container/FullPython.Dockerfile
	@echo "Building python demo image"
	docker build -f $^ -t qmstr/pythondemobase --target pythondemobase ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) container

$(DEMO_IMAGES): demobase
	@echo "Building image $@"
	cd demos/$(@:%demo=%) && docker build -t $(IMAGE_PREFIX)/$@ ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

$(JAVADEMO_IMAGES): javademobase
	@echo "Building image $@"
	cd demos/$(@:%demo=%) && docker build -t $(IMAGE_PREFIX)/$@ ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

$(PYTHONDEMO_IMAGES): pythondemobase
	@echo "Building image $@"
	cd demos/$(@:%demo=%) && docker build -t $(IMAGE_PREFIX)/$@ ${DOCKER_PROXY} $(EXTRA_BUILD_OPTS) .

demos/%: %demo
	@echo "running $(^:%demo=%) demo"
	cat demos/startmaster.sh $@/build.sh demos/analyze-report-quit.sh > $@/fullbuild.sh
	sed -i -e 's#Running#Running $(^:%demo=%)#' $@/fullbuild.sh
	cat $@/fullbuild.sh
	chmod +x $@/fullbuild.sh
	$@/fullbuild.sh
	rm -rf $@/fullbuild.sh

$(DEMOS): %: demos/%

$(JAVA_DEMOS): %: demos/java-%

$(PYTHON_DEMOS): %: demos/python-%
