#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PODMAN="${PODMAN:-podman}"
REGISTRY="${REGISTRY:-ghcr.io/your-org}"
TAG="${TAG:-}"
BUILD_NETWORK="${BUILD_NETWORK:-}"
APP_UID="${APP_UID:-1000}"
APP_GID="${APP_GID:-1000}"
MATRIX_FILE="${MATRIX_FILE:-${ROOT_DIR}/build-matrix.tsv}"

declare -A SELECTED_SERVICES=()
if [[ $# -gt 0 ]]; then
  for service in "$@"; do
    SELECTED_SERVICES["$service"]=1
  done
fi

build_count=0

while IFS=$'\t' read -r service app_bin app_port app_version app_download_url app_download_sha256; do
  if [[ "${service}" == "service" || -z "${service}" ]]; then
    continue
  fi

  if [[ ${#SELECTED_SERVICES[@]} -gt 0 && -z "${SELECTED_SERVICES[$service]:-}" ]]; then
    continue
  fi

  image_tag="${TAG:-${app_version}}"
  image="${REGISTRY}/${service}:${image_tag}"
  build_args=(
    --build-arg "APP_UID=${APP_UID}"
    --build-arg "APP_GID=${APP_GID}"
    --build-arg "APP_ID=${service}"
    --build-arg "APP_BIN=${app_bin}"
    --build-arg "APP_PORT=${app_port}"
    --build-arg "APP_DOWNLOAD_URL=${app_download_url}"
    --build-arg "APP_DOWNLOAD_SHA256=${app_download_sha256}"
  )

  if [[ -n "${BUILD_NETWORK}" ]]; then
    build_args+=(--network "${BUILD_NETWORK}")
  fi

  echo "Building ${image}"
  "${PODMAN}" build "${build_args[@]}" -t "${image}" "${ROOT_DIR}/image"
  build_count=$((build_count + 1))
  unset "SELECTED_SERVICES[$service]"
done < "${MATRIX_FILE}"

if [[ ${#SELECTED_SERVICES[@]} -gt 0 ]]; then
  echo "Unknown service(s): ${!SELECTED_SERVICES[*]}" >&2
  exit 1
fi

if [[ "${build_count}" -eq 0 ]]; then
  echo "No services selected from ${MATRIX_FILE}" >&2
  exit 1
fi

echo "Build complete."
