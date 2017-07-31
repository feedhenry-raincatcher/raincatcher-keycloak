#!/bin/sh
set -o errexit

exec $KEYCLOAK_BIN_FOLDER/standalone.sh $@ 

function rc::checkIfKeycloakRunning {
    STAT=`netstat -na | grep 8080 | awk '{print $7}'`
    if [ "$STAT" = "LISTEN" ]; then
        echo "Keycloak port accessible and detected"
        sleep 10
        $(rc::installRealm)
    elif [ "$STAT" = "" ]; then 
        sleep 10
        $(rc::checkIfKeycloakRunning)
    fi
}
 
function rc::installRealm {
    echo "Installing RainCatcher realm into Keycloak Server"
    sh $KEYCLOAK_BIN_FOLDER/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $KEYCLOAK_ADMIN_USERNAME --password $KEYCLOAK_ADMIN_PASSWORD
    sh $KEYCLOAK_BIN_FOLDER/kcadm.sh create realms -f $DATA_FILE_FOLDER/raincatcher-realm.json
    echo "Realm created"
}

sleep 20
rc::checkIfKeycloakRunning

exit $?
