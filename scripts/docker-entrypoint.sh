#!/bin/sh
set -o errexit

$SCRIPTS_FOLDER/realm-init.sh &

exec $KEYCLOAK_BIN_FOLDER/standalone.sh $@ 
exit $?
