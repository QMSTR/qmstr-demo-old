=================================
QMSTR Demos (with docker-compose)
=================================

To get started with QMSTR, this repo contains several small projects to be built with QMSTR instrumentation.
Each demo uses the same ``docker-compose.yaml`` file, referencing one of the demo directories via the environment variable ``DEMO_NAME``.

When the demo is started, it will spin up a docker-compose stack with the following services:

- ``dgraph``: The graph database that serves as ephemeral storage for build and analysis data of the current project.
- ``master``: The QMSTR master container. If it is not found by the docker daemon running on the local machine, it will be fetched from qmstr-docker_ and built locally. The master container is responsible for scheduling QMSTR phases, modules and manages mutations and queries to the database.
- ``client``: The client container contains all dependencies required to build the demo software as well as QMSTR client binaries to interact with the master server. Running the client as an individual container is not strictly required as long as the master container exposes the gRPC port 50051. It does however provide a convenient mechanism for isolating and packaging project code. The image used for a client is built from the Dockerfile inside the demo directory.

Prerequisites
=============

- docker_
- docker-compose_

Usage
=====

Run the Calc Demo with Docker-compose
-------------------------------------

.. code-block:: bash

    git clone THIS_REPO
    cd qmstr-demo/demos/compose
    export DEMO_NAME=calc
    export COMPOSE_PROJECT_NAME=$DEMO_NAME
    docker-compose up -d [--force-recreate] [--build]

The ``--force-recreate`` option is recommended if the demo is rerun to avoid orphaned state in the dgraph database. ``--build`` rebuilds any images used in the demo, regardless of whether the images are found by the docker daemon or not.

Check the Results
-----------------

If run with the command above, the demo produces little to no output. There are several ways to check what happened behind the scenes and whether the demo terminated successfully:

1. **Open the dgraph-ratel web UI:** On port 8000, the dgraph database serves a web UI for querying and/or mutating its graph(s). You can find a detailed description here_.
2. **Use qmstrctl to view nodes:** You can use the QMSTR client binary ``qmstrctl`` to view or manipulate QMSTR nodes. If the master cannot be reached, append ``--cserv localhost:50051`` to your commands.
3. **Check the docker logs:** Use ``docker logs calc_master_1`` to view the master logs or ``docker logs calc_client_1`` to view the client logs.

.. _here: https://docs.dgraph.io/tutorial-1/#mutations-using-ratel
.. _qmstr-docker: https://github.com/QMSTR/qmstr-docker
.. _docker: https://docs.docker.com/install/
.. _docker-compose: https://docs.docker.com/compose/install/

