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


# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build -t $(ORG_NAME)/$(APP_NAME):$(TAG_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(ORG_NAME)/$(APP_NAME):$(TAG_NAME) .

run: ## Run container on port configured in `config.env`
	docker run -i -t --rm --env-file=./.config.env -p=$(OPORT):$(IPORT) --name="$(APP_NAME)" $(ORG_NAME)/$(APP_NAME):$(TAG_NAME)


up: build run ## Run container on port configured in `.config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(RUN_NAME); docker rm $(RUN_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR

# Docker publish
publish: repo-login publish-latest publish-version ## Publish the `{version}` ans `latest` tagged containers to ECR

publish-latest: tag-latest ## Publish the `latest` taged container to ECR
	@echo 'publish latest to $(ORG_NAME)/$(APP_NAME)'
	docker push $(ORG_NAME)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to ECR
	@echo 'publish $(VERSION) to $(ORG_NAME)'
	docker push $(ORG_NAME)/$(APP_NAME):$(TAG_NAME)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: ## Generate container `{version}` tag
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(ORG_NAME)/$(APP_NAME):latest

tag-version: ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(ORG_NAME)/$(APP_NAME):$(TAG_NAME)

# HELPERS

version: ## Output the current version
	@echo $(VERSION)

