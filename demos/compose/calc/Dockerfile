################################################################################
# STAGE 1: Build QMSTR client binaries                                         #
################################################################################

FROM golang:1.12 AS goclientbuilder

ARG QMSTR_REPO="https://github.com/endocode/qmstr.git"
ARG QMSTR_BRANCH="feat/packaging"

RUN set -e \
  && apt update \
  && apt upgrade -y \
  && apt install -y git \
  && git clone ${QMSTR_REPO} --branch ${QMSTR_BRANCH} --single-branch qmstr \
  && cd ./qmstr \
  && go test ./clients/qmstr/ \
  && go build -o ./out/qmstr clients/qmstr/qmstr.go \
  && go test ./clients/qmstrctl/ \
  && go build -o ./out/qmstrctl clients/qmstrctl/qmstrctl.go \
  && go test ./modules/builders/qmstr-wrapper/ \
  && go build -o ./out/qmstr-wrapper \
     ./modules/builders/qmstr-wrapper/qmstr-wrapper.go

################################################################################
# STAGE 2: Build client container                                              #
################################################################################

FROM debian:buster AS client

RUN set -e \
  && apt update \
  && apt upgrade -y \
  && apt install -y make gcc perl libjson-c-dev socat netcat

COPY --from=goclientbuilder /go/qmstr/out/* /usr/local/bin/

RUN set -e \
  && addgroup calc \
  && adduser --system calc --ingroup calc

WORKDIR /home/calc/

COPY --chown=calc /entrypoint.sh .

VOLUME /home/calc/buildroot

ENTRYPOINT ["./entrypoint.sh"]
