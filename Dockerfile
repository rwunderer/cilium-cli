#-------------------
# Download cilium-cli
#-------------------
FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c AS builder

# renovate: datasource=github-releases depName=cilium-cli lookupName=cilium/cilium-cli
ARG CLI_VERSION=v0.18.2
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:b35229a3a6398fe8f86138c74c611e386f128c20378354fc5442811700d5600d AS cilium-cli-minimal

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:14a28be5b9e710e8d5a519cd7d76ab2714b35edb641307c07a264372ed0c81a9 AS cilium-cli-debug

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]
