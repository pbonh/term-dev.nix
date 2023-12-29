#!/usr/bin/env bash

wget https://github.com/ownport/portable-ansible/releases/download/v0.5.0/portable-ansible-v0.5.0-py3.tar.bz2 -O ansible.tar.bz2
tar -xjf ansible.tar.bz2
python ansible localhost -m ping
if [[ ! -d "ansible" ]]; then
    for l in config console doc galaxy inventory playbook pull vault;do
      ln -s ansible ansible-$l
    done
fi
