FROM openjdk:8u131-alpine

LABEL maintainer="feedhenry-raincatcher@redhat.com"
LABEL name="feedhenry/raincatcher-keycloak"
LABEL version="1.0.0"

# Enviornment Variables
ENV KEYCLOAK_VERSION 3.2.0.Final
ENV KEYCLOAK_ADMIN_USERNAME admin
ENV KEYCLOAK_ADMIN_PASSWORD admin
ENV KEYCLOAK_SYSTEM_USER keycloak
ENV KEYCLOAK_USER_HOME_FOLDER /home/$KEYCLOAK_SYSTEM_USER
ENV KEYCLOAK_BIN_FOLDER $KEYCLOAK_USER_HOME_FOLDER/keycloak-$KEYCLOAK_VERSION/bin
ENV SCRIPTS_FOLDER $KEYCLOAK_USER_HOME_FOLDER/scripts
ENV DATA_FILE_FOLDER $KEYCLOAK_USER_HOME_FOLDER/data_files

# Install wget and tar dependencies
RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl && apk add tar

RUN adduser -S $KEYCLOAK_SYSTEM_USER
USER $KEYCLOAK_SYSTEM_USER

WORKDIR $KEYCLOAK_USER_HOME_FOLDER
RUN wget https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz && tar -zxf keycloak-$KEYCLOAK_VERSION.tar.gz && rm *.gz
RUN mkdir $SCRIPTS_FOLDER && mkdir $DATA_FILE_FOLDER
COPY ./data_files/* $DATA_FILE_FOLDER/
COPY ./scripts/* $SCRIPTS_FOLDER/
RUN sh $KEYCLOAK_BIN_FOLDER/add-user-keycloak.sh -u $KEYCLOAK_ADMIN_USERNAME -p $KEYCLOAK_ADMIN_PASSWORD

USER root
RUN chmod -Rf 755 $SCRIPTS_FOLDER &&  chmod -Rf 744 $DATA_FILE_FOLDER

USER $KEYCLOAK_SYSTEM_USER
EXPOSE 8080
ENTRYPOINT [ "/home/keycloak/scripts/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]
