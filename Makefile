# default environment variables - will be overwritten by user env variables on cli variables.

COLOUR_NORMAL=$(shell tput sgr0)
COLOUR_RED=$(shell tput setaf 1)
COLOUR_GREEN=$(shell tput setaf 2)
COVERAGE=50
COVERFILE=coverage.out

.DEFAULT_GOAL := all

all: clean vendor build lint test ## Clean, Vendor, Build, Lint and Test Fabric
	@if [[ -e .git/rebase-merge ]]; then git --no-pager log -1 --pretty='%h %s'; fi
	@printf '%sSuccess%s\n' "${COLOUR_GREEN}" "${COLOUR_NORMAL}"
	@echo "Run make help to view more fabric-url_shortener commands"

clean: ## Runs go clean and removes generated binaries and coverfiles
	go clean ./...
	rm -f $(COVERFILE)
	rm -f url_shortener
	rm -f gosec_output

vendor: ## Cleans up go mod dependencies and vendor's all dependencies
	go mod tidy
	go mod vendor

build: ## Compiles the url_shortener binary located in ./cmd/url_shortener
	go build ./cmd/url_shortener

run: ## Runs url_shortener main.go locally
	go run ./cmd/url_shortener

gosec:  ## Static code security scanner for golang
	docker run --rm -e GOFLAGS=-mod=vendor -v "$$PWD":/src -w "/src" securego/gosec:v2.2.0 -no-fail -fmt=yaml -out=./gosec_output.yaml /src/...

lint-fix: ## Reorders imports and runs the golangci-lint checker
	goimports -v -w -e ./cmd ./internal
	@make lint

lint: ## Runs golangci-lint checker
	golangci-lint run

test: ## Runs the tests, these require no dependencies or docker images
	go test -covermode=atomic -coverprofile=$(COVERFILE) ./...
	@make cover-check

test-no-coverage:
	go test -covermode=atomic ./...

.PHONY: all clean vendor build lint-fix lint test run build-docker cover-check test-no-coverage ci help

# -- Docker ------------------------------------------------------------


# -- CI / CloudBuilder ------------------------------------------------------------

cover-check: ## Runs the coverage and checks it is above the defined Coverage Level
	@go tool cover -func=$(COVERFILE) | $(CHECK_COVERAGE)

ci: clean vendor build lint gosec test-no-coverage cover-check ## Runs the complete ci chain comparable to CloudBuild, quite slow

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-25s\033[0m %s\n", $$1, $$2}'
	@echo "Coverage Required: ${COLOUR_GREEN}${COVERAGE}%${COLOUR_NORMAL}"

# -- Helm ------------------------------------------------------------

define CHECK_COVERAGE
awk \
  -F '[ 	%]+' \
  -v threshold="$(COVERAGE)" \
  '/^total:/ { print; if ($$3 < threshold) { exit 1 } }' || { \
  	printf '%sFAIL - Coverage below %s%%%s\n' \
  	  "$(COLOUR_RED)" "$(COVERAGE)" "$(COLOUR_NORMAL)"; \
    exit 1; \
  }
    @echo "Coverage Required: ${COLOUR_GREEN}${COVERAGE}${COLOUR_NORMAL}"
endef
