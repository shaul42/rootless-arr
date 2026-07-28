FROM docker.io/debian:trixie-slim

ARG APP_VERSION=6.3.0.10514
ARG APP_SHA256=41d6455c037ff267c5ad5a0f0de4502cebe8f89ec3d051da97851933d48a4047
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
