FROM docker.io/debian:trixie-slim

ARG APP_VERSION=1.6.0
ARG APP_SHA256=9c7523258bde58528d53acc91239774215e44e4f31d28cb2fb1c620ecdaef7b3
ARG APP_UID=1000
ARG APP_GID=1000

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      libsqlite3-0 \
      libssl3t64 \
      python3 \
      python3-lxml \
      python3-numpy \
      python3-pil \
      tzdata \
      unzip \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -g "${APP_GID}" app \
    && useradd -m -u "${APP_UID}" -g "${APP_GID}" app

RUN mkdir -p /opt/bazarr /config \
    && curl -fsSL "https://github.com/morpheus65535/bazarr/releases/download/v${APP_VERSION}/bazarr.zip" -o /tmp/app.zip \
    && echo "${APP_SHA256}  /tmp/app.zip" | sha256sum -c - \
    && unzip -q /tmp/app.zip -d /opt/bazarr \
    && rm -f /tmp/app.zip \
    && chown -R app:app /opt/bazarr /config

USER app
WORKDIR /config
VOLUME ["/config"]
EXPOSE 6767

ENTRYPOINT ["python3", "/opt/bazarr/bazarr.py", "-c", "/config", "--no-update"]
