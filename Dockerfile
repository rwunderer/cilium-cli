#-------------------
# Download cilium-cli
#-------------------
FROM alpine:3.22.0@sha256:8a1f59ffb675680d47db6337b49d22281a139e9d709335b492be023728e11715 AS builder

# renovate: datasource=github-releases depName=cilium-cli lookupName=cilium/cilium-cli
ARG CLI_VERSION=v0.18.3
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:188ddfb9e497f861177352057cb21913d840ecae6c843d39e00d44fa64daa51c AS cilium-cli-minimal

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:633d5fa264a127052ca34c3fdaf81ef5a58204770736df9047745919a5b318f6 AS cilium-cli-debug

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]
