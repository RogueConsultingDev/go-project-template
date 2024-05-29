ARG GO_VERSION={{ cookiecutter.go_version }}
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION} AS build
WORKDIR /src

# Download dependencies as a separate step to take advantage of Docker's caching.
RUN --mount=type=cache,target=/go/pkg/mod/ \
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
COPY --from=build /usr/local/bin/{{ cookiecutter.project_slug }} /usr/local/bin
COPY bin/* /usr/local/bin/

EXPOSE 8080

ENTRYPOINT [ "tini" ]
CMD [ "/usr/local/bin/run.sh" ]
