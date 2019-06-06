# deciphernow/kakfa

This repository contains the resources for building the deciphernow/kafka image. This image is geared towards both local development and deployment in containerized infrastructure such as Kubernetes.  Further, it follows RedHat best practices making it suitable for deployment within OpenShift without any elevated priviledges.

## Usage

This image is configured to run in a single instance deployment out of the box connecting to a ZooKeeper instance listening on `localhost:2181`.  You may further tailor the runtime with the following environment variables:

| Variable           | Example                       | Default             | Description                                                                                          |
|--------------------|-------------------------------|---------------------|------------------------------------------------------------------------------------------------------|
| ADVERTISED_ADDRESS | kafak01                       | localhost           | The address advertised within ZooKeeper (must be resolvable from clients and other Kafka instances). |
| ADVERTISED_PORT    | 9092                          | 9092                | The port advertised within ZooKeeper (must be reachable from clients and other Kafka instances).     |
| LISTENER_ADDRESS   | 0.0.0.0                       | 0.0.0.0             | The interface to which the server binds or 0.0.0.0 for all interfaces.                               |
| LISTENER_PORT      | 9092                          | 9092                | The port to which the servier binds.                                                                 |
| ZOOKEEPER_ENSEMBLE | zk01:2181,zk02:2181,zk03:2181 | localhost:2181      | The number of ticks before a server leaves the quorum.                                               |         

Note, that making the Kafka instance reachable by containers on the Docker network and clients on the host can be problematic.  To accomplish this we recommend a configuration similar to that shown in the compose file below coupled by an number of methods to ensure `zookeeper.local` and `kafka.local` resolve to localhost.

```yaml
version: '3'

services:
  zookeeper.local:
    image: deciphernow/zookeeper:latest
    ports:
      - "2181:2181"
  kafka.local:
    image: deciphernow/kafka:2.12-2.1.1
    ports:
      - "9092:9092"
    environment:
      ADVERTISED_ADDRESS: kafka.local
      ZOOKEEPER_ENSEMBLE: zookeeper.local:2181
    command:
      - "sleep"
      - "10"
      - "&&"
      - "/opt/apache/kafka/bin/kafka-server-start.sh"
      - "/opt/apache/kafka/config/server.properties"
```

For options on ensuring these resolve consider `/etc/host` entries for `kafka.local` and `zookeeper.local`, running dnsmasq locally and pushing all `.local` resolutions to `localhost`.  In most languages there are also ways to hijack the resolution system such as [moby-dns](https://github.com/DecipherNow/moby/tree/master/moby-dns) for the JVM.

## Development

This repository is pretty simple and everything you want to know can be seen in the [Makefile](./Makefile).

### Prerequisites

In order to develop and test with this repository you will need the following installed:

    - docker
    - git
    - make

### Building

To build the image run the following command:

```sh
make build
```

To publish the image run the following command:

```sh
make publish
```

### Versioning

The version of this image tracks directly with the version of Kafka built.  In order to update the version of Kafka modify the [VERSION](./VERSION) file with the version needed. 

## Contributing

In general, we follow the "fork-and-pull" Git workflow.

1. Clone the project to your own machine.)
1. Commit changes to your own branch.
1. Push your work back up to your fork.
1. Submit a pull request so that we can review your changes.

NOTE: Be sure to fetch and rebase on the upstream master before making a pull request.

