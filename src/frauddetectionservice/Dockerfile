FROM gradle:8-jdk21 AS builder

WORKDIR /usr/src/app/

COPY ./src/frauddetectionservice/ ./
COPY ./pb/ ./src/main/proto/
RUN gradle --init-script maven-central-mirror.init.gradle shadowJar

# -----------------------------------------------------------------------------

FROM gcr.io/distroless/java21-debian12

ARG version=2.10.0
WORKDIR /usr/src/app/

COPY --from=builder /usr/src/app/build/libs/frauddetectionservice-1.0-all.jar ./
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v$version/opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar
# RUN chmod 644 /app/opentelemetry-javaagent.jar
ENV JAVA_TOOL_OPTIONS=-javaagent:/app/opentelemetry-javaagent.jar
# the collector endpoints configured in docker-compose.yml are OTLP/gRPC (4317);
# the agent defaults to http/protobuf since 2.0
ENV OTEL_EXPORTER_OTLP_PROTOCOL=grpc

ENTRYPOINT [ "java", "-jar", "frauddetectionservice-1.0-all.jar" ]
