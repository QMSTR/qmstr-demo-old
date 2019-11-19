FROM ubuntu:19.04 as demobase

RUN apt-get update && apt-get install -y build-essential ccache apt-utils python-dev xz-utils zlib1g libxml2-dev libxslt1-dev bzip2

# install runtime deps
COPY --from=qmstr/master /usr/local/bin/qmstr /usr/local/bin/qmstr
COPY --from=qmstr/master /usr/local/bin/qmstr-wrapper /usr/local/bin/qmstr-wrapper
COPY --from=qmstr/master /usr/local/bin/qmstrctl /usr/local/bin/qmstrctl

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/lib/go-1.9/bin:$PATH

VOLUME /go/src