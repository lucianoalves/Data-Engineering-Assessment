DOCKER_COMP = DOCKER_BUILDKIT=1 docker-compose
DOCKER_COMP_F = $(DOCKER_COMP) -f docker-compose.yaml
.DEFAULT_GOAL = help
.PHONY        = help


## —————————— 🎵 Commands 🎵 ————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | sed -E 's/(\.dev\.ignore\/)?Makefile?\://' |  awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
up: ## Start database
	$(DOCKER_COMP_F) up -d database # It can take some time for mysql to be ready
build: ## Build
	$(DOCKER_COMP_F) build database example-python population-python
up-with-build: build up ## Build & Start database
up-no-build: up # Start containers without building
down: ## Stop containers
	$(DOCKER_COMP_F) down

## —————————— 🎵 Development 🎵 —————————————————————————————

run: up-no-build ## Run without rebuilding
	$(DOCKER_COMP) run population-python #Update the name of you app
run-build: up-with-build ## Run - with build
	$(DOCKER_COMP) run population-python #Update the name of you app
sh: up-no-build ## Bash - without rebuilding
	$(DOCKER_COMP) run population-python /bin/bash #Update the name of you app
sh-build: up-with-build ## Bash - with rebuilding
	$(DOCKER_COMP) run population-python /bin/bash #Update the name of you app
query: ## Query
	$(DOCKER_COMP_F) run database mysql --host=database --user=temper_code_test --password=good_luck temper_code_test
example:
	$(DOCKER_COMP) run --no-TTY database mysql --host=database --user=temper_code_test --password=good_luck temper_code_test <example_schema.sql
	$(DOCKER_COMP) run example-python
population:
	$(DOCKER_COMP) run --no-TTY database mysql --host=database --user=temper_code_test --password=good_luck temper_code_test <population_schema.sql
	$(DOCKER_COMP) run population-python

log: ## Show Logs
	tail -n 100 -f $(PWD)/logs/*.log | awk '\
		{matched=0}\
		/INFO:/    {matched=1; print "\033[0;37m" $$0 "\033[0m"}\
		/WARNING:/ {matched=1; print "\033[0;34m" $$0 "\033[0m"}\
		/ERROR:/   {matched=1; print "\033[0;31m" $$0 "\033[0m"}\
		/Next/     {matched=1; print "\033[0;31m" $$0 "\033[0m"}\
		/ALERT:/   {matched=1; print "\033[0;35m" $$0 "\033[0m"}\
		/Stack trace:/ {matched=1; print "\033[0;35m" $$0 "\033[0m"}\
		matched==0            {print "\033[0;33m" $$0 "\033[0m"}\
	'
