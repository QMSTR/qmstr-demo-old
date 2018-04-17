# QMSTR DEMO

In the following demo, you will run [Quartermaster](http://qmstr.org) and use it to compile cURL, in the end you will have the console log of master and client to inspect.

You can also inspect our [CI pipeline](https://ci.endocode.com/blue/organizations/jenkins/QMSTR%2Fqmstr-cURL-demo/activity) being initialized by cURL repo on github. 

## Requirements

Docker

## Running the demo

In order to run QMSTR cURL demo follow the steps:

        mkdir $HOME/demo
	cd $HOME/demo
	
	git clone git@github.com:qmstr/qmstr.git

	git clone git@github.com:qmstr/qmstr-demo.git

Create network for docker container to communicate with each other

	docker network create qmstrnet

### Build Docker images for Master 

	cd $HOME/demo/qmstr

	docker build -f ci/Dockerfile -t qmstr/master_build --target builder .
	docker build -f ci/Dockerfile -t qmstr/master --target master .
	docker build -f ci/Dockerfile -t runtime --target runtime . 

### Build Docker images for Demo

	cd $HOME/demo/qmstr-demo

	docker build -t qmstr/democurl --target democurl .

From the demo's repository folder run the following command

	cd $HOME/demo/
	docker run --name curldemo --privileged -v $(pwd)/qmstr-demo/demos:/demos -v /var/run/docker.sock:/var/run/docker.sock -e PWD_DEMOS=$(pwd)/qmstr-demo/demos/curl --net qmstrnet --rm qmstr/democurl
	
You will now see the client side running, in order to see the qmstr master log open a new terminal and run the following command:
    docker logs qmstr\master -f

### Cleanup
	docker rmi qmstr/master_build
	docker rmi qmstr/master
	docker rmi runtime
	docker rmi qmstr/democurl
	docker network rm qmstrnet

For more information you can see the [README](https://github.com/QMSTR/qmstr/blob/master/README.md) of the main repository
  
