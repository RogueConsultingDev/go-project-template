#! /bin/sh

set -eu

export GIN_MODE=release

exec /usr/local/bin/{{ cookiecutter.project_slug }}
