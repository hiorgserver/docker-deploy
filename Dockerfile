FROM hiorgserver/docker-php:php7.0

RUN \
    apt-get update &&\
    apt-get -y --no-install-recommends install \
    openssl openssh-client

COPY deploy.sh /usr/bin/

RUN chmod u+x /usr/bin/deploy.sh
