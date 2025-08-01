# Makefile for Kafka

KAFKA_VERSION=4.0.0
KAFKA_SCALA_VERSION=2.13
KAFKA_DIST=kafka_$(KAFKA_SCALA_VERSION)-$(KAFKA_VERSION)
KAFKA_URL=https://downloads.apache.org/kafka/$(KAFKA_VERSION)/$(KAFKA_DIST).tgz
KAFKA_DIR=kafka

.PHONY: all clean kafka download extract perms help

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
