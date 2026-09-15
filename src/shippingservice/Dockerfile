# build context will only work from ../../docker-compose.yml
FROM rust:1.98.1-alpine3.22 as builder
RUN apk update
RUN apk add --no-cache ca-certificates git protobuf-dev protoc cmake clang clang-dev make gcc g++ libc-dev linux-headers
WORKDIR /app/

# build app
COPY /src/shippingservice/ /app/
COPY /pb/ /app/proto/

RUN cargo build -r --features="dockerproto"
RUN rustc --version > /app/rustc-version.txt

FROM alpine:3.22 as release
RUN apk add --no-cache ca-certificates
RUN GRPC_HEALTH_PROBE_VERSION=v0.4.7 && \
    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
    chmod +x /bin/grpc_health_probe
WORKDIR /app
COPY --from=builder /app/target/release/shippingservice /app/shippingservice
COPY --from=builder /app/rustc-version.txt /app/rustc-version.txt

EXPOSE ${SHIPPING_SERVICE_PORT}
ENTRYPOINT ["/app/shippingservice"]
