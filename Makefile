# The following flags are set based on VERSION and VARIANT environment variables
# that may have been specified, and are used by rules to determine which
# versions/variants are to be processed.  If no VERSION or VARIANT environment
# variables were specified, process everything (the default).
do_default=true
do_alpine=true

# The following logic evaluates VERSION and VARIANT variables that may have
# been previously specified, and modifies the "do" flags depending on the values.
# The VERSIONS variable is also set to contain the version(s) to be processed.
ifdef VERSION
    VERSIONS=$(VERSION) # If a version was specified, VERSIONS only contains the specified version
    ifdef VARIANT       # If a variant is specified, unset all do flags and allow subsequent logic to set them again where appropriate
        do_default=false
        do_alpine=false
        ifeq ($(VARIANT),default)
            do_default=true
        endif
        ifeq ($(VARIANT),alpine)
            do_alpine=true
        endif
    endif
    ifeq ("$(wildcard $(VERSION)/alpine)","") # If no alpine subdirectory exists, don't process the alpine version
        do_alpine=false
    endif
else # If no version was specified, VERSIONS should contain all versions
    VERSIONS = $(foreach df,$(wildcard */Dockerfile),$(df:%/Dockerfile=%))
endif

REPO_NAME  ?= decembrin
IMAGE_NAME ?= pg_partman

DOCKER=docker

build: $(foreach version,$(VERSIONS),build-$(version))

define build-version
build-$1:
ifeq ($(do_default),true)
	$(DOCKER) build	--pull	-t	$(REPO_NAME)/$(IMAGE_NAME):$(shell echo $1) $1
endif
ifeq ($(do_alpine),true)
ifneq ("$(wildcard $1/alpine)","")
	$(DOCKER) build	--pull	-t 	$(REPO_NAME)/$(IMAGE_NAME):$(shell echo $1)-alpine $1/alpine
endif
endif
endef
$(foreach version,$(VERSIONS),$(eval $(call build-version,$(version))))

push:  $(foreach version,$(VERSIONS),push-$(version))

define push-version
push-$1:
ifeq ($(do_default),true)
	$(DOCKER) image	push 		$(REPO_NAME)/$(IMAGE_NAME):$(version)
endif
ifeq ($(do_alpine),true)
ifneq ("$(wildcard $1/alpine)","")
	$(DOCKER) image push 		$(REPO_NAME)/$(IMAGE_NAME):$(version)-alpine
endif
endif
endef
$(foreach version,$(VERSIONS),$(eval $(call push-version,$(version))))

all:
	build