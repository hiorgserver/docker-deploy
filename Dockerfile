FROM hiorgserver/docker-php:php8.0

RUN \
    apt-get update &&\
    apt-get -y --no-install-recommends install \
    openssl openssh-client

COPY deploy.sh /usr/bin/
COPY deploy_activate.sh /usr/bin/
COPY runscript.sh /usr/bin/

RUN chmod u+x /usr/bin/deploy.sh /usr/bin/deploy_activate.sh /usr/bin/runscript.sh
