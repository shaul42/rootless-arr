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

Each service has a self-contained Dockerfile under `images/<service>/`. To build locally:

```bash
podman build -t sonarr:local images/sonarr
```

The runtime user defaults to `1000:1000` and can be overridden at build time:

```bash
podman build --build-arg APP_UID=2000 --build-arg APP_GID=2000 -t sonarr:local images/sonarr
```

## Releases

Each Dockerfile pins its upstream release via `ARG APP_VERSION` and `ARG APP_SHA256`, and download URLs derive from the version.

To upgrade a service, update those two lines in its Dockerfile.

## CI

GitHub Actions builds one job per service:
- `Build sonarr`
- `Build radarr`
- `Build prowlarr`
- `Build bazarr`

When the workflow publishes to GHCR, it uses the current GitHub repository namespace automatically. For example, if this repo lives at `github.com/acme/rootless-arr`, the Sonarr image is published as `ghcr.io/acme/rootless-arr/sonarr`.

Published images use explicit version tags from the build matrix so a pull always refers to a specific upstream release.

## Runtime

- Mount `/config`
- Match host ownership to the container user, default `1000:1000`
- Ports: Sonarr `8989`, Radarr `7878`, Prowlarr `9696`, Bazarr `6767`
