#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting machine setup..."

# 1. Install Homebrew (if not installed)
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed"
fi

# Update and upgrade Homebrew packages
brew update && brew upgrade

# 2. Install iTerm2
echo "Installing iTerm2..."
brew install --cask iterm2

# 3. Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed"
fi

# 4. Install Starship prompt
if ! command -v starship &>/dev/null; then
    echo "Installing Starship..."
    brew install starship
    echo 'eval "$(starship init zsh)"' >>~/.zshrc
else
    echo "Starship already installed"
fi

# 5. Install essential CLI tools
echo "Installing essential CLI tools..."
brew install git wget fzf tmux htop neovim

# 6. Install programming languages
echo "Installing programming languages..."
brew install python node

# Install Rust with rustup
if ! command -v rustc &>/dev/null; then
    echo "Installing Rust..."
    brew install rustup
    rustup default stable
else
    echo "Rust is already installed"
fi

# Install OCaml
if ! command -v ocaml &>/dev/null; then
    echo "Installing OCaml..."
    brew install ocaml opam
    opam init --disable-sandboxing -y
    eval "$(opam env)"
else
    echo "OCaml is already installed"
fi

# 7. Install useful applications
echo "Installing common applications..."
brew install --cask visual-studio-code rectangle spotify google-chrome slack

# 8. Set up macOS preferences (optional)
# echo "Configuring macOS defaults..."
# defaults write com.apple.dock autohide -bool true
# defaults write com.apple.finder ShowPathbar -bool true
# defaults write NSGlobalDomain AppleShowAllFiles -bool true
# killall Dock Finder

echo "Setup complete! Restart your terminal or run 'exec zsh' to apply changes."
