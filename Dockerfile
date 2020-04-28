FROM hiorgserver/docker-php:php7.3

RUN \
    apt-get update &&\
    apt-get -y --no-install-recommends install \
    openssl openssh-client

COPY deploy.sh /usr/bin/
COPY runscript.sh /usr/bin/

RUN chmod u+x /usr/bin/deploy.sh /usr/bin/runscript.sh
