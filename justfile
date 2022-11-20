set dotenv-load := true
set shell := ["/usr/bin/bash", "-cu"]
export BASH_ENV := "$HOME/.nix-profile/etc/profile.d/nix.sh"

default:
  @just --list

install-requirements:
  ansible-galaxy install -r requirements.yml && ansible-galaxy collection install -r requirements.yml

init-submodules:
  git submodule update --recursive --init

update-submodules:
  git submodule update --recursive --remote

reset-submodules:
  git submodule foreach --recursive git reset --hard

nix-all:
  ansible-playbook playbooks/workstation.nix.yml --ask-become-pass

nix-tools: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "tools" --skip-tags "dependencies"

nix-dot: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "dot" --skip-tags "dependencies"

nix-dot-neovim: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "dot,neovim" --skip-tags "dependencies,git,shell,zellij,tmux,ranger,helix,broot,bookmarks,direnv,joplin"

nix-dot-helix: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "dot,helix" --skip-tags "dependencies,git,shell,zellij,tmux,ranger,neovim,broot,bookmarks,direnv,joplin"

nix-dot-zellij: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "dot,zellij" --skip-tags "dependencies,neovim,shell"

nix-binscripts: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "scripts" --skip-tags "dependencies"

nix-cpp: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "cpp" --skip-tags "dependencies" --ask-become-pass

nix-project-dev: update-submodules
  ansible-playbook playbooks/project-dev.yml --ask-become-pass --skip-tags "dependencies" --ask-become-pass

nix-rust: update-submodules
  ansible-playbook playbooks/workstation.nix.yml --tags "rust" --skip-tags "dependencies" --ask-become-pass

neovim-packer-sync:
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
