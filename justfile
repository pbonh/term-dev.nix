set dotenv-load := true
set shell := ["/bin/bash", "-cu"]

task_prelude := env_var_or_default('DOTFILES_TASK_PRELUDE', '')
playbook_selection := if os() == "macos" { ".macos" } else { ".nix" }

default:
  @just --choose

install-requirements:
  {{ task_prelude }} ansible-galaxy install -r requirements.yml
  {{ task_prelude }} ansible-galaxy collection install -r requirements.yml

init-submodules:
  git submodule update --recursive --init

update-submodules:
  git submodule update --recursive --remote

reset-submodules:
  git submodule foreach --recursive git reset --hard

devbox:
  {{ task_prelude }} ansible-playbook playbooks/devbox.yml --tags "core"

devbox-all:
  {{ task_prelude }} ansible-playbook playbooks/devbox.yml

baremetal:
  {{ task_prelude }} ansible-playbook playbooks/baremetal.yml

work tag:
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "{{ tag }}"

dot-all:
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml

tools: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "tools"

setup:
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "setup"

nix:
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "nix"

dot: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "git,fzf,neovim-config,navi,direnv,scripts,bookmarks,bash,nushell,zsh,zellij"

env: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "env"

git:
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "git"

shell: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "navi,scripts,bookmarks,bash,nushell,zsh,tcsh"

zsh: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "zsh"

neovim: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "neovim-config"

helix: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "helix-config"

zellij: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "zellij"

yazi: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "yazi"

binscripts: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "scripts"

cpp: update-submodules
  {{ task_prelude }} ansible-playbook playbooks/dotfiles.yml --tags "cpp" --ask-become-pass

update-rust-tools:
  {{ task_prelude }} cargo install-update -a

install-rust-tools:
  {{ task_prelude }} ansible-playbook playbooks/baremetal.yml --tags "rust-tools"

add-nix-devbox-repo:
  git remote add -f devbox-nix git@github.com:pbonh/devbox.nix.git
  git subtree add --prefix roles/devbox devbox-nix main --squash

add-nix-baremetal-repo:
  git remote add -f baremetal-nix git@github.com:pbonh/baremetal.nix.git
  git subtree add --prefix roles/baremetal baremetal-nix main --squash

add-nix-dot-repo:
  git remote add -f dotfiles-nix git@github.com:pbonh/dotfiles.nix.git
  git subtree add --prefix roles/dotfiles dotfiles-nix main --squash

pull-nix-dot-repo:
  git fetch dotfiles-nix main && git subtree pull --prefix roles/dotfiles dotfiles-nix main --squash

pull-nix-devbox-repo:
  git fetch devbox-nix main && git subtree pull --prefix roles/devbox devbox-nix main --squash

pull-nix-baremetal-repo:
  git fetch baremetal-nix main && git subtree pull --prefix roles/baremetal baremetal-nix main --squash

push-nix-devbox-repo:
  git subtree push --prefix=roles/devbox devbox-nix main

push-nix-baremetal-repo:
  git subtree push --prefix=roles/baremetal baremetal-nix main

push-nix-dot-repo:
  git subtree push --prefix=roles/dotfiles dotfiles-nix main

bluefin:
  ./scripts/bootstrap_gitssh.sh
  ./scripts/bootstrap_bluefin.sh
