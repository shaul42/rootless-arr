#!/bin/sh
set -eu

mkdir -p /config
exec "/opt/${APP_ID}/${APP_BIN}" -nobrowser -data=/config
