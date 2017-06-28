FROM openjdk:8u131-alpine

LABEL maintainer="thnolan@redhat.com"
LABEL name="raincatcher-keycloak-docker"
LABEL version="1.0.0"

ENV KEYCLOAK_VERSION 3.1.0.Final
ENV KEYCLOAK_ADMIN_USERNAME admin
ENV KEYCLOAK_ADMIN_PASSWORD Password1
ENV KEYCLOAK_SYSTEM_USER keycloak
ENV KEYCLOAK_USER_HOME_FOLDER /home/$KEYCLOAK_SYSTEM_USER
ENV KEYCLOAK_BIN_FOLDER $KEYCLOAK_USER_HOME_FOLDER/keycloak-$KEYCLOAK_VERSION/bin
ENV SCRIPTS_FOLDER $KEYCLOAK_USER_HOME_FOLDER/scripts
ENV DATA_FILE_FOLDER $KEYCLOAK_USER_HOME_FOLDER/data_files

# Install wget and tar depnedencies
USER root
RUN apk update && apk add ca-certificates && update-ca-certificates && apk add openssl && apk add tar

# setup keycloak user
RUN adduser -S $KEYCLOAK_SYSTEM_USER
USER $KEYCLOAK_SYSTEM_USER
WORKDIR $KEYCLOAK_USER_HOME_FOLDER
RUN mkdir $SCRIPTS_FOLDER
RUN mkdir $DATA_FILE_FOLDER
COPY ./scripts/docker-entrypoint.sh $SCRIPTS_FOLDER
COPY ./scripts/populate_server.sh $SCRIPTS_FOLDER
COPY ./data_files/raincatcher-realm.json $DATA_FILE_FOLDER

# Change file permissions on shell scripts to make them executable
USER root
RUN chmod +x $SCRIPTS_FOLDER/docker-entrypoint.sh
RUN chmod +x $SCRIPTS_FOLDER/populate_server.sh
USER $KEYCLOAK_SYSTEM_USER

# Download and extract the standaone server and remove the tar.gz file
RUN wget https://downloads.jboss.org/keycloak/$KEYCLOAK_VERSION/keycloak-$KEYCLOAK_VERSION.tar.gz && tar -zxf keycloak-$KEYCLOAK_VERSION.tar.gz && rm *.gz

# Create admin user for keycloak
RUN sh $KEYCLOAK_BIN_FOLDER/add-user-keycloak.sh -u $KEYCLOAK_ADMIN_USERNAME -p $KEYCLOAK_ADMIN_PASSWORD

# Expose port 8080, set the entry point and allow access from all ip addresses
EXPOSE 8080
ENTRYPOINT [ "/home/keycloak/scripts/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]
