# QMSTR DEMO

Quartermaster demo repository contains some example projects instrumented to compile with [Quartermaster](https://github.com/QMSTR/qmstr).
Each demo shows how to instrument a certain project to compile with Quartermaster.

After running a demo you will have reports with all the information that have been gathered during the build and analysis phase. For more information please read the documentaion in [Quartermaster](https://github.com/QMSTR/qmstr)

You can also inspect our [CI pipeline](https://ci.endocode.com/blue/organizations/jenkins/QMSTR%2Fqmstr-cURL-demo/activity) being initialized by cURL repo on github.

## Requirements

* Docker
* [Quartermaster Installation](https://github.com/QMSTR/qmstr)

## Running the demos

Running the demos is Makefile based.
Running just `make` it will compile all the projects located in the `demos/` directory with Quartermaster:

	> make
	...

Should you want to compile a specific project run `make` followed by the name of the project you want to compile e.g.:

	> make curl
	...

For more information and updates you can visit the [Quartermaster project](http://qmstr.org).
