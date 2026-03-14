#!/bin/sh
set -eu

mkdir -p /config

if [ "${APP_KIND}" = "bazarr" ]; then
  exec python3 "/opt/${APP_ID}/${APP_BIN}" -c /config --no-update
fi

exec "/opt/${APP_ID}/${APP_BIN}" -nobrowser -data=/config
