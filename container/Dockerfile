FROM ubuntu:19.10 as demobase 

RUN apt-get update && apt-get install -y build-essential ccache apt-utils python3.7-dev bzip2 xz-utils zlib1g libxml2-dev libxslt1-dev

RUN python3 --version

# install runtime deps
COPY --from=qmstr/master /usr/local/bin/qmstr /usr/local/bin/qmstr
COPY --from=qmstr/master /usr/local/bin/qmstr-wrapper /usr/local/bin/qmstr-wrapper
COPY --from=qmstr/master /usr/local/bin/qmstrctl /usr/local/bin/qmstrctl

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/lib/go-1.9/bin:$PATH

VOLUME /go/src