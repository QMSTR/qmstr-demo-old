=================================
QMSTR Demos (with docker-compose)
=================================

To get started with QMSTR, this repo contains several small projects to be built with QMSTR instrumentation.
Each demo uses the same ``docker-compose.yaml`` file, referencing one of the demo directories via the environment variable ``DEMO_NAME``.

When the demo is started, it will spin up a docker-compose stack with the following services:

- ``dgraph``: The graph database that servers as ephemeral storage for build and analysis data of the current project.
- ``master``: The QMSTR master container. If it is not found by the docker daemon running on the local machine, it will be fetched from qmstr-docker_ and built locally. The master container is responsible for scheduling QMSTR phases, modules and manages mutations and queries to the database.
- ``client``: The client container contains all dependencies required to build the demo software as well as QMSTR client binaries to interact with the master server. Running the client as an individual container is not strictly required as long as the master container exposes the gRPC port 50051. It does however provide a convenient mechanism for isolating and packaging project code. The image used for a client is built from the Dockerfile inside the demo directory.

Prerequisites
=============

- docker_
- docker-compose_

Usage
=====

Something

.. _qmstr-docker: https://github.com/QMSTR/qmstr-docker
.. _docker: https://docs.docker.com/install/
.. _docker-compose: https://docs.docker.com/compose/install/

