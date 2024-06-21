#! /bin/bash

set -eu

PROJECT_TYPE="${1:?Project type not specified}"
PROJECT_SLUG="test-project-${PROJECT_TYPE}-$(uuidgen | tr '[:upper:]' '[:lower:]')"
ROOT_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

info()    { printf "\\e[32m[INFO]\\e[0m    %s\\n" "$*" >&2 ; }
warning() { printf "\\e[33m[WARNING]\\e[0m %s\\n" "$*" >&2 ; }
error()   { printf "\\e[31m[ERROR]\\e[0m   %s\\n" "$*" >&2 ; }
fatal()   { printf "\\e[35m[FATAL]\\e[0m   %s\\n" "$*" >&2 ; exit 1 ; }

cleanup() {
    if docker image inspect "${PROJECT_SLUG}:dev" &>/dev/null; then
        info "Deleting docker image"
        docker rmi "${PROJECT_SLUG}:dev"
    fi

    info "Cleaning up generated project"
    rm -rf "${ROOT_DIR:?}/${PROJECT_SLUG}"
}

trap cleanup EXIT SIGINT SIGTERM

info "Creating a project of type: ${PROJECT_TYPE}"
cruft create "${ROOT_DIR}" -y --extra-context '{"project_slug": "'"${PROJECT_SLUG}"'", "project_type": "'"${PROJECT_TYPE}"'"}'

cd "${PROJECT_SLUG}"

# Add indirect deps in go.mod, generate go.sum
make mod

# Ensure the project builds correctly
go build .

# Create a first commit to ensure pre-commit works
git init
git add .
pre-commit install
git commit -m 'Initial Commit'

make lint
make test
if [[ -f Dockerfile ]]; then
    make docker.build
fi
