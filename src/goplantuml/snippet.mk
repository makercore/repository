GO ?= go
ifneq ($(shell type -p $(GO) >/dev/null 2>&1; echo $$?),0)
	$(error $(GO) not found)
endif

GOPLANTUML ?= goplantuml
ifneq ($(shell type -p $(GOPLANTUML) >/dev/null 2>&1; echo $$?),0)
	$(error $(GOPLANTUML) not found)
endif

GOPLANTUML_TARGET_DIR ?= diagrams
GOPLANTUML_TARGET_FILENAME ?= $(shell basename $(PWD))_gen.puml
GOPLANTUML_SOURCE_DIRS = $(shell $(GO) list -f '{{ .Dir }}' ./...)

GOPLANTUML_TARGET_FILE := $(GOPLANTUML_TARGET_DIR)/$(GOPLANTUML_TARGET_FILENAME)

################################################################################
### phony rules
################################################################################

.PHONY: goplantuml-run
goplantuml-run: $(GOPLANTUML_TARGET_FILE)

################################################################################
### pattern rules
################################################################################

$(GOPLANTUML_TARGET_FILE): $(GOPLANTUML_SOURCE_DIRS)
	@mkdir -p $(GOPLANTUML_TARGET_DIR)
	@$(GOPLANTUML) -recursive $^ > $@
