#!/bin/bash

function green_text () {
  echo -e "\033[0;32m$*\033[0m"
}

DOCKER_IP=$(python -c "import socket;print(socket.gethostbyname('${DOCKER_MACHINE_NAME-localhost}'))")

green_text "Rebuilding esub..."
docker build -t esub .

green_text "Killing esub..."
docker kill esub

green_text "Starting esub on port 8090..."
docker run -d \
    --name esub \
    --hostname esub \
    -p 8090:8090 \
    --log-opt max-size=10m \
    -e ESUB_DEBUG=1 \
    -e ESUB_NODE_IP=$DOCKER_IP \
    esub

docker logs -f esub
