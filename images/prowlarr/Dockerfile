FROM docker.io/debian:bookworm-slim

ARG APP_VERSION=2.3.5.5327
ARG APP_SHA256=70c2a200f90b5e60239b0ca0cba2ed879ce31f3be68cf1bfe676e6b30292a9d0
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

RUN mkdir -p /opt/prowlarr /config \
    && curl -fsSL "https://github.com/Prowlarr/Prowlarr/releases/download/v${APP_VERSION}/Prowlarr.master.${APP_VERSION}.linux-core-x64.tar.gz" -o /tmp/app.tar.gz \
    && echo "${APP_SHA256}  /tmp/app.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/app.tar.gz -C /opt/prowlarr --strip-components=1 \
    && rm -f /tmp/app.tar.gz \
    && chown -R app:app /opt/prowlarr /config

USER app
WORKDIR /config
VOLUME ["/config"]
EXPOSE 9696

ENTRYPOINT ["/opt/prowlarr/Prowlarr", "-nobrowser", "-data=/config"]
