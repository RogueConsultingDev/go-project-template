module github.com/{{ cookiecutter.github_org}}/{{ cookiecutter.project_slug }}

go {{ cookiecutter.go_version }}

require (
	github.com/gin-gonic/gin v1.10.0
	github.com/stretchr/testify v1.9.0
)
