# java base projects deps
FROM openjdk:8 as javabuilder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git maven && \
    rm -rf /var/lib/apt/lists/*

ARG QMSTR_BRANCH=master
ARG QMSTR_FORK=https://github.com/QMSTR/qmstr.git
RUN git clone -b ${QMSTR_BRANCH} --single-branch ${QMSTR_FORK} /tmp/qmstr

WORKDIR /tmp/qmstr
RUN cd lib/java-qmstr && ./gradlew install
RUN cd modules/builders/qmstr-gradle-plugin && ./gradlew install
RUN cd modules/builders/qmstr-maven-plugin && mvn install

FROM demobase as javademobase

RUN apt-get update && apt-get install -y openjdk-8-jdk openjfx maven

RUN mkdir -p /maven/conf
ENV M2_HOME /maven

ADD settings.xml /usr/share/maven/conf/settings.xml

COPY --from=javabuilder /root/.m2/repository /maven/repo

RUN chmod -R 777 /maven/repo
RUN ls -lR /maven/repo
