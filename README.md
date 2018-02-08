# qmstr-demo
Demos testing qmstr

# Running the demos
In order to run the demos you must have at least one of the master container images built and ready.

Each directory contains a demo case that is started via the build.sh script from within the very directory.

## How to run the demo
- Export QMSTR_HOME to a directory that contains a bin directory containing symlinks to qmstr-wrapper.
- Also the qmstr-cli must be available on your PATH
- run build.sh from within the demo's directory