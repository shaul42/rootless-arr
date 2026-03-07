FROM docker.io/debian:bookworm-slim

ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_ID
ARG APP_BIN
ARG APP_PORT
ARG APP_DOWNLOAD_URL
ARG APP_DOWNLOAD_SHA256

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libicu72 \
      libsqlite3-0 \
      libssl3 \
      tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g "${APP_GID}" app \
    && useradd -m -u "${APP_UID}" -g "${APP_GID}" app

RUN test -n "${APP_ID}" \
    && test -n "${APP_BIN}" \
    && test -n "${APP_PORT}" \
    && test -n "${APP_DOWNLOAD_URL}" \
    && test -n "${APP_DOWNLOAD_SHA256}" \
    && mkdir -p "/opt/${APP_ID}" /config \
    && curl -fsSL "${APP_DOWNLOAD_URL}" -o "/tmp/${APP_ID}.tgz" \
    && echo "${APP_DOWNLOAD_SHA256}  /tmp/${APP_ID}.tgz" | sha256sum -c - \
    && tar -xzf "/tmp/${APP_ID}.tgz" -C "/opt/${APP_ID}" --strip-components=1 \
    && rm -f "/tmp/${APP_ID}.tgz" \
    && chown -R app:app "/opt/${APP_ID}" /config

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENV APP_ID="${APP_ID}" \
    APP_BIN="${APP_BIN}"

USER app
WORKDIR /config
VOLUME ["/config"]
EXPOSE ${APP_PORT}

ENTRYPOINT ["/entrypoint.sh"]
