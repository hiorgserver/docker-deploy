# docker-deploy

Docker container der auf `hiorgserver/docker-php` basiert und unsere Deploy-Umgebung (inkl. NodeJS in der LTS-Version)
zur Verfügung stellt.

## Run Container
Der Container kann von [dockerhub](https://hub.docker.com/r/hiorgserver/docker-deploy/) bezogen 
 und mit folgendem Commando direkt ausgeführt werden:

    docker run -it --rm hiorgserver/docker-deploy /bin/sh

## Tags
Wir verwenden für unterschiedliche PHP-Versionen verschiedene Container, die über Tags
 spezifiziert werden.
Hierfür sind die Docker-Container mit entsprechenden Tags (z.b. `php7.3`) versehen sowie
 die Commits, welche die Grundlage für die gebauten Container darstellen.

Je nach PHP-Version wird ggf. eine andere Debian-Version verwendet.

Das Tag `latest` entspricht immer dem aktuellen `master`.

Wird kein Tag angegeben, so wird `latest` als Default angenommen.

## Build Container locally

Clone repository:

    git clone https://github.com/hiorgserver/docker-deploy.git
    cd docker-deploy

Build docker image (als Name wird `docker-deploy` gewählt):

    docker build -t docker-deploy .

Nun kann der Container ausgeführt werden:

    docker run -it --rm docker-deploy /bin/sh

## Push the image to docker hub
First build the image and get the image id with `docker images`.

Then rename the docker image and optionally add a specific tag:

    docker tag d9c8d3b75749 hiorgserver/docker-deploy[:tag]

Finally push the images to dockerhub: `docker push hiorgserver/docker-deploy[:tag]`
