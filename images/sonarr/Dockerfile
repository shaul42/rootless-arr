FROM docker.io/debian:bookworm-slim

ARG APP_VERSION=4.0.17.2952
ARG APP_SHA256=d5142372067d727979421ca7b1d60601ceecd9758af3a7dafacc6ebba831777a
ARG APP_UID=1000
ARG APP_GID=1000

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
