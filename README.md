Custom Keycloak Docker
----------------------

the contents of this repository are used to create a Keycloak standalone server
docker image built on the alpine base to provide a small image to run tests
against. The image size is ~309 MB as opposed to the JBoss/Keycloak image which
is ~640 MB. 

## Running

Execute the following commands to build and run the server:

  $ chmod +x build_run_populate.sh
  $ ./build_run_populate.sh

This will build the docker image, start the server with an admin user generated
with username/password as admin/Password1, and then populate the server
with some test data specified from the data_files/raincatcher-realm.json file.
Navigate to http://localhost:8080 and click on the "Administration Console" link
on the page and login using the credentials admin/Password1.

Successful automated seeding of the container is verified by checking that the
"Example" relam is visibile along with the master relam in the dropdown menu on
the upper left corner of the page.


## Stopping the Server

The name of the running container is "keycloak". Execute the following command
to stop the running container:

  $ docker stop keycloak

## Restarting the stopped

  $ docker start keycloak

## Modifying Seed Data

To modify the seed data in the server, make the appropriate changes to the
data_files/raincatcher-realm.json file, stop and delete any running keycloak
container, and run the build_run_populate.sh script again
