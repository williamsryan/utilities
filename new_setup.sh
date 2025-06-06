#!/usr/bin/env bash

# Interactive Mac Setup Script
# A clean, user-friendly script to set up a new Mac with essential development tools

set -e

# Colors for better output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Logging function with timestamps
log() {
    echo -e "${CYAN}[$(date '+%H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to add line to file if it doesn't exist
add_to_file_if_not_exists() {
    local line="$1"
    local file="$2"
    if ! grep -Fxq "$line" "$file" 2>/dev/null; then
        echo "$line" >> "$file"
        success "Added configuration to $file"
    else
        info "Configuration already exists in $file"
    fi
}

# Display header
display_header() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
╔══════════════════════════════════════════════════════════════════════════════╗
║                        🚀 Mac Development Setup                              ║
║                                                                              ║
║           A clean, interactive way to set up your development environment    ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo
}

# Show menu and get user choice
show_menu() {
    echo -e "${WHITE}What would you like to install?${NC}"
    echo
    echo -e "${CYAN}Essential Tools:${NC}"
    echo "  1) 🍺 Homebrew Package Manager"
    echo "  2) 💻 Terminal Setup (iTerm2 + Oh My Zsh + Starship)"
    echo "  3) 🛠  Essential CLI Tools"
    echo
    echo -e "${CYAN}Programming Languages:${NC}"
    echo "  4) 🐍 Python Development"
    echo "  5) 📦 Node.js Development"
    echo "  6) 🦀 Rust Development"
    echo "  7) 🐪 OCaml Development"
    echo
    echo -e "${CYAN}Applications:${NC}"
    echo "  8) 📱 Essential Apps (VS Code, Chrome, etc.)"
    echo "  9) 🎵 Media & Communication (Spotify, Slack)"
    echo " 10) 🐳 Development Tools (Docker, Postman)"
    echo
    echo -e "${CYAN}Batch Options:${NC}"
    echo " 11) ⚡ Quick Setup (Homebrew + Terminal + CLI Tools)"
    echo " 12) 🎯 Full Developer Setup (Everything except media)"
    echo " 13) 🌟 Complete Setup (Everything)"
    echo
    echo -e "${CYAN}Other:${NC}"
    echo " 14) 📋 Generate Brewfile for current setup"
    echo "  0) ❌ Exit"
    echo
}

# Install Homebrew
install_homebrew() {
    log "Setting up Homebrew..."
    
    if command_exists brew; then
        success "Homebrew is already installed"
        log "Updating Homebrew..."
        brew update && brew upgrade
        success "Homebrew updated successfully"
        return 0
    fi

    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ -d "/opt/homebrew/bin" ]]; then
        add_to_file_if_not_exists 'eval "$(/opt/homebrew/bin/brew shellenv)"' "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
        add_to_file_if_not_exists 'eval "$(/usr/local/bin/brew shellenv)"' "$HOME/.zprofile"
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    if command_exists brew; then
        success "Homebrew installed successfully"
    else
        error "Homebrew installation failed!"
        exit 1
    fi
}

# Terminal setup
setup_terminal() {
    log "Setting up terminal environment..."
    
    # Install iTerm2
    if ! brew list --cask iterm2 &>/dev/null; then
        log "Installing iTerm2..."
        brew install --cask iterm2
        success "iTerm2 installed"
    else
        success "iTerm2 is already installed"
    fi

    # Install Oh My Zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        log "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        success "Oh My Zsh installed"
    else
        success "Oh My Zsh is already installed"
    fi

    # Install Starship
    if ! command_exists starship; then
        log "Installing Starship prompt..."
        brew install starship
        add_to_file_if_not_exists 'eval "$(starship init zsh)"' "$HOME/.zshrc"
        success "Starship installed and configured"
    else
        success "Starship is already installed"
    fi
}

# Essential CLI tools
install_cli_tools() {
    log "Installing essential CLI tools..."
    
    local tools=(
        "git"
        "wget" 
        "curl"
        "fzf"
        "tmux"
        "htop" 
        "neovim"
        "jq"
        "ripgrep"
        "bat"
        "exa"
        "fd"
        "tree"
    )
    
    for tool in "${tools[@]}"; do
        if ! command_exists "$tool"; then
            log "Installing $tool..."
            brew install "$tool"
        else
            info "$tool is already installed"
        fi
    done
    
    # Set up fzf key bindings
    if command_exists fzf; then
        log "Setting up fzf shell integration..."
        "$(brew --prefix)"/opt/fzf/install --all --no-bash --no-fish
        success "fzf configured with shell integration"
    fi
    
    success "CLI tools installation complete"
}

