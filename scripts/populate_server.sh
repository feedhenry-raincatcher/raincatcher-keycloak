#!/bin/sh

echo ""
echo "--------------------------"
echo "Populating Keycloak Server"
echo "--------------------------"
echo ""
sh $KEYCLOAK_BIN_FOLDER/kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user $KEYCLOAK_ADMIN_USERNAME --password $KEYCLOAK_ADMIN_PASSWORD
sh $KEYCLOAK_BIN_FOLDER/kcadm.sh create realms -f $DATA_FILE_FOLDER/raincatcher-realm.json
echo ""
echo "-----------------------------------"
echo "Finished Keycloak Server Population"
echo "-----------------------------------"
