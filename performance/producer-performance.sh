#!/bin/bash

# Producer Performance Test Script

./kafka/bin/kafka-producer-perf-test.sh --topic test-topic --num-records 100000 --record-size 100 --throughput -1 --producer-props bootstrap.servers=localhost:9092
