.PHONY: push all

# Dynamically generate a version tag based on the current date and time
VERSION_TAG := $(shell date "+%y%m%d-%H%M")

# Function to determine if a directory exists
dir_exists = $(shell if [ -d $(1) ]; then echo true; else echo false; fi)

# Dynamically list all projects: directories and standalone Dockerfiles
PROJECTS := $(shell for d in $$(ls -d */); do echo $${d%/}; done) $(shell ls Dockerfile.* | sed 's|Dockerfile.||')

# Default rule for building Docker images based on the target name
%:
	@if [ "$(call dir_exists, $@)" = "true" ]; then \
		echo "Building from directory $@/Dockerfile"; \
		docker build -f $@/Dockerfile -t docker.crashbox.tv/$@:latest -t docker.crashbox.tv/$@:$(VERSION_TAG) ./$@; \
	else \
		echo "Building from Dockerfile.$@"; \
		docker build -f Dockerfile.$@ -t docker.crashbox.tv/$@:latest -t docker.crashbox.tv/$@:$(VERSION_TAG) .; \
	fi
	@$(MAKE) --no-print-directory NAME=$@ push

# Push the Docker image to the registry
push:
	docker push docker.crashbox.tv/$(NAME):latest
	docker push docker.crashbox.tv/$(NAME):$(VERSION_TAG)

# Build and push all projects
all:
	@$(foreach proj,$(PROJECTS),$(MAKE) --no-print-directory $(proj);)
