# import config. (from: https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db)
# You can change the default config with `make cnf="config_special.env" build`
cnf ?= .config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
dpl ?= .deploy.env
include $(dpl)
export $(shell sed 's/=.*//' $(dpl))

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

# =============================================================================
# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build -t $(ORG_NAME)/$(APP_NAME):$(TAG_NAME) .
	docker build -t $(ORG_NAME)/$(APP_NAME):latest .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(ORG_NAME)/$(APP_NAME):$(TAG_NAME) .
	docker build --no-cache -t $(ORG_NAME)/$(APP_NAME):latest .

run: ## Run container on port configured in `config.env`
	docker run -d -t --rm --env-file=./.config.env -p=$(OPORT):$(IPORT) --name="$(RUN_NAME)" $(ORG_NAME)/$(APP_NAME):$(TAG_NAME)

up: build run ## Run container on port configured in `.config.env` (Alias to run)

# -----------------------------------------------------------------------------
stop: ## Stop a running container
	docker stop $(RUN_NAME)

rm: ## Remove the container
	docker rm $(RUN_NAME)

clean: stop rm ## Stop and remove a running container

prune-image: ## Remove unused/un-referred image(s)
	docker image prune

prune-container: ## Remove unused/stopped container(s)
	docker container prune

prune-volumes: ## Remove unused/stopped volume(s)
	docker volume prune

# -----------------------------------------------------------------------------
release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR

# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` and `latest` tagged containers to ECR

publish-latest: ## Publish the `latest` taged container to ECR
	@echo 'publish latest to $(ORG_NAME)/$(APP_NAME)'
	docker push $(ORG_NAME)/$(APP_NAME):latest

publish-version: ## Publish the `{version}` taged container to ECR
	@echo 'publish $(VERSION) to $(ORG_NAME)'
	docker push $(ORG_NAME)/$(APP_NAME):$(TAG_NAME)

# =============================================================================
# HELPERS
ls: ## Show images
	docker images

ps: ## Show running container
	docker ps

pa: ## Show all running container
	docker ps -a

logs: ## Show running container logs
	docker logs $(RUN_NAME)

dive: ## Dive image folder structure
	dive $(ORG_NAME)/$(APP_NAME):$(TAG_NAME)

version: ## Output the current version
	@echo $(VERSION)

