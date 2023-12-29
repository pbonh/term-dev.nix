#!/usr/bin/env bash
#
# README ======================================
#  # Run FIRST
#  ```
#  just devmode
#  refresh-global
#  systemctl reboot
#  ```
# =============================================

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Nix
if ! command_exists nix; then
    just nix-install
    refresh-global
fi

# Install Devbox
if ! command_exists devbox; then
    just devbox-install
    refresh-global
    just nix-devbox
    refresh-global
    just nix-devbox-global
    refresh-global
fi

# Install Fleek
if ! command_exists fleek; then
    just fleek-install
    refresh-global
fi

# Function to ensure necessary commands are available
ensure_commands() {
    local missing_cmds=()

    # Check for git and ghq
    if ! command_exists nix; then
        missing_cmds+=("nix")
    fi
    if ! command_exists devbox; then
        missing_cmds+=("devbox")
    fi
    if ! command_exists fleek; then
        missing_cmds+=("fleek")
    fi

    # Handle missing commands
    if [ ${#missing_cmds[@]} -ne 0 ]; then
        echo "The following commands are not available but are required: ${missing_cmds[*]}"
        echo "Please install them and rerun the script."
        exit 1
    fi
}

# Check if necessary commands are available
ensure_commands

