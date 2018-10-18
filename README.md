# QMSTR DEMO

Quartermaster demo repository contains example projects which are compiled with [Quartermaster](https://github.com/QMSTR/qmstr). Those [projects](https://github.com/QMSTR/qmstr-demo/tree/master/demos) are:

* [cUrl](https://github.com/curl/curl.git)
* [JabRef](https://github.com/JabRef/jabref.git)
* [json-c](https://github.com/json-c/json-c.git)
* [OpenSSL](https://github.com/openssl/openssl.git)
* [Calculator](https://github.com/QMSTR/qmstr-demo/tree/master/demos/calc) (sample project for testing purposes)

You can run [Quartermaster](https://github.com/QMSTR/qmstr) and compile one or all of these projects. In the end of this process, you will have one or more reports with all the information that have been gathered during the build and analysis phase. For more information please read the documentaion in [Quartermaster](https://github.com/QMSTR/qmstr)

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
