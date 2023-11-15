#!/usr/bin/env bash

sudo apt update -y
sudo apt install -y ansible make python3-psutil just zsh build-essential

if ! [ -x "$(command -v ansible)" ]; then
  echo 'Error: ansible is not installed.' >&2
  exit 1
fi
if ! [ -x "$(command -v ansible-galaxy)" ]; then
  echo 'Error: ansible galaxy is not installed.' >&2
  exit 1
fi

ansible-galaxy install -r requirements.yml
