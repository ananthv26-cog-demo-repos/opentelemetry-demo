FROM confluentinc/cp-kafka:8.3.1-1-ubi9

USER root
ARG version=2.31.1
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v$version/opentelemetry-javaagent.jar /tmp/opentelemetry-javaagent.jar
RUN chmod go+r /tmp/opentelemetry-javaagent.jar

# the ubi9 base ships neither netcat nor a package manager; the healthcheck needs `nc`
COPY --from=busybox:1.38.0-musl@sha256:32b5cdad7cce41dfd53d0ae06baebcf8357a147ee7694dc706911c373bc30c37 /bin/busybox /usr/local/bin/nc

USER appuser
WORKDIR /tmp
COPY ./src/kafka/clusterID clusterID

ENV KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://kafka:9093
ENV KAFKA_CONTROLLER_QUORUM_VOTERS='1@kafka:9093'
ENV KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER
ENV KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT
ENV KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0
ENV KAFKA_PROCESS_ROLES=controller,broker
ENV KAFKA_NODE_ID=1
ENV KAFKA_METADATA_LOG_SEGMENT_MS=15000
ENV KAFKA_METADATA_MAX_RETENTION_MS=1200000
ENV KAFKA_METADATA_LOG_MAX_RECORD_BYTES_BETWEEN_SNAPSHOTS=2800
ENV KAFKA_AUTO_CREATE_TOPICS_ENABLE=true
ENV KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1
ENV KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1
# agent 2.x defaults to http/protobuf; the collector endpoints passed by compose are gRPC (4317).
# logs export is on by default in 2.x but compose passes no logs endpoint, so keep it off as in 1.x.
ENV OTEL_EXPORTER_OTLP_PROTOCOL=grpc
ENV OTEL_LOGS_EXPORTER=none
ENV KAFKA_HEAP_OPTS="-Xms256m -Xmx512m"
ENV KAFKA_OPTS="-javaagent:/tmp/opentelemetry-javaagent.jar -Dotel.jmx.target.system=kafka-broker"

ENTRYPOINT ["/bin/sh", "-c", "export CLUSTER_ID=$(cat /tmp/clusterID) && /etc/confluent/docker/run"]
