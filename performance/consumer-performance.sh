#!/bin/bash

# Consumer Performance Test Script

./kafka/bin/kafka-consumer-perf-test.sh --topic test-topic --messages 100000 --broker-list localhost:9092
