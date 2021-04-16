#!/bin/bash

# Please export following variables:
# SSH_USER
# SSH_PORT
# SSH_PRIVATE_KEY
# SSH_HOSTKEYS (i.e. copied from your local ~/.ssh/known_hosts)
# SERVER_PATH
# WARMUP_SCRIPT    (optional)
# ACTIVATE_SCRIPT  (optional)
# ...and as CLI-parameter: $0 hosts...

# assert ENV
[ -z "$SSH_PORT" ] && SSH_PORT="22"
[ -z "$SSH_USER" ] && echo "SSH_USER empty" && exit 1
[ -z "$SSH_PRIVATE_KEY" ] && echo "SSH_PRIVATE_KEY empty" && exit 1
[ -z "$SSH_HOSTKEYS" ] && echo "SSH_HOSTKEYS empty" && exit 1
[ -z "$SERVER_PATH" ] && echo "SERVER_PATH empty" && exit 1
[ -z "$WARMUP_SCRIPT" ] && echo "[INFO]: WARMUP_SCRIPT empty"
[ -z "$ACTIVATE_SCRIPT" ] && echo "[INFO]: ACTIVATE_SCRIPT empty"
[ $# -eq 0 ] && echo "No deploy target(s) -- Syntax: $0 host1 host2 host3 ..." && exit 1

ENV_CONFIG_FILE=$CI_PROJECT_DIR/.env

echo ">>> Starting ssh-agent"
# run ssh-agent in background
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")

echo ">>> Add remote host key to known_hosts"
mkdir -p ~/.ssh
echo "$SSH_HOSTKEYS" > ~/.ssh/known_hosts

echo ">>> Start Deployment..."

for SSH_HOST in "$@"
do
  echo ">>> Prepare dir: $SSH_HOST:$SERVER_PATH"
  ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "mkdir -p $SERVER_PATH" || exit 1

  echo ">>> Copy files to $SSH_HOST"
  scp -P$SSH_PORT -r $CI_PROJECT_DIR/* $SSH_USER@$SSH_HOST:$SERVER_PATH || exit 1

  echo ">>> Testing presence of (Laravel) Enviroment-Files files to $SSH_HOST"
  if [[ -f "$ENV_CONFIG_FILE" ]]; then  
    echo ">>> Copy (Laravel) Enviroment-Files files to $SSH_HOST"
    scp -P$SSH_PORT $ENV_CONFIG_FILE $SSH_USER@$SSH_HOST:$SERVER_PATH/. || exit 1
  else 
    echo " - $ENV_CONFIG_FILE existiert in diesem Projekt nicht"
  fi  

  if [[ ! -z "$WARMUP_SCRIPT" ]]; then
    echo ">>> Run script on remote host: $SSH_HOST > $WARMUP_SCRIPT"
    ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "$WARMUP_SCRIPT" || exit 1
  fi
done

if [[ ! -z "$ACTIVATE_SCRIPT" ]]; then
  echo ">>> Activate new version..."
  RESULT=0

  for SSH_HOST in "$@"
  do
    echo ">>> Run script on remote host: $SSH_HOST > $ACTIVATE_SCRIPT"
    ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "$ACTIVATE_SCRIPT" || RESULT=1
  done
fi

exit $RESULT