# Programming language installations
install_python() {
    log "Setting up Python development environment..."
    
    if ! command_exists python3; then
        brew install python
        success "Python installed"
    else
        success "Python is already installed"
    fi
    
    # Install pipx for global Python packages
    if ! command_exists pipx; then
        log "Installing pipx..."
        brew install pipx
        pipx ensurepath
        success "pipx installed"
    fi
}

install_nodejs() {
    log "Setting up Node.js development environment..."
    
    if ! command_exists node; then
        brew install node
        success "Node.js installed"
    else
        success "Node.js is already installed"
    fi
    
    # Install useful global packages
    if command_exists npm; then
        log "Installing global npm packages..."
        npm install -g yarn pnpm typescript ts-node
        success "Global npm packages installed"
    fi
}

install_rust() {
    log "Setting up Rust development environment..."
    
    if ! command_exists rustc; then
        log "Installing Rust..."
        brew install rustup-init
        rustup-init -y --default-toolchain stable
        source "$HOME/.cargo/env"
        success "Rust installed"
    else
        success "Rust is already installed"
    fi
}

install_ocaml() {
    log "Setting up OCaml development environment..."
    
    if ! command_exists ocaml; then
        log "Installing OCaml..."
        brew install ocaml opam
        opam init --disable-sandboxing -y
        eval "$(opam env)"
        success "OCaml installed"
    else
        success "OCaml is already installed"
    fi
}

# Application installations
install_essential_apps() {
    log "Installing essential applications..."
    
    local apps=(
        "visual-studio-code"
        "google-chrome"
        "rectangle"
        "the-unarchiver"
    )
    
    for app in "${apps[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            log "Installing $app..."
            brew install --cask "$app"
        else
            info "$app is already installed"
        fi
    done
    
    success "Essential applications installed"
}

install_media_apps() {
    log "Installing media & communication applications..."
    
    local apps=(
        "spotify"
        "slack"
        "discord"
        "zoom"
    )
    
    for app in "${apps[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            log "Installing $app..."
            brew install --cask "$app"
        else
            info "$app is already installed"
        fi
    done
    
    success "Media & communication applications installed"
}

install_dev_tools() {
    log "Installing development tools..."
    
    local apps=(
        "docker"
        "postman"
        "figma"
        "github"
    )
    
    for app in "${apps[@]}"; do
        if ! brew list --cask "$app" &>/dev/null; then
            log "Installing $app..."
            brew install --cask "$app"
        else
            info "$app is already installed"
        fi
    done
    
    success "Development tools installed"
}

# Generate Brewfile
generate_brewfile() {
    log "Generating Brewfile from current installation..."
    
    if command_exists brew; then
        brew bundle dump --file="$HOME/Brewfile" --force
        success "Brewfile generated at $HOME/Brewfile"
        info "You can use 'brew bundle install' to install these packages on another machine"
    else
        error "Homebrew is not installed"
    fi
}

# Batch installation functions
quick_setup() {
    install_homebrew
    setup_terminal
    install_cli_tools
}

full_developer_setup() {
    install_homebrew
    setup_terminal
    install_cli_tools
    install_python
    install_nodejs
    install_rust
    install_essential_apps
    install_dev_tools
}

complete_setup() {
    install_homebrew
    setup_terminal
    install_cli_tools
    install_python
    install_nodejs
    install_rust
    install_ocaml
    install_essential_apps
    install_media_apps
    install_dev_tools
}

# Main execution loop
main() {
    display_header
    
    while true; do
        show_menu
        echo -n -e "${WHITE}Enter your choice [0-14]: ${NC}"
        read -r choice
        echo
        
        case $choice in
            1) install_homebrew ;;
            2) setup_terminal ;;
            3) install_cli_tools ;;
            4) install_python ;;
            5) install_nodejs ;;
            6) install_rust ;;
            7) install_ocaml ;;
            8) install_essential_apps ;;
            9) install_media_apps ;;
            10) install_dev_tools ;;
            11) quick_setup ;;
            12) full_developer_setup ;;
            13) complete_setup ;;
            14) generate_brewfile ;;
            0) 
                echo -e "${GREEN}Thanks for using Mac Setup! 🎉${NC}"
                echo -e "${YELLOW}Remember to restart your terminal or run 'exec zsh' to apply all changes.${NC}"
                exit 0
                ;;
            *)
                error "Invalid option. Please choose a number between 0-14."
                ;;
        esac
        
        echo
        echo -e "${GREEN}Task completed!${NC}"
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read -r
        echo
    done
}

# Run the script
main
