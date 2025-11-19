# generate containerfiles for multi-stage build
$(shell ./generate_containerfiles.sh)

# get the path to the repo root
CONTEXT := $(abspath $(CURDIR)/..)

# check for container build engine
ifneq (, $(shell which docker))
  ENGINE = docker
endif
ifneq (, $(shell which podman))
  ENGINE = podman
endif

# get name to tag final image with
NAME = $(shell yq -r '.tagging.name // ""' engine_instructions.yaml)

# check whether user has specified a container registry to push to
REGISTRY = $(shell yq -r '.tagging.registry // ""' engine_instructions.yaml)

# create destination URL if registry and image name exist
ifneq ($(REGISTRY),) 
  ifneq ($(NAME),)
    DEST := $(REGISTRY)/$(NAME)
    $(info $(DEST))
  endif  
endif

# organize intermediate image names
IMAGES = $(shell yq -r '.images[]' engine_instructions.yaml)

# specify targets
all: $(IMAGES) FINAL $(NAME) $(REGISTRY)

# execute multi-stage build of container image
$(IMAGES):
	$(ENGINE) build -t $@ -f ./containerfiles/$@.cf $(CONTEXT)

FINAL:
	$(ENGINE) build -t final -f ./containerfiles/final.cf $(CONTEXT)

$(NAME):
	$(ENGINE) tag final $(NAME)

$(REGISTRY):
	$(ENGINE) push $(NAME) $(DEST)
	$(ENGINE) image prune -f
