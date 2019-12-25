.PHONY: help spec stan cs test

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

install: ## Install dependancies
	composer install

spec: ## Test phpspec
	bin/phpspec run -fpretty

stan: ## Test static analysis
	bin/psalm --output-format=compact

cs: ## Test coding standards
	bin/phpcs

test: spec stan cs ## Test everything