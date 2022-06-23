#!/bin/bash
set -x

#The --security-opt here is to workaround a NsJail error in docker (https://issuetracker.google.com/issues/123210688?pli=1)
docker run --rm -e HOST_USER_ID=$UID -e HOST_USER_GID="$(id -g)" -v "$PWD":/workdir -it --security-opt apparmor=unconfined --security-opt seccomp=unconfined --security-opt systempaths=unconfined ghcr.io/alex-tu-cc/aosp-build-env-docker:focal docker-entrypoint.sh
