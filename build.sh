#!/bin/sh

REPO_URL=https://github.com/ZephyrProtocol/zephyr

VERSION=$1
DAEMON_VERSION=$(echo $VERSION | grep -oP ".*(?=_.+)")
PUSH=$2

set -e

if [ -z "$VERSION" -o -z "$DAEMON_VERSION" ]; then
  echo "Usage ${0} <zephyr-version_buildnr> [push]"
  echo "Example: ${0} v0.2.2_1"
  exit 1
fi

docker build --pull --build-arg VERSION=${DAEMON_VERSION} --build-arg REPO_URL=${REPO_URL} -t supertypo/zephyrd:${VERSION} $(dirname $0)
docker tag supertypo/zephyrd:${VERSION} supertypo/zephyrd:latest

if [ "$PUSH" = "push" ]; then
  docker push supertypo/zephyrd:${VERSION}
  docker push supertypo/zephyrd:latest
fi

