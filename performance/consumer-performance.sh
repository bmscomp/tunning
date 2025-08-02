#!/bin/bash

# Consumer Performance Test Script

./kafka/bin/kafka-consumer-perf-test.sh --topic test-topic --messages 100000 --bootstrap-server localhost:9092
