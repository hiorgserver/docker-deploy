FROM hiorgserver/docker-php:php7.3

RUN \
    apt-get update &&\
    apt-get -y --no-install-recommends install \
    openssl openssh-client

RUN \
    wget -O nodesource_setup.sh https://deb.nodesource.com/setup_lts.x \
    && bash nodesource_setup.sh \
    && apt-get install -y nodejs \
    && rm nodesource_setup.sh

COPY deploy.sh /usr/bin/
COPY deploy_activate.sh /usr/bin/
COPY runscript.sh /usr/bin/

RUN chmod u+x /usr/bin/deploy.sh /usr/bin/deploy_activate.sh /usr/bin/runscript.sh
