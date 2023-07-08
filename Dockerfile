FROM debian:stable-slim 

ARG REPO_URL
ARG VERSION

ENV DAEMON_URL=${REPO_URL}/releases/download/${VERSION}/zephyr-cli-linux-${VERSION}.zip
ENV APP_USER=app
ENV APP_UID=61444
ENV APP_DIR=/app
ENV PATH=$APP_DIR:$PATH

# P2P
EXPOSE 17766
# RPC
EXPOSE 17767

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    dumb-init \
    expect \
    procps \
    wget \
    unzip \
    ca-certificates && \
  rm -rf /var/lib/apt/lists/*

RUN mkdir -p $APP_DIR/.zephyr && \
  groupadd -r -g $APP_UID $APP_USER && \
  useradd -d $APP_DIR -r -m -s /sbin/nologin -g $APP_USER -u $APP_UID $APP_USER && \
  chown -R $APP_USER:$APP_USER $APP_DIR

WORKDIR $APP_DIR
USER $APP_USER

RUN cd /tmp && \
  wget ${DAEMON_URL} 2>&1 && \
  unzip zephyr-cli-linux-${VERSION}.zip && \
  cp zephyr-cli-linux-${VERSION}/* $APP_DIR/ && \
  rm -rf *

ENTRYPOINT ["dumb-init", "--"]

CMD zephyrd --non-interactive

