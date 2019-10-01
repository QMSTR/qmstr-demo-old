# python base project deps
FROM demobase as pythondemobase

RUN apt-get install -y git python3 \
    python3-dev python3-pip

COPY --from=qmstr/master_build /qmstr/out/wheels /tmp/wheels
RUN pip3 install -f /tmp/wheels --only-binary=:all: /tmp/wheels/pyqmstr*.whl
RUN pip3 install -f /tmp/wheels --only-binary=:all: /tmp/wheels/qmstr_py_builder*.whl

