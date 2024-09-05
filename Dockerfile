#-------------------
# Download cilium-cli
#-------------------
FROM alpine:3.20.2@sha256:0a4eaa0eecf5f8c050e5bba433f58c052be7587ee8af3e8b3910ef9ab5fbe9f5 as builder

# renovate: datasource=github-releases depName=cilium-cli lookupName=cilium/cilium-cli
ARG CLI_VERSION=v0.16.16
ARG TARGETARCH
ARG TARGETOS
ARG TARGETVARIANT

WORKDIR /tmp

RUN apk --no-cache add --upgrade \
    curl

RUN IMAGE=cilium-${TARGETOS}-${TARGETARCH}.tar.gz && \
    curl -SsL -o ${IMAGE} https://github.com/cilium/cilium-cli/releases/download/${CLI_VERSION}/${IMAGE} && \
    tar xzf ${IMAGE} cilium && \
    install cilium /bin && \
    rm ${IMAGE} cilium

#-------------------
# Minimal image
#-------------------
FROM gcr.io/distroless/static-debian12:nonroot@sha256:42d15c647a762d3ce3a67eab394220f5268915d6ddba9006871e16e4698c3a24 as cilium-cli-minimal

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:c37447d1664136bd8b058f83734527aedea9b3111684f82bda56fced124f5432 as cilium-cli-debug

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]
