Raincatcher Demo Keycloak example. 
----------------------

The contents of this repository are used to create a Keycloak standalone server
docker image. This image is designed and styled to work with RainCatcher demo solution.


> Note: We do not use official keycloak image as base. Image is built on the alpine base to provide a small image to run tests. 

## Running image 

Image is published to docker hub 

    docker run -p 8080:8080 feedhenry/raincatcher-keycloak
    
Navigate to **http://localhost:8080** and click on the **"Administration Console"** link
on the page and login as the admin user using the following credentials:

    Username: admin
    Password: admin

Successful automated seeding of the container is verified by checking that the
"Raincatcher" realm is visible along with the master realm in the dropdown menu on the upper left corner of the page.

## Building image

Execute the following commands to build and run the server:

    docker build -t feedhenry/raincatcher-keycloak .

This will build the docker image, start the server with an admin user generated, and then populate the server
with some test data specified from the `data_files/raincatcher-realm.json` file.

## Publishing image

    docker push feedhenry/raincatcher-keycloak 

## Modifying Seed Data

To modify the seed data in the server, make the appropriate changes to the
**data_files/raincatcher-realm.json file**, stop and delete any running keycloak
container, and run the docker build again.

**Note:** The 'docker build' command will pickup again at the point where the realm
file to be copied into the image is specified.
