FROM qmstr/runtime as demobase
# install runtime deps
RUN apt-get update
RUN apt-get install -y docker.io wget

COPY --from=qmstr/master_build /usr/local/bin/qmstr /usr/local/bin/qmstr
COPY --from=qmstr/master_build /usr/local/bin/qmstr-wrapper /usr/local/bin/qmstr-wrapper
COPY --from=qmstr/master_build /usr/local/bin/qmstrctl /usr/local/bin/qmstrctl

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/lib/go-1.9/bin:$PATH

VOLUME /go/src

ENV QMSTR_ADDRESS "qmstr-demo-master:50051"


ADD build.inc ./build.inc

# java base projects deps
FROM openjdk as javabuilder

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/QMSTR/qmstr-gradle-plugin.git

RUN mkdir -p .gradle/$(grep zipStorePath /qmstr-gradle-plugin/gradle/wrapper/gradle-wrapper.properties | cut -d "=" -f2)
RUN cd .gradle/$(grep zipStorePath /qmstr-gradle-plugin/gradle/wrapper/gradle-wrapper.properties | cut -d "=" -f2) && wget $(grep distributionUrl /qmstr-gradle-plugin/gradle/wrapper/gradle-wrapper.properties | cut -d "=" -f2 |sed -e 's#\\##')

RUN cd qmstr-gradle-plugin && ./gradlew install

# calc demo case
FROM demobase as democalc
# install runtime deps
RUN apt-get update
RUN apt-get install -y libtool pkgconf

ENTRYPOINT [ "/demos/calc/entrypoint.sh" ]

# curl demo case
FROM demobase as democurl
# install runtime deps
RUN apt-get update
RUN apt-get install -y cmake libtool pkgconf libssl-dev

ENTRYPOINT [ "/demos/curl/entrypoint.sh" ]

# jabref [Gradle] demo case
FROM demobase as demojabref
# install runtime deps
RUN apt-get update
RUN apt-get install -y openjdk-8-jdk openjfx

COPY --from=javabuilder /root/.m2 /root/.m2

ENTRYPOINT [ "/demos/jabref/entrypoint.sh" ]

#openssl demo case
FROM demobase as demoopenssl
# install runtime deps
RUN apt-get update
RUN apt-get install -y libtool pkgconf perl libssl-dev

ENTRYPOINT [ "/demos/openssl/entrypoint.sh" ]
