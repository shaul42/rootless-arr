# rootless-arr

Small container images for:
- `sonarr`
- `radarr`
- `prowlarr`
- `bazarr`

They are intended for rootless Podman or simple Docker setups where you want:
- a non-root runtime user
- no `s6` init system
- pinned upstream releases with SHA256 verification at build time

## Build

Build everything:

```bash
./build.sh
```

Build selected services:

```bash
./build.sh sonarr prowlarr
```

Useful overrides:

```bash
REGISTRY=ghcr.io/acme/arr ./build.sh
TAG=v1 ./build.sh
BUILD_NETWORK=host ./build.sh
APP_UID=1000 APP_GID=1000 ./build.sh
```

`REGISTRY` is the image namespace prefix. For example, `REGISTRY=ghcr.io/acme/arr` produces:
- `ghcr.io/acme/arr/sonarr:<tag>`
- `ghcr.io/acme/arr/radarr:<tag>`
- `ghcr.io/acme/arr/prowlarr:<tag>`
- `ghcr.io/acme/arr/bazarr:<tag>`

## Releases

Pinned upstream versions, download URLs, and SHA256 hashes live in [build-matrix.tsv](/root/src/srv03/rootless-arr/build-matrix.tsv).

To upgrade a service, update its row in that file.

## CI

GitHub Actions reads the same matrix and builds one job per service:
- `Build sonarr`
- `Build radarr`
- `Build prowlarr`
- `Build bazarr`

When the workflow publishes to GHCR, it uses the current GitHub repository namespace automatically. For example, if this repo lives at `github.com/acme/rootless-arr`, the Sonarr image is published as `ghcr.io/acme/rootless-arr/sonarr`.

Published images use explicit version tags from [build-matrix.tsv](/root/src/srv03/rootless-arr/build-matrix.tsv) so a pull always refers to a specific upstream release.

## Runtime

- Mount `/config`
- Match host ownership to the container user, default `1000:1000`
- Ports: Sonarr `8989`, Radarr `7878`, Prowlarr `9696`, Bazarr `6767`
