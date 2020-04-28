#!/bin/bash

# Please export following variables:
# SSH_USER
# SSH_PORT
# SSH_PRIVATE_KEY
# SSH_HOSTKEYS (i.e. copied from your local ~/.ssh/known_hosts)
# ...and as CLI-parameter: $0 /path/to/skript-on-remote-host PROD|TEST commit_sha hosts...

echo ">>> Starting ssh-agent"
# run ssh-agent in background
eval $(ssh-agent -s)
ssh-add <(echo "$SSH_PRIVATE_KEY")

echo ">>> Add remote host key to known_hosts"
mkdir -p ~/.ssh
echo "$SSH_HOSTKEYS" > ~/.ssh/known_hosts

SKRIPT="$1 $2 $3"
shift 3

result=0

for SSH_HOST in "$@"
do
  echo ">>> Start deployment on remote host: $SSH_HOST > $SKRIPT"
  ssh -p$SSH_PORT $SSH_USER@$SSH_HOST "$SKRIPT" || result=1
done

exit $result