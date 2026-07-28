FROM docker.io/debian:trixie-slim

ARG APP_VERSION=4.0.19.2979
ARG APP_SHA256=b691b3584c31c0b5514058dee81071c923f63d59a37d19e32f92fa13eaa153db
ARG APP_UID=1000
ARG APP_GID=1000

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libicu76 \
      libsqlite3-0 \
      libssl3t64 \
      tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g "${APP_GID}" app \
    && useradd -m -u "${APP_UID}" -g "${APP_GID}" app

RUN mkdir -p /opt/sonarr /config \
    && curl -fsSL "https://github.com/Sonarr/Sonarr/releases/download/v${APP_VERSION}/Sonarr.main.${APP_VERSION}.linux-x64.tar.gz" -o /tmp/app.tar.gz \
    && echo "${APP_SHA256}  /tmp/app.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/app.tar.gz -C /opt/sonarr --strip-components=1 \
    && rm -f /tmp/app.tar.gz \
    && chown -R app:app /opt/sonarr /config

USER app
WORKDIR /config
VOLUME ["/config"]
EXPOSE 8989

ENTRYPOINT ["/opt/sonarr/Sonarr", "-nobrowser", "-data=/config"]
