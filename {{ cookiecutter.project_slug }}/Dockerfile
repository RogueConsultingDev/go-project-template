ARG GO_VERSION={{ cookiecutter.go_version }}
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION} AS build
WORKDIR /src

ENV GOPRIVATE=github.com/{{ cookiecutter.github_org }}
RUN --mount=type=secret,id=GITHUB_TOKEN \
    if [ ! -d ~/.ssh ]; then install -d -m 700 ~/.ssh; fi \
    && echo 'github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl' >> ~/.ssh/known_hosts \
    && if [ -e /run/secrets/GITHUB_TOKEN ]; then \
        git config --global "url.https://mathieu-lemay:$(cat /run/secrets/GITHUB_TOKEN)@github.com/{{ cookiecutter.github_org }}/.insteadof" https://github.com/{{ cookiecutter.github_org }}/; \
    else \
        git config --global url.ssh://git@github.com/{{ cookiecutter.github_org }}/.insteadof https://github.com/{{ cookiecutter.github_org }}/; \
    fi;

# Download dependencies as a separate step to take advantage of Docker's caching.
RUN --mount=type=ssh \
    --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,source=go.sum,target=go.sum \
    --mount=type=bind,source=go.mod,target=go.mod \
    go mod download -x

ARG TARGETARCH

# Build the application.
RUN --mount=type=cache,target=/go/pkg/mod/ \
    --mount=type=bind,target=. \
    CGO_ENABLED=0 GOARCH=$TARGETARCH go build -o /usr/local/bin/{{ cookiecutter.project_slug }} .

FROM alpine:latest AS final

LABEL PROJECT="MiMe"

# Maybe have a base image with that stuff already in it?
RUN --mount=type=cache,target=/var/cache/apk \
    apk --update add \
        ca-certificates \
        tzdata \
        tini \
        && \
        update-ca-certificates

USER nobody

# Copy the executable from the "build" stage.
COPY --from=build /usr/local/bin/{{ cookiecutter.project_slug }} /usr/local/bin/
COPY bin/* /usr/local/bin/

EXPOSE 8080

ENTRYPOINT [ "tini" ]
CMD [ "/usr/local/bin/run.sh" ]
