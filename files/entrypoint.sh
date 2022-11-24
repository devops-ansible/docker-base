#!/usr/bin/env bash

if [[ ${BOOT_MSG_SHOW:-1} != 0 ]]; then
    /boot.sh
else
    /boot.sh > /dev/null 2>&1
fi

set -e

exec "$@"
