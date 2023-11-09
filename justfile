set dotenv-load := true
set shell := ["/bin/bash", "-cu"]

task_prelude := env_var_or_default('DOTFILES_TASK_PRELUDE', '')
playbook_selection := if os() == "macos" { ".macos" } else { ".nix" }

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

all:
  ansible-playbook dotfiles.yml --ask-become-pass

tools: update-submodules
  ansible-playbook dotfiles.yml --tags "tools" --skip-tags "dependencies"

dot: update-submodules
  ansible-playbook dotfiles.yml --tags "dot"

dot-neovim: update-submodules
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "neovim-config"

dot-helix: update-submodules
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "helix"

dot-zellij: update-submodules
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "zellij"

binscripts: update-submodules
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "scripts"

cpp: update-submodules
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "cpp" --ask-become-pass

rust: update-submodules
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "rust"

update-rust-tools:
  {{ task_prelude }} cargo install-update -a

install-rust-tools:
  {{ task_prelude }} ansible-playbook dotfiles.yml --tags "rust-tools"

add-nix-dot-repo:
  git remote add -f dotfiles-nix git@github.com:pbonh/dotfiles.nix.git
  git subtree add --prefix roles/dotfiles dotfiles-nix main --squash

pull-nix-dot-repo:
  git fetch dotfiles-nix main && git subtree pull --prefix roles/dotfiles dotfiles-nix main --squash

push-nix-dot-repo:
  git subtree push --prefix=roles/dotfiles dotfiles-nix main

neovim-packer-sync:
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
