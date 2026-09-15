#!/bin/sh

# https://github.com/confluentinc/learn-kafka-kraft/blob/4c75598779c4a993464f6979dc0d702552df8f3b/kraft/scripts/update_run.sh

# Docker workaround: neutralize the Zookeeper-mode parameter checks. They live inside
# if/else branches, so replace them with a no-op instead of deleting the lines.
sed -i 's/dub ensure KAFKA_ZOOKEEPER_CONNECT/echo ignore zookeeper connect check/' /etc/confluent/docker/configure
sed -i 's/dub ensure KAFKA_ADVERTISED_LISTENERS/echo ignore advertised listeners check/' /etc/confluent/docker/configure

# Docker workaround: Ignore cub zk-ready
sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure
