GOLANG_DEBUG ?= $(or $(DEBUG),0)

GO ?= go
ifneq ($(shell type -p $(GO) >/dev/null 2>&1; echo $$?),0)
	$(error $(GO) not found)
endif

GOLANG_LINT ?= golangci-lint run
ifneq ($(shell type -p $(GOLANG_LINT) >/dev/null 2>&1; echo $$?),0)
	$(error $(GOLANG_LINT) not found)
endif

GOLANG_PACKAGE ?= $(shell $(GO) list)
GOLANG_BIN ?= $(shell $(GO) list -f '{{ .Name }}')
GOLANG_BUILD_DIR ?= .
GOLANG_TAGS ?= ""
GOLANG_FLAGS ?= -race -tags $(GOLANG_TAGS) -mod vendor
GOLANG_TEST_FLAGS ?=
GOLANG_COVER_FLAGS ?= -cover
GOLANG_COVERPROFILE ?= coverage.out
GOLANG_VENDOR_DIR ?= vendor/
ifeq ($(GOLANG_DEBUG),1)
GOLANG_GCFLAGS ?= "-l -N -L"
GOLANG_LDFLAGS ?= ""
else
GOLANG_GCFLAGS ?= ""
GOLANG_LDFLAGS ?= "-w -s"
endif
GOLANG_BUILD_FLAGS ?= -gcflags $(GOLANG_GCFLAGS) -ldflags $(GOLANG_LDFLAGS)

GOLANG_COVERPROFILE_HTML := $(patsubst %.out,%.html,$(GOLANG_COVERPROFILE))
GOLANG_SOURCE_DIRS := $(shell $(GO) list -f '{{ .Dir }}' ./...)
GOLANG_SOURCE_FILES := $(shell $(GO) list -f '{{ range .GoFiles }}{{ printf "%s/%s\n" $$.Dir . }}{{ end }}' ./...)
GOLANG_SOURCE_TEST_FILES := $(shell $(GO) list -f '{{ range .TestGoFiles }}{{ printf "%s/%s\n" $$.Dir . }}{{ end }}' ./...)
GOLANG_SOURCE_XTEST_FILES := $(shell $(GO) list -f '{{ range .XTestGoFiles }}{{ printf "%s/%s\n" $$.Dir . }}{{ end }}' ./...)

ifneq ($(wildcard main.go),)
GOLANG_RUN ?= main.go
else ifneq ($(wildcard cmd),)
GOLANG_RUN ?= ./cmd/...
else
GOLANG_RUN ?= .
endif

################################################################################
### phony rules
################################################################################

.PHONY: golang-build
golang-build: $(GOLANG_BUILD_DIR)/$(GOLANG_BIN)

.PHONY: golang-clean
golang-clean:
	$(RM) $(GOLANG_BUILD_DIR)/$(GOLANG_BIN)
	$(RM) -r $(GOLANG_VENDOR_DIR)
	$(RM) $(GOLANG_COVERPROFILE)
	$(RM) $(GOLANG_COVERPROFILE_HTML)
	$(GO) clean -i -cache -testcache ./...

.PHONY: golang-coverage
golang-coverage: $(GOLANG_COVERPROFILE)
	@$(GO) tool cover -func=$<

.PHONY: golang-coverage-html
golang-coverage-html: $(GOLANG_COVERPROFILE_HTML)

.PHONY: golang-lint
golang-lint:
	$(GOLANG_LINT)

.PHONY: golang-test
golang-test:
	$(GO) test $(GOLANG_FLAGS) $(GOLANG_TEST_FLAGS) ./...

.PHONY: golang-run
golang-run: $(GOLANG_SOURCE_FILES) $(GOLANG_VENDOR_DIR)
	$(GO) run $(GOLANG_FLAGS) $(GOLANG_RUN) $(GOLANG_RUN_ARGS)

.PHONY: golang-vendor
golang-vendor: $(GOLANG_VENDOR_DIR)

################################################################################
### chain rules
################################################################################

$(GOLANG_VENDOR_DIR): go.sum
	$(GO) mod vendor
	@mkdir -p $(GOLANG_VENDOR_DIR)

go.sum: go.mod
	$(GO) mod download
	@touch go.sum

$(GOLANG_BUILD_DIR)/$(GOLANG_BIN): $(GOLANG_SOURCE_FILES) $(GOLANG_VENDOR_DIR)
	$(GO) build $(GOLANG_FLAGS) $(GOLANG_BUILD_FLAGS) -o $(GOLANG_BUILD_DIR)/ ./...

################################################################################
### pattern rules
################################################################################

.PRECIOUS: %.out
%.html: %.out
	$(GO) tool cover -html=$< -o $@

%.out: $(GOLANG_SOURCE_FILES) $(GOLANG_SOURCE_TEST_FILES) $(GOLANG_SOURCE_XTEST_FILES)
	-$(GO) test $(GOLANG_FLAGS) $(GOLANG_TEST_FLAGS) $(GOLANG_COVER_FLAGS) -coverprofile=$@ ./...
