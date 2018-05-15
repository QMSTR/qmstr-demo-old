DEMOS := $(shell ls demos) 

all: $(DEMOS)

$(DEMOS): Dockerfile 
	echo "Building image for $@"
	docker build -t qmstr/demo$@ --target demo$@ .