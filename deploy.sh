#!/bin/bash

# Please export following variables:
# SSH_HOST
# SSH_PORT
# SERVER_PATH (where files should be delivered on remote host)
# SSH_USER
# SSH_PRIVATE_KEY
# SSH_HOSTKEYS (i.e. copied from your local ~/.ssh/known_hosts)
# ...and as optional CLI-parameter: $0 /path/to/deploy-skript-on-remote-host arguments...

# assert ENV
[ -z "$SSH_HOST" ] && echo "SSH_HOST empty" && exit 1
[ -z "$SSH_PORT" ] && SSH_PORT="22"
[ -z "$SERVER_PATH" ] && echo "SERVER_PATH empty" && exit 1
[ -z "$SSH_USER" ] && echo "SSH_USER empty" && exit 1
[ -z "$SSH_PRIVATE_KEY" ] && echo "SSH_PRIVATE_KEY empty" && exit 1
[ -z "$SSH_HOSTKEYS" ] && echo "SSH_HOSTKEYS empty" && exit 1

echo ">>> Starting ssh-agent"
# run ssh-agent in background
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")

echo ">>> Add remote host key to known_hosts"
mkdir -p ~/.ssh
echo "$SSH_HOSTKEYS" > ~/.ssh/known_hosts

echo ">>> Prepare tmp dir: $SSH_HOST:$SERVER_PATH"
# mkdir path
ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "mkdir -p $SERVER_PATH" || exit 1

echo ">>> Copy files to $SSH_HOST"
scp -P$SSH_PORT -r $CI_PROJECT_DIR/* $SSH_USER@$SSH_HOST:$SERVER_PATH || exit 1

if [[ $# -gt 0 ]]; then
  echo ">>> Start deployment on remote host: $*"
  ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "$*"
fi
