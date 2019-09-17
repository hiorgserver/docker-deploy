#!/bin/bash

# Please export following variables:
# SSH_HOST
# SSH_PORT
# SERVER_PATH (where files should be delivered on remote host)
# SSH_USER
# SSH_PRIVATE_KEY
# SSH_SERVER_HOSTKEY (i.e. copied from your local ~/.ssh/known_hosts)
# ...and as optional CLI-parameter: $0 /path/to/deploy-skript-on-remote-host

echo ">>> Starting ssh-agent"
# run ssh-agent in background
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")

echo ">>> Add remote host key to known_hosts"
mkdir -p ~/.ssh
echo "$SSH_SERVER_HOSTKEY" > ~/.ssh/known_hosts

echo ">>> Prepare tmp dir: $SSH_HOST:$SERVER_PATH"
# remove old deploy files, mkdir path
ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "rm -rf $SERVER_PATH && mkdir -p $SERVER_PATH" || exit 1

echo ">>> Copy files to $SSH_HOST"
scp -P$SSH_PORT -r $CI_PROJECT_DIR/* $SSH_USER@$SSH_HOST:$SERVER_PATH || exit 1

if [[ $# -gt 0 ]]; then
  echo ">>> Start deployment on remote host: $*"
  ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "$*"
fi
