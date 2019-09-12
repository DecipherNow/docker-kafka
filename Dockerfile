#   Copyright 2019 Decipher Technology Studios
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

FROM alpine:3.10

LABEL maintainer=engineering@deciphernow.com

ARG VERSION

ENV ADVERTISED_ADDRESS localhost
ENV ADVERTISED_PORT 9092
ENV LISTENER_ADDRESS 0.0.0.0
ENV LISTENER_PORT 9092
ENV ZOOKEEPER_ENSEMBLE localhost:2181

RUN apk add --no-cache \
  bash \
  curl \
  java-snappy \
  openjdk8 \
  ruby

# required to support snappy compression requirements for glibc
RUN curl -sSL https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub > /etc/apk/keys/sgerrand.rsa.pub
RUN curl -sSL https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk > /tmp/glibc-2.30-r0.apk
RUN apk add --no-cache tmp/glibc-2.30-r0.apk

WORKDIR /opt/apache/kafka

RUN curl -L http://www-us.apache.org/dist/kafka/${VERSION}/kafka_2.12-${VERSION}.tgz | tar -xz --strip-components=1

COPY /files /

RUN mkdir -p /var/lib/kafka
RUN chown -R 0:0 /opt/apache/kafka /var/lib/kafka
RUN chmod -R g=u /opt/apache/kafka /var/lib/kafka

EXPOSE 9092/tcp
USER 1000
VOLUME /var/lib/kafka

ENTRYPOINT ["/usr/local/bin/entrypoint"]

CMD ["/opt/apache/kafka/bin/kafka-server-start.sh", "/opt/apache/kafka/config/server.properties"]
