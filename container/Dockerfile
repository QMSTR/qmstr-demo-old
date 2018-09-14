FROM qmstr/runtime as demobase

RUN apt-get update
RUN apt-get install -y ccache

# install runtime deps
COPY --from=qmstr/master_build /usr/local/bin/qmstr /usr/local/bin/qmstr
COPY --from=qmstr/master_build /usr/local/bin/qmstr-wrapper /usr/local/bin/qmstr-wrapper
COPY --from=qmstr/master_build /usr/local/bin/qmstrctl /usr/local/bin/qmstrctl

ENV GOPATH /go
ENV PATH ${GOPATH}/bin:/usr/lib/go-1.9/bin:$PATH

VOLUME /go/src

# java base projects deps
FROM openjdk as javabuilder

RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

ARG QMSTR_BRANCH=master
ARG QMSTR_FORK=QMSTR
RUN git clone -b ${QMSTR_BRANCH} --single-branch https://github.com/${QMSTR_FORK}/qmstr.git /tmp/qmstr

RUN mkdir -p .gradle/$(grep zipStorePath /tmp/qmstr/java/gradle/gradle/wrapper/gradle-wrapper.properties | cut -d "=" -f2)
RUN cd .gradle/$(grep zipStorePath /tmp/qmstr/java/gradle/gradle/wrapper/gradle-wrapper.properties | cut -d "=" -f2) && wget $(grep distributionUrl /tmp/qmstr/java/gradle/gradle/wrapper/gradle-wrapper.properties | cut -d "=" -f2 |sed -e 's#\\##')

RUN cd /tmp/qmstr/java/gradle && ./gradlew test && ./gradlew install

RUN rm -fr /tmp/qmstr

FROM demobase as javademobase

RUN apt-get update
RUN apt-get install -y openjdk-8-jdk openjfx

RUN mkdir -p /maven/conf
ENV M2_HOME /maven

ADD settings.xml /maven/conf/settings.xml

COPY --from=javabuilder /root/.m2/repository /maven/repo

RUN chmod -R 777 /maven/repo
