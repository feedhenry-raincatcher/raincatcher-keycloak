#!/bin/sh
set -o errexit

function checkIfKeycloakRunning {
    echo "Checking if keycloak is running..."
    STAT=`netstat -na | grep 8080 | awk '{print $6}'`
    if [ "$STAT" = "LISTEN" ]; then
        echo "Keycloak port accessible and detected"
        sleep 10
        installRealm
    elif [ "$STAT" = "" ]; then 
        sleep 5
        echo "Keycloak is not running:`$STAT`. Trying again."
        checkIfKeycloakRunning
    fi
}
 
function installRealm {
    echo "Installing RainCatcher realm into Keycloak Server"
    sh $KEYCLOAK_BIN_FOLDER/kcadm.sh config credentials --server http://127.0.0.1:8080/auth --realm master --user $KEYCLOAK_ADMIN_USERNAME --password $KEYCLOAK_ADMIN_PASSWORD
    sh $KEYCLOAK_BIN_FOLDER/kcadm.sh create realms -f $DATA_FILE_FOLDER/raincatcher-realm.json
    echo "Realm created"
}

sleep 10
checkIfKeycloakRunning

exit $?
