# Kafka

This is used as a message queue service to connect the checkout service with
the accounting and fraud detection services.

## KRaft: Kafka without ZooKeeper

Kafka is run in KRaft mode, which the `confluentinc/cp-kafka` image supports
natively when `KAFKA_PROCESS_ROLES` and `CLUSTER_ID` are set. Environment
variables are substituted at deploy-time.
