FROM qmstr/demo

RUN apt-get update && apt-get install -y dpkg-dev debhelper python-all-dev \
    python3-all-dev python-setuptools python3 python3-dev python3-pip

COPY --from=qmstr/master_build /qmstr/out/wheels /tmp/wheels
RUN pip3 install -f /tmp/wheels --only-binary=:all: /tmp/wheels/pyqmstr*.whl
RUN pip3 install -f /tmp/wheels --only-binary=:all: /tmp/wheels/qmstr_py_builder*.whl

VOLUME /buildroot

WORKDIR /buildroot/sqlalchemy
