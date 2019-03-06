# Copyright 2019 Decipher Technology Studios
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM java:8-jre-alpine

LABEL maintainer="Chris Smith <chris.smith@deciphernow.com>"

ARG kafka_directory
ARG kafka_version
ARG scala_version

ENV KAFKA_HOST "localhost"
ENV KAFKA_PORT "9092"
ENV ZOOKEEPER_CONENCTION "localhost:2181"

RUN apk add --no-cache \
    bash libc6-compat

COPY ${kafka_directory} /opt/apache/kafka
COPY ./etc /etc
COPY ./usr /usr

RUN chgrp -R 0 /opt/apache/kafka \
    && chgrp -R 0 /etc \
    && chgrp -R 0 usr \
    && chgrp -R 0 /var \
    && chmod -R g=u /opt/apache/kafka \
    && chmod -R g=u /usr \
    && chmod -R g=u /etc \
    && chmod -R g=u /var

USER 1000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/opt/apache/kafka/bin/kafka-server-start.sh", "/etc/kafka/server.properties"]
