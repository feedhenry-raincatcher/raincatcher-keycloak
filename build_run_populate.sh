#!/bin/bash

NAME=keycloak
docker build -t custom-keycloak-server .
docker run --name $NAME -p 8080:8080 custom-keycloak-server &
sleep 30
docker exec $NAME /home/keycloak/scripts/populate_server.sh
