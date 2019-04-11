# Kafka

This directory provides the scripts and configuration files for building Docker containers that run Apache ZooKeeper
and Apache Kafka in the same container.  While in theory, you should have one process per container, in practice it's
often less messy to run two dependent processes in the same container.

## Building

In order to build an image simply run the following command from this directory:

```bash
./build.sh
```

This script will build a new Docker image with sensible defaults, but you may override them with the following
environment variables:

| Variable          | Default                                 | Description                                    |
|-------------------|-----------------------------------------|------------------------------------------------|
| KAFKA_MIRROR      | http://www-us.apache.org/dist/kafka     | The mirror from which Kafka is downloaded.     |
| KAFKA_VERSION     | 2.1.0                                   | The version of Kafka.                          |
| SCALA_VERSION     | 2.11                                    | The version of Scala used by Kafka.            |


Be sure to confirm that your ZooKeeper version is compatible with your Kafka version.

## Publishing

To build and publish the built image simply run the following command from this directory:

```bash
./publish.sh
```

This script accepts the same environment variables as the as the build script.

## Running

To run an image build using this repository run the following command:

```bash
docker run deciphernow/kafka:2.11-2.1.0
```

This will start Kafka on `localhost:9092` and ZooKeeper on `localhost:2181`.  Since this may not be desirable, you may
override any of these by setting the following environment variables in your run command:

| Variable              | Default       | Description                                                                                                                   |
|-----------------------|---------------|-------------------------------------------------------------------------------------------------------------------------------|
| KAFKA_HOST            | localhost     | The hostname which resolves to the Kafka container.                                                                           |
| KAFKA_PORT            | 9092          | The port on which Kafka listens.                                                                                              |
| ZOOKEEPER_CONNECTION  | localhost:2181| A comma separated host:port pairs string for zk                                                                               |
| HOSTNAME              | localhost-0   | (optional) If running more than one kafka node, pass in this variable in a hostname-index format to specify the broker id     |
