#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PODMAN="${PODMAN:-podman}"
REGISTRY="${REGISTRY:-ghcr.io/your-org}"
TAG="${TAG:-latest}"
BUILD_NETWORK="${BUILD_NETWORK:-}"
APP_UID="${APP_UID:-1000}"
APP_GID="${APP_GID:-1000}"

declare -A APP_BINS=(
  [sonarr]=Sonarr
  [radarr]=Radarr
  [prowlarr]=Prowlarr
)

declare -A APP_PORTS=(
  [sonarr]=8989
  [radarr]=7878
  [prowlarr]=9696
)

declare -A APP_DOWNLOAD_URLS=(
  [sonarr]='https://services.sonarr.tv/v1/download/main/latest?version=4&os=linux&arch=x64'
  [radarr]='https://radarr.servarr.com/v1/update/master/updatefile?runtime=netcore&os=linux&arch=x64'
  [prowlarr]='https://prowlarr.servarr.com/v1/update/master/updatefile?runtime=netcore&os=linux&arch=x64'
)

if [[ $# -gt 0 ]]; then
  services=("$@")
else
  services=(sonarr radarr prowlarr)
fi

for service in "${services[@]}"; do
  if [[ -z "${APP_BINS[$service]:-}" ]]; then
    echo "Unknown service: ${service}" >&2
    exit 1
  fi

  image="${REGISTRY}/rootless-${service}:${TAG}"
  build_args=(
    --build-arg "APP_UID=${APP_UID}"
    --build-arg "APP_GID=${APP_GID}"
    --build-arg "APP_ID=${service}"
    --build-arg "APP_BIN=${APP_BINS[$service]}"
    --build-arg "APP_PORT=${APP_PORTS[$service]}"
    --build-arg "APP_DOWNLOAD_URL=${APP_DOWNLOAD_URLS[$service]}"
  )

  if [[ -n "${BUILD_NETWORK}" ]]; then
    build_args+=(--network "${BUILD_NETWORK}")
  fi

  echo "Building ${image}"
  "${PODMAN}" build "${build_args[@]}" -t "${image}" "${ROOT_DIR}/image"
done

echo "Build complete."
