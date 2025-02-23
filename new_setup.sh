#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting machine setup..."

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# 1. Install Homebrew (if not installed)
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Ensure Homebrew is added to the PATH
    if [[ -d "/opt/homebrew/bin" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# Confirm brew is available
if ! command_exists brew; then
    echo "Error: Homebrew installation failed!"
    exit 1
fi

# Update and upgrade Homebrew packages
echo "Updating and upgrading Homebrew packages..."
brew update && brew upgrade

# 2. Install iTerm2
if ! brew list --cask | grep -q iterm2; then
    echo "Installing iTerm2..."
    brew install --cask iterm2
else
    echo "iTerm2 is already installed."
fi

# 3. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# 4. Install Starship prompt
if ! command_exists starship; then
    echo "Installing Starship..."
    brew install starship
    echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
else
    echo "Starship is already installed."
fi

# 5. Install essential CLI tools
echo "Installing essential CLI tools..."
brew install git wget fzf tmux htop neovim

# 6. Install programming languages
echo "Installing programming languages..."
brew install python node

# Install Rust with rustup
if ! command_exists rustc; then
    echo "Installing Rust..."
    brew install rustup
    rustup default stable
else
    echo "Rust is already installed."
fi

# Install OCaml
if ! command_exists ocaml; then
    echo "Installing OCaml..."
    brew install ocaml opam
    opam init --disable-sandboxing -y
    eval "$(opam env)"
else
    echo "OCaml is already installed."
fi

# 7. Install useful applications
echo "Installing common applications..."
brew install --cask visual-studio-code rectangle spotify google-chrome slack

# 8. Ensure all configurations are loaded
echo "Reloading shell environment..."
exec zsh

echo "Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
