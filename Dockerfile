FROM runtime as demobase

# install runtime deps 
RUN apt-get update && \
    apt-get install -y docker.io wget cmake libtool && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /go/bin
COPY --from=qmstr/master_build /go/bin/qmstr /go/bin/qmstr
COPY --from=qmstr/master_build /go/bin/qmstr-wrapper /go/bin/qmstr-wrapper
COPY --from=qmstr/master_build /go/bin/qmstr-cli /go/bin/qmstr-cli

COPY --from=qmstr/master_build /go/bin/spdx-analyzer /go/bin/spdx-analyzer
COPY --from=qmstr/master_build /go/bin/scancode-analyzer /go/bin/scancode-analyzer
COPY --from=qmstr/master_build /go/bin/qmstr-reporter-html /go/bin/qmstr-reporter-html

#RUN CALC DEMO
FROM demobase as democalc

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/lib/go-1.9/bin:$PATH

VOLUME /go/src

ENV QMSTR_ADDRESS "qmstr-demo-master:50051"

ADD build.inc ./build.inc
ADD ./qmstr-master /qmstr-master
#RUN chmod +x /demos/calc/entrypoint.sh
ENTRYPOINT [ "/demos/calc/entrypoint.sh" ]
