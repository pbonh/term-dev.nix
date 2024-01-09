#!/usr/bin/env bash

# Update System
sudo dnf update -y
sudo dnf upgrade -y

# Native Packages
sudo dnf groupinstall -y "Development Tools" "Development Libraries"
sudo dnf install -y python3-psutil ansible make git gcc-c++ xclip just distrobox

# Nix via Determinate Systems
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems

# Devbox
curl -fsSL https://get.jetpack.io/devbox | bash

# Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Useful Flatpaks
flatpak install flathub com.mattjakeman.ExtensionManager
flatpak install flathub com.bitwarden.desktop
flatpak install flathub com.visualstudio.code
flatpak install flathub org.mozilla.Thunderbird

# Brave(Native)
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo dnf install -y brave-browser
