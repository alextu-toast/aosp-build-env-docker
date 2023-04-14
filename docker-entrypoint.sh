#!/bin/bash
set -x

echo ====== IN DOCKER INSTANCE ======
DOCKER_USER=ubuntu
# verify container user was set in dockerfile
if [ -z "${USER}" ]; then
  echo "Set user in Dockerfile";
  exit -1
fi

# verify host uid and gid passed in
if [ -z "${HOST_USER_ID}" -a -z "${HOST_USER_GID}" ]; then
    echo "Pass host uid and gid in docker run command" ;
    echo "e.g. -e HOST_USER_ID=$uid -e HOST_USER_GID=$gid" ;
    exit -2
fi

# replace uid and guid in /etc/passwd and /etc/group
sed -i -e "s/^${DOCKER_USER}:\([^:]*\):[0-9]*:[0-9]*/${DOCKER_USER}:\1:${HOST_USER_ID}:${HOST_USER_GID}/"  /etc/passwd
sed -i -e "s/^${DOCKER_USER}:\([^:]*\):[0-9]*/${DOCKER_USER}:\1:${HOST_USER_GID}/"  /etc/group
chown ${HOST_USER_ID}:${HOST_USER_GID} /home/${DOCKER_USER} -R

#change to /workdir after login
echo "cd /workdir" > /home/${DOCKER_USER}/.bashrc

su - "${DOCKER_USER}" -c bash
