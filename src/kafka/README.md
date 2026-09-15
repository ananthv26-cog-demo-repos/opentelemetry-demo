# Kafka

This is used as a message queue service to connect the checkout service with
the accounting and fraud detection services.

## KRaft: Kafka without ZooKeeper

Kafka is run in KRaft mode, which the `cp-kafka` image supports natively: the
entrypoint exports `CLUSTER_ID` from the `clusterID` file and the image formats
the storage directory on first start. Environment variables are substituted at
deploy-time.
