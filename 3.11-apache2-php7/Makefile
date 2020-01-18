# import deploy config. (from: https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db)
# You can change the default env config with `make cnf="deploy_special.env" release`
cnf ?= .config.env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# You can change the default deploy config with `make dpl="deploy_special.env" release`
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

NEW_NAME := $(ORG_NAME)/$(APP_NAME)
IMG_NAME := $(NEW_NAME):$(TAG_NAME)

# =============================================================================
# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build --build-arg $(CFG_ID) --build-arg "APP_BUILD=$(IMG_NAME)" -t $(IMG_NAME) -t $(NEW_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache --build-arg $(CFG_ID) --build-arg "APP_BUILD=$(IMG_NAME)" -t $(IMG_NAME) -t $(NEW_NAME) .

run: ## Run container on port configured in `config.env`
	docker run -d --env-file ./.config.env --name $(RUN_NAME) $(IMG_NAME)

up: build run ## Run container on port configured in `.config.env` (Alias to run)

# -----------------------------------------------------------------------------
stop: ## STOP this running container
	docker stop $(RUN_NAME)

start: ## START this stopped container
	docker start $(RUN_NAME)

restart: ## RESTART this running container
	docker restart $(RUN_NAME)

rm: ## REMOVE the container
	docker rm $(RUN_NAME)

clean: stop rm ## STOP and REMOVE a running container

delete: ## DELETE this image
	docker rmi $(NEW_NAME) | true
	docker rmi $(IMG_NAME) | true
	docker rmi $(HUB_PUTS)/$(NEW_NAME) | true
	docker rmi $(HUB_PUTS)/$(IMG_NAME) | true
	docker rmi $(HUB_PUSH)/$(NEW_NAME) | true
	docker rmi $(HUB_PUSH)/$(IMG_NAME) | true

prune-image: ## Remove unused/un-referred image(s)
	docker image prune

prune-container: ## Remove unused/stopped container(s)
	docker container prune

prune-volumes: ## Remove unused/stopped volume(s)
	docker volume prune

# -----------------------------------------------------------------------------
puts: ## Publish the `{version}` and `latest` tagged containers to ECR
	docker push $(HUB_PUTS)/$(NEW_NAME)
	docker push $(HUB_PUTS)/$(IMG_NAME)

push: ## Publish the `{version}` and `latest` tagged containers to ECR
	docker push $(HUB_PUSH)/$(NEW_NAME)
	docker push $(HUB_PUSH)/$(IMG_NAME)

publish: build-nc ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR
	docker push $(NEW_NAME)
	docker push $(IMG_NAME)

# -----------------------------------------------------------------------------

# =============================================================================
# HELPERS
la: ## Show all images
	docker images

l: ls ## Show images by this name (an alias to ls)

ls: ## Show images by this name
	docker images | grep -E "$(APP_NAME)|CREATED"

lt: ## Show images by this tag
	docker images | grep -E "$(TAG_NAME)|CREATED"

p: ## Show this running container (by container name)
	docker ps | grep -E "$(RUN_NAME)|CREATED"

ps: ## Show all running container
	docker ps

pt: ## Show all running container (by image name)
	docker ps | grep grep -E "$(APP_NAME)|CREATED"

pa: ## Show all stopped/running container
	docker ps -a

logs: ## Show this running container logs
	docker logs $(RUN_NAME)

dive: ## Dive image folder structure
	dive $(IMG_NAME)

echo: ## Print current profile
	@echo "Image:"
	@echo "\tORG Name\t\t\t: $(ORG_NAME)"
	@echo "\tAPP Name\t\t\t: $(APP_NAME)"
	@echo "\tTAG Name\t\t\t: $(TAG_NAME)"
	@echo "\tRunning Container Name\t\t: $(RUN_NAME)"
	@echo "\tLocal TAG-Name\t\t\t: $(IMG_NAME)"
	@echo "\tLatest IMG-Name\t\t\t: $(NEW_NAME)"
	@echo "\tLocal Registry URL\t\t: $(HUB_PUTS)"
	@echo "\tLocal Registry TAG-Name\t\t: $(HUB_PUTS)/$(IMG_NAME)"
	@echo "\tRemote Registry TAG-Name\t: $(HUB_PUSH)/$(IMG_NAME)"
	@echo "\tPublic Registry TAG-Name\t: $(IMG_NAME)"
	@echo "\tCurrent Version\t\t\t: $(VERSION)"

version: ## Current version
	@echo $(VERSION)

