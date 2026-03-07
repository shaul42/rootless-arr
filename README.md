# rootless-arr

Self-built, rootless-friendly images for the Arr stack without `s6` or `PUID/PGID` hacks.

Included services:
- `sonarr`
- `radarr`
- `prowlarr`

## Goals

- Run cleanly as non-root (`uid/gid 1000` by default).
- Keep runtime simple (`ENTRYPOINT` runs the app directly).
- Avoid LSIO `s6-applyuidgid` issues in rootless Podman.

## Build

From this directory:

```bash
./build.sh
```

By default it builds:
- `ghcr.io/your-org/rootless-sonarr:latest`
- `ghcr.io/your-org/rootless-radarr:latest`
- `ghcr.io/your-org/rootless-prowlarr:latest`

You can override:

```bash
REGISTRY=ghcr.io/<your-user-or-org> TAG=v1 ./build.sh
```

Build a subset:

```bash
./build.sh sonarr prowlarr
```

Pass through a Podman network mode when the host bridge backend is problematic:

```bash
BUILD_NETWORK=host ./build.sh
```

## Push

```bash
podman push ghcr.io/<your-user-or-org>/rootless-sonarr:v1
podman push ghcr.io/<your-user-or-org>/rootless-radarr:v1
podman push ghcr.io/<your-user-or-org>/rootless-prowlarr:v1
```

## Runtime expectations

- Mount `/config` to persistent storage.
- Ensure host path ownership matches container user (`1000:1000` by default).
- Default ports:
  - Sonarr: `8989`
  - Radarr: `7878`
  - Prowlarr: `9696`

## Optional build args

The shared image build supports:
- `APP_UID` (default `1000`)
- `APP_GID` (default `1000`)
- `APP_ID`
- `APP_BIN`
- `APP_PORT`
- `APP_DOWNLOAD_URL` to pin a specific release artifact URL

Examples:

```bash
podman build -t ghcr.io/acme/rootless-sonarr:latest \
  --network host \
  --build-arg APP_UID=1000 \
  --build-arg APP_GID=1000 \
  --build-arg APP_ID=sonarr \
  --build-arg APP_BIN=Sonarr \
  --build-arg APP_PORT=8989 \
  --build-arg APP_DOWNLOAD_URL='https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64' \
  ./image
```

## CI

GitHub Actions builds all three images from the shared `image/` context using a matrix and can publish them to GHCR.
