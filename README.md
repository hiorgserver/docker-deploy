# docker-deploy

Docker container der auf `hiorgserver/docker-php` basiert und unsere Deploy-Umgebung zur Verfügung stellt.

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

## Build Container
Bei jedem Push auf den `master` wird ein neuer Container mit dem Tag `latest` gebaut.
Weiterhin werden für alle Tags, die auf den regulären Ausdruck `/^php([0-9.]+)$/` matchen
 ein Tag mit dem Namen `php{\1}` erzeugt.
Beispiel: Git Tag `php7.3` erzeugt einen Container mit dem Tag `php7.3`.

## Build Container locally

Clone repository:

    git clone https://github.com/hiorgserver/hiorg-deploy
    cd hiorg-deploy

Build docker image (als Name wird `hiorg-deploy` gewählt):

    docker build -t hiorg-deploy .

Nun kann der Container ausgeführt werden:

    docker run -it --rm hiorg-deploy /bin/sh
