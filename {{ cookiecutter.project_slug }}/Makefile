MAKEFLAGS += --always-make
SHELL           := /usr/bin/env bash
.SHELLFLAGS     := -e -o pipefail -c
.NOTPARALLEL:

PROJECT_ROOT ?= $(shell git rev-parse --show-toplevel)
PROJECT_NAME ?= {{ cookiecutter.project_slug }}

format:
	go fmt

lint:
	pre-commit run --all-files

test:
	go test -coverprofile=.coverage -tags test ./...
	@if grep -E '0$$' .coverage; then printf "\\e[31m[ERROR]\\e[0m   Missing test coverage\\n"; exit 1; fi;

htmlcov: test
	go tool cover -html=.coverage

clean:
	go clean

{%- if cookiecutter.use_docker == "y" %}

export DOCKER_BUILDKIT ?= 1

DOCKER_REGISTRY ?= MiMe.placeholder
DOCKER_IMAGE    ?= ${PROJECT_NAME}
DOCKER_CONTEXT  ?= ${PROJECT_ROOT}

ifneq ($(CI),)
  DOCKER_REPO  ?= ${DOCKER_REGISTRY}/${DOCKER_IMAGE}
  DOCKER_TAG  ?= $(shell git rev-parse --short HEAD)
else
  DOCKER_REPO  ?= ${DOCKER_IMAGE}
  DOCKER_TAG  ?= dev
endif

docker.build:
	# TODO: Inject creds in CI
	docker build --ssh default --tag ${DOCKER_REPO}:${DOCKER_TAG} ${DOCKER_CONTEXT}

docker.echo.tag:
	@echo ${DOCKER_REPO}:${DOCKER_TAG}

docker.push:
	docker push ${DOCKER_REPO}:${DOCKER_TAG}

{%- endif %}