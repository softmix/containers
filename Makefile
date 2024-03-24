# Dynamically generate a version tag based on the current date and time
VERSION_TAG := $(shell date "+%y%m%d-%H%M")

# Lists all directories
DIRS := $(shell ls -d */ | sed 's|/||')
# Lists all Dockerfile.* files, stripping the 'Dockerfile.' prefix to get the project names
FILES := $(patsubst Dockerfile.%,%,$(wildcard Dockerfile.*))
# Combines DIRS and FILES, ensuring uniqueness
PROJECTS := $(sort $(DIRS) $(FILES))

# Explicit rule for building and pushing Docker images
build-push:
	@if [ -d "$(NAME)" ]; then \
		echo "Building from directory $(NAME)/Dockerfile"; \
		docker build -f $(NAME)/Dockerfile -t docker.crashbox.tv/$(NAME):latest -t docker.crashbox.tv/$(NAME):$(VERSION_TAG) $(NAME); \
	elif [ -f "Dockerfile.$(NAME)" ]; then \
		echo "Building from Dockerfile.$(NAME)"; \
		docker build -f Dockerfile.$(NAME) -t docker.crashbox.tv/$(NAME):latest -t docker.crashbox.tv/$(NAME):$(VERSION_TAG) .; \
	else \
		echo "Error: No Dockerfile found for $(NAME)"; \
		exit 1; \
	fi
	docker push docker.crashbox.tv/$(NAME):latest
	docker push docker.crashbox.tv/$(NAME):$(VERSION_TAG)

# The default target and list target
.PHONY: all $(PROJECTS) list
all: $(PROJECTS)

$(PROJECTS):
	@$(MAKE) --no-print-directory build-push NAME=$@

# New target to list all projects
list:
	@echo "Available projects:"
	@$(foreach proj,$(PROJECTS),echo $(proj);)
