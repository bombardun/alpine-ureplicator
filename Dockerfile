FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add \
      bash \
      git \
      maven \
     openjdk8-jre \
     openjdk8 && \ 
    rm -rf /var/cache/apk/* && \
    update-ca-certificates

ENV UREPL_PATH=https://github.com/uber/uReplicator.git \
    JAVA_HOME=/usr/lib/jvm/default-jvm

ARG MAVEN_OPTS="-Xmx1024M -Xss128M -XX:MetaspaceSize=512M -XX:MaxMetaspaceSize=1024M -XX:+CMSClassUnloadingEnabled"

RUN mkdir -p /usr/src/app &&\
    cd /tmp && \
    git clone ${UREPL_PATH} &&\
    cp -r /tmp/uReplicator/* /usr/src/app/ && \
    rm -rf /tmp/uReplicator

WORKDIR /usr/src/app

RUN mvn clean package -DskipTests

RUN chmod +x /usr/src/app/bin/pkg/*.sh

ENTRYPOINT [ "./docker-entrypoint.sh" ]
CMD [ "controller" ]