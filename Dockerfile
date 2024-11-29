#-------------------
# Download cilium-cli
#-------------------
FROM alpine:3.20.3@sha256:1e42bbe2508154c9126d48c2b8a75420c3544343bf86fd041fb7527e017a4b4a as builder

# renovate: datasource=github-releases depName=cilium-cli lookupName=cilium/cilium-cli
ARG CLI_VERSION=v0.16.20
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
FROM gcr.io/distroless/static-debian12:nonroot@sha256:d71f4b239be2d412017b798a0a401c44c3049a3ca454838473a4c32ed076bfea as cilium-cli-minimal

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]

#-------------------
# Debug image
#-------------------
FROM gcr.io/distroless/static-debian12:debug-nonroot@sha256:a43e6374356eb5e167e0cedc2326dff771d5cd6a84a8efe264c9266d50fddb39 as cilium-cli-debug

COPY --from=builder /bin/cilium /bin/cilium

ENTRYPOINT ["/bin/cilium"]
