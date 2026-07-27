FROM docker.io/debian:bookworm-slim

ARG APP_VERSION=6.1.1.10360
ARG APP_SHA256=3915f4f875206e650856999fe34308c64636a88de6dafccade2d1763264d77dd
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

RUN mkdir -p /opt/radarr /config \
    && curl -fsSL "https://github.com/Radarr/Radarr/releases/download/v${APP_VERSION}/Radarr.master.${APP_VERSION}.linux-core-x64.tar.gz" -o /tmp/app.tar.gz \
    && echo "${APP_SHA256}  /tmp/app.tar.gz" | sha256sum -c - \
    && tar -xzf /tmp/app.tar.gz -C /opt/radarr --strip-components=1 \
    && rm -f /tmp/app.tar.gz \
    && chown -R app:app /opt/radarr /config

USER app
WORKDIR /config
VOLUME ["/config"]
EXPOSE 7878

ENTRYPOINT ["/opt/radarr/Radarr", "-nobrowser", "-data=/config"]
