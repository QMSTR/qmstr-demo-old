FROM qmstr/runtime as demobase

RUN apt-get update && apt-get install -y ccache

# install runtime deps
COPY --from=qmstr/master_build /usr/local/bin/qmstr /usr/local/bin/qmstr
COPY --from=qmstr/master_build /usr/local/bin/qmstr-wrapper /usr/local/bin/qmstr-wrapper
COPY --from=qmstr/master_build /usr/local/bin/qmstrctl /usr/local/bin/qmstrctl

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/lib/go-1.9/bin:$PATH

VOLUME /go/src

# java base projects deps
FROM openjdk as javabuilder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

ARG QMSTR_BRANCH=master
ARG QMSTR_FORK=QMSTR
RUN git clone -b ${QMSTR_BRANCH} --single-branch https://github.com/${QMSTR_FORK}/qmstr-gradle-plugin.git /tmp/qmstr-gradle-plugin

WORKDIR /tmp/qmstr-gradle-plugin
RUN ./gradlew test --stacktrace
RUN ./gradlew install --stacktrace

RUN cd .gradle/vcs-1/java-qmstr* && cd java-qmstr && ./gradlew install

RUN rm -fr /tmp/qmstr

FROM demobase as javademobase

RUN apt-get update && apt-get install -y openjdk-8-jdk openjfx

RUN mkdir -p /maven/conf
ENV M2_HOME /maven

ADD settings.xml /maven/conf/settings.xml

COPY --from=javabuilder /root/.m2/repository /maven/repo

RUN chmod -R 777 /maven/repo
