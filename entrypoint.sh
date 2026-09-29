#!/bin/bash
set -e

# If the docker socket exists, match www-data's group to its GID
if [ -S /var/run/docker.sock ]; then
    SOCK_GID=$(stat -c '%g' /var/run/docker.sock)
    if ! getent group "$SOCK_GID" >/dev/null; then
        groupadd -g "$SOCK_GID" dockersock
    fi
    usermod -aG "$SOCK_GID" www-data
fi

# Start Apache in the foreground
exec apache2-foreground
