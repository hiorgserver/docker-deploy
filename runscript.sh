#!/bin/bash

# Please export following variables:
# SSH_USER
# SSH_PORT
# SSH_PRIVATE_KEY
# SSH_HOSTKEYS (i.e. copied from your local ~/.ssh/known_hosts)
# REMOTE_SCRIPT
# ...and as CLI-parameter: $0 hosts...

# assert ENV
[ -z "$SSH_PORT" ] && SSH_PORT="22"
[ -z "$SSH_USER" ] && echo "SSH_USER empty" && exit 1
[ -z "$SSH_PRIVATE_KEY" ] && echo "SSH_PRIVATE_KEY empty" && exit 1
[ -z "$SSH_HOSTKEYS" ] && echo "SSH_HOSTKEYS empty" && exit 1
[ -z "$REMOTE_SCRIPT" ] && echo "REMOTE_SCRIPT empty" && exit 1

echo ">>> Starting ssh-agent"
# run ssh-agent in background
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")

echo ">>> Add remote host key to known_hosts"
mkdir -p ~/.ssh
echo "$SSH_HOSTKEYS" > ~/.ssh/known_hosts

RESULT=0

for SSH_HOST in "$@"
do
  echo ">>> Run script on remote host: $SSH_HOST > $REMOTE_SCRIPT"
  ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "$REMOTE_SCRIPT" || RESULT=1
done

exit $RESULT
