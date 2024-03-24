.PHONY: push

# Function to determine if a directory exists
dir_exists = $(shell if [ -d $(1) ]; then echo true; else echo false; fi)

# Default rule for building Docker images based on the target name
%:
	@if [ "$(call dir_exists, $@)" = "true" ]; then \
		echo "Building from directory $@/Dockerfile"; \
		docker build -f $@/Dockerfile -t docker.crashbox.tv/$@:latest ./$@; \
	else \
		echo "Building from Dockerfile.$@"; \
		docker build -f Dockerfile.$@ -t docker.crashbox.tv/$@:latest .; \
	fi
	@$(MAKE) --no-print-directory NAME=$@ push

# Push the Docker image to the registry
push:
	docker push docker.crashbox.tv/$(NAME):latest
