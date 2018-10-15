FROM qmstr/demo
# install runtime deps
RUN apt-get update && apt-get install -y cmake libtool pkgconf libssl-dev

VOLUME /buildroot

WORKDIR /buildroot/curl/build
