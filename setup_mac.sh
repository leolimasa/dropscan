#!/bin/bash

if [ -z "${MACHINE_NAME}" ]; then
  export MACHINE_NAME="dockerdefault"
fi

# Needed in case we are not running from the directory of this script
CURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $CURDIR

docker-machine rm -y $MACHINE_NAME
scripts/setup_docker_machine.sh
eval $(docker-machine env $MACHINE_NAME)
docker build -t dropscan .
