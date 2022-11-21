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
  ansible-playbook dotfiles.yml --ask-become-pass

nix-tools: update-submodules
  ansible-playbook dotfiles.yml --tags "tools" --skip-tags "dependencies"

nix-dot: update-submodules
  ansible-playbook dotfiles.yml --tags "dot" --skip-tags "dependencies"

nix-dot-neovim: update-submodules
  ansible-playbook dotfiles.yml --tags "dot,neovim" --skip-tags "dependencies,git,shell,zellij,tmux,ranger,helix,broot,bookmarks,direnv,joplin"

nix-dot-helix: update-submodules
  ansible-playbook dotfiles.yml --tags "dot,helix" --skip-tags "dependencies,git,shell,zellij,tmux,ranger,neovim,broot,bookmarks,direnv,joplin"

nix-dot-zellij: update-submodules
  ansible-playbook dotfiles.yml --tags "dot,zellij" --skip-tags "dependencies,neovim,shell"

nix-binscripts: update-submodules
  ansible-playbook dotfiles.yml --tags "scripts" --skip-tags "dependencies"

nix-cpp: update-submodules
  ansible-playbook dotfiles.yml --tags "cpp" --skip-tags "dependencies" --ask-become-pass

nix-project-dev: update-submodules
  ansible-playbook dotfiles.yml --ask-become-pass --skip-tags "dependencies" --ask-become-pass

nix-rust: update-submodules
  ansible-playbook dotfiles.yml --tags "rust" --skip-tags "dependencies" --ask-become-pass

add-nix-dot-repo:
  git remote add -f dotfiles-nix git@github.com:pbonh/dotfiles.nix.git
  git subtree add --prefix roles/dotfiles dotfiles-nix main --squash

pull-nix-dot-repo:
  git fetch dotfiles-nix main && git subtree pull --prefix roles/dotfiles dotfiles-nix main --squash

push-nix-dot-repo:
  git subtree push --prefix=roles/dotfiles dotfiles-nix master

neovim-packer-sync:
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
