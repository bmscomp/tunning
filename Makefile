# Makefile for Kafka

KAFKA_VERSION=4.0.0
KAFKA_SCALA_VERSION=2.13
KAFKA_DIST=kafka_$(KAFKA_SCALA_VERSION)-$(KAFKA_VERSION)
KAFKA_URL=https://downloads.apache.org/kafka/$(KAFKA_VERSION)/$(KAFKA_DIST).tgz
KAFKA_DIR=kafka

.PHONY: all clean kafka download extract perms help run

all: kafka

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all        - Download, extract and set permissions for Kafka (default)."
	@echo "  download   - Download Kafka."
	@echo "  extract    - Extract the Kafka tarball."
	@echo "  perms      - Set permissions on the Kafka directory."
	@echo "  kafka      - Run all steps: download, extract, perms."
	@echo "  clean      - Remove downloaded and extracted files."
	@echo "  run        - Run Kafka."

# Target to download, extract and set permissions
kafka: download extract perms
	@echo "Kafka is ready in ./$(KAFKA_DIR)"

# Target to download kafka
download:
	@if [ ! -f $(KAFKA_DIST).tgz ]; then \
		echo "Downloading Kafka..."; \
		curl -O $(KAFKA_URL); \
	else \
		echo "Kafka tarball already downloaded."; \
	fi

# Target to uncompress kafka
extract:
	@if [ ! -d $(KAFKA_DIR) ]; then \
		echo "Extracting Kafka..."; \
		tar -xzf $(KAFKA_DIST).tgz; \
		mv $(KAFKA_DIST) $(KAFKA_DIR); \
	else \
		echo "Kafka already extracted in ./$(KAFKA_DIR)"; \
	fi

# Target to put the correct rights
perms:
	@echo "Setting permissions on ./$(KAFKA_DIR)"
	@chmod -R 755 $(KAFKA_DIR)

# Target to clean the directory
clean:
	@echo "Cleaning up..."
	@rm -f $(KAFKA_DIST).tgz
	@rm -rf $(KAFKA_DIR)
	@rm -f .formatted

# Target to run kafka
.PHONY: all clean kafka download extract perms help run perf-producer perf-consumer

run:
	@echo "Checking if Kafka is formatted..."
	@if [ ! -f $(KAFKA_DIR)/.formatted ]; then \
		echo "Formatting Kafka storage..."; \
		KAFKA_CLUSTER_ID=$$($(KAFKA_DIR)/bin/kafka-storage.sh random-uuid); \
		$(KAFKA_DIR)/bin/kafka-storage.sh format --standalone -t $$KAFKA_CLUSTER_ID -c config/server.properties; \
		$(KAFKA_DIR)/bin/kafka-storage.sh format -t $$KAFKA_CLUSTER_ID -c config/michael.properties; \
		$(KAFKA_DIR)/bin/kafka-storage.sh format -t $$KAFKA_CLUSTER_ID -c config/gabriel.properties; \
		$(KAFKA_DIR)/bin/kafka-storage.sh format -t $$KAFKA_CLUSTER_ID -c config/steven.properties; \
		$(KAFKA_DIR)/bin/kafka-storage.sh format -t $$KAFKA_CLUSTER_ID -c config/seth.properties; \
		$(KAFKA_DIR)/bin/kafka-storage.sh format -t $$KAFKA_CLUSTER_ID -c config/seraphia.properties; \
		touch $(KAFKA_DIR)/.formatted; \
	else \
		echo "Kafka already formatted."; \
	fi
	@echo "Starting Kafka server..."
	$(KAFKA_DIR)/bin/kafka-server-start.sh $(KAFKA_DIR)/config/server.properties & \
	$(KAFKA_DIR)/bin/kafka-server-start.sh $(KAFKA_DIR)/config/michael.properties & \
	$(KAFKA_DIR)/bin/kafka-server-start.sh $(KAFKA_DIR)/config/gabriel.properties & \
	$(KAFKA_DIR)/bin/kafka-server-start.sh $(KAFKA_DIR)/config/steven.properties & \
	$(KAFKA_DIR)/bin/kafka-server-start.sh $(KAFKA_DIR)/config/seth.properties & \
	$(KAFKA_DIR)/bin/kafka-server-start.sh $(KAFKA_DIR)/config/seraphia.properties & \
	

# Target to run producer performance test
perf-producer:
	@echo "Running producer performance test..."
	@./performance/producer-performance.sh

# Target to run consumer performance test
perf-consumer:
	@echo "Running consumer performance test..."
	@./performance/consumer-performance.sh