# java base projects deps
FROM demobase as javademobase

RUN apt-get update && apt-get install -y openjdk-8-jdk openjfx maven

RUN mkdir -p /maven/conf
ENV M2_HOME /maven

ADD settings.xml /usr/share/maven/conf/settings.xml

COPY --from=qmstr/master_build /root/.m2/repository /maven/repo

RUN chmod -R 777 /maven/repo
RUN ls -lR /maven/repo
