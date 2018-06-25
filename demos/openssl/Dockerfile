FROM qmstr/demo
# install runtime deps
RUN apt-get update
RUN apt-get install -y libtool pkgconf perl libssl-dev

VOLUME /buildroot

WORKDIR /buildroot/openssl
