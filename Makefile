MAKEFLAGS    += --always-make
SHELL        := /usr/bin/env bash
.SHELLFLAGS  := -e -o pipefail -c
.NOTPARALLEL :

test:
	jq -c -r '.project_type[]' cookiecutter.json | while IFS= read -r project_type; do \
		./test-template.sh "$${project_type}"; \
	done
