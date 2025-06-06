#!/bin/bash
# You can bootstrap a server with
# wget https://robertt-smg.github.io/ansible-bootstrap/b.sh && bash b.sh

SERVERNAME=${SERVERNAME:-$(hostname)}
DOMAIN=${DOMAIN:-smg-air-conaos.com}

if [ -f $SCRIPTPATH/bootstrap.sh ]; then
  source $SCRIPTPATH/bootstrap.sh
else
  if [ ! -f /tmp/bootstrap.sh ]; then
    echo "Bootstrap script not found. Downloading..."
    wget https://robertt-smg.github.io/ansible-bootstrap/bootstrap.sh -O /tmp/bootstrap.sh
  fi
  source /tmp/bootstrap.sh
fi

# Check if functions are defined before calling them
if declare -f add_host > /dev/null && declare -f add_ansible_user > /dev/null; then
  echo "Functions adding host settings ..."
  add_host
  echo "Functions adding ansible install user ..."
  add_ansible_user
else
  echo "Functions add_host and/or add_ansible_user are not defined. Bootsrap script not found or failed ..."
fi