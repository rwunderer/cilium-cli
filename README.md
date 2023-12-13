[![GitHub license](https://img.shields.io/github/license/rwunderer/cilium-cli.svg)](https://github.com/rwunderer/cilium-cli/blob/main/LICENSE)
<a href="https://renovatebot.com"><img alt="Renovate enabled" src="https://img.shields.io/badge/renovate-enabled-brightgreen.svg?style=flat-square"></a>

# cilium-cli
Minimal Docker image with [Cilium command line utility](https://github.com/cilium/cilium-cli)

## Image variants

This image is based on [distroless](https://github.com/GoogleContainerTools/distroless) and comes in two variants:

### Minimal image

The minimal image is based on `gcr.io/distroless/static-debian12:nonroot` and does not contain a shell. It can be directly used from the command line, eg:

```
$ docker run --rm -it ghcr.io/rwunderer/cilium-cli:v0.14.5-minimal version --client
cilium-cli: v0.14.5 compiled with go1.20.4 on linux/amd64
cilium image (default): v1.13.2
cilium image (stable): v1.14.4
```

### Debug image

The debug images is based on `gcr.io/distroless/static-debian12:debug-nonroot` and contains a busybox shell for use in ci images.
E.g. for GitLab CI:

```
  image:
    name: ghcr.io/rwunderer/cilium-cli:v0.14.5-debug@sha256:42e8fc117a48c35b44160a2747b023009cc3ac800012aa8edab04e29e7166c81
    entrypoint: [""]
  script:
    - cilium version --client
```

## Workflows

| Badge      | Description
|------------|---------
|[![Auto-Tag](https://github.com/rwunderer/cilium-cli/actions/workflows/renovate-create-tag.yml/badge.svg)](https://github.com/rwunderer/cilium-cli/actions/workflows/renovate-create-tag.yml) | Automatic Tagging of new cilium releases
|[![Docker](https://github.com/rwunderer/cilium-cli/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/rwunderer/cilium-cli/actions/workflows/docker-publish.yml) | Docker image build
