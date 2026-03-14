FROM docker.io/debian:bookworm-slim

ARG APP_UID=1000
ARG APP_GID=1000
ARG APP_ID
ARG APP_KIND
ARG APP_BIN
ARG APP_PORT
ARG APP_DOWNLOAD_URL
ARG APP_DOWNLOAD_SHA256

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libsqlite3-0 \
      libssl3 \
      tzdata \
    && if [ "${APP_KIND}" = "bazarr" ]; then \
      apt-get install -y --no-install-recommends python3 python3-pil python3-lxml python3-numpy unzip; \
    elif [ "${APP_KIND}" = "arr" ]; then \
      apt-get install -y --no-install-recommends libicu72; \
    else \
      echo "Unsupported APP_KIND: ${APP_KIND}" >&2; \
      exit 1; \
    fi \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g "${APP_GID}" app \
    && useradd -m -u "${APP_UID}" -g "${APP_GID}" app

RUN test -n "${APP_ID}" \
    && test -n "${APP_KIND}" \
    && test -n "${APP_BIN}" \
    && test -n "${APP_PORT}" \
    && test -n "${APP_DOWNLOAD_URL}" \
    && test -n "${APP_DOWNLOAD_SHA256}" \
    && mkdir -p "/opt/${APP_ID}" /config \
    && curl -fsSL "${APP_DOWNLOAD_URL}" -o "/tmp/${APP_ID}.archive" \
    && echo "${APP_DOWNLOAD_SHA256}  /tmp/${APP_ID}.archive" | sha256sum -c - \
    && if [ "${APP_KIND}" = "bazarr" ]; then \
      unzip -q "/tmp/${APP_ID}.archive" -d "/opt/${APP_ID}"; \
    else \
      tar -xzf "/tmp/${APP_ID}.archive" -C "/opt/${APP_ID}" --strip-components=1; \
    fi \
    && rm -f "/tmp/${APP_ID}.archive" \
    && chown -R app:app "/opt/${APP_ID}" /config

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENV APP_ID="${APP_ID}" \
    APP_KIND="${APP_KIND}" \
    APP_BIN="${APP_BIN}"

USER app
WORKDIR /config
VOLUME ["/config"]
EXPOSE ${APP_PORT}

ENTRYPOINT ["/entrypoint.sh"]
