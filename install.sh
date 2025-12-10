#!/bin/bash
# Portable dotfiles installation script for public clusters
# This script installs your personal neovim, tmux, and bash configurations
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/minosfuture/dotfiles/main/install.sh)
# Usage with custom directory: DOTFILES_DIR=/path/to/dotfiles ./install.sh
# Usage from existing repo: ./install.sh --local

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
LOCAL_INSTALL=false
if [ "$1" = "--local" ] || [ "$1" = "-l" ]; then
  LOCAL_INSTALL=true
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

# Configuration
DOTFILES_REPO="https://github.com/minosfuture/dotfiles.git"
# Allow DOTFILES_DIR to be set via environment variable or use default
if [ "$LOCAL_INSTALL" = true ]; then
  DOTFILES_DIR="${DOTFILES_DIR:-$SCRIPT_DIR}"
else
  DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
fi
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Logging functions
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
step() { echo -e "${BLUE}==>${NC} $1"; }

# Safe symlink creation (re-entrant)
safe_symlink() {
  local source=$1
  local target=$2

  # Check if target already exists
  if [ -e "$target" ] || [ -L "$target" ]; then
    # If it's already a symlink pointing to the right place, skip
    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
      info "Symlink already exists and is correct: $target → $source"
      return 0
    fi

    # Otherwise, back it up and remove it
    warn "Removing existing file/symlink: $target"
    backup_file "$target"
    rm -rf "$target"
  fi

  # Create the symlink
  ln -s "$source" "$target"
  info "Created symlink: $target → $source"
}

# Print banner
print_banner() {
  echo ""
  echo -e "${BLUE}╔════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║      Portable Dotfiles Installation Script        ║${NC}"
  echo -e "${BLUE}║   Neovim + Tmux + Bash + FZF Configuration         ║${NC}"
  echo -e "${BLUE}╚════════════════════════════════════════════════════╝${NC}"
  echo ""
}

# Create backup directory
create_backup() {
  # Only create if we actually need to backup something
  if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
  fi
}

# Backup existing config
backup_file() {
  local file=$1
  if [ -e "$file" ] || [ -L "$file" ]; then
    create_backup
    info "Backing up: $file"
    if [ -d "$file" ] && [ ! -L "$file" ]; then
      cp -r "$file" "$BACKUP_DIR/" 2>/dev/null || true
    else
      cp -P "$file" "$BACKUP_DIR/" 2>/dev/null || true
    fi
  fi
}

# Clone or update dotfiles repository
clone_dotfiles() {
  if [ "$LOCAL_INSTALL" = true ]; then
    step "Using local dotfiles directory"
    info "Directory: $DOTFILES_DIR"
    return
  fi

  step "Setting up dotfiles repository"
  if [ -d "$DOTFILES_DIR" ]; then
    warn "Dotfiles directory already exists. Updating..."
    cd "$DOTFILES_DIR" && git pull
  else
    info "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

# Install neovim configuration
install_nvim_config() {
  step "Installing Neovim configuration (LazyVim)"

  local nvim_config_dir="$HOME/.config/nvim"
  local nvim_link="$nvim_config_dir"

  # Create parent directory
  mkdir -p "$(dirname "$nvim_config_dir")"

  # Use safe_symlink to create or update the symlink
  safe_symlink "$DOTFILES_DIR/nvim" "$nvim_link"

  # Create necessary directories
  mkdir -p "$HOME/.local/share/nvim/lazy"

  info "Neovim configuration installed!"
  info "LazyVim will auto-install plugins on first run"
}

# Install tmux configuration
install_tmux_config() {
  step "Installing Tmux configuration"

  safe_symlink "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

  info "Tmux configuration installed!"
  info "Run 'tmux source ~/.tmux.conf' to reload config in existing sessions"
}

# Install bashrc
install_bashrc() {
  step "Installing Bash configuration"

  safe_symlink "$DOTFILES_DIR/bash/bashrc" "$HOME/.bashrc"
  cp /home/ubuntu/.bashrc $HOME/.bashrc.local

  info "Bashrc installed!"
  info "Run 'source ~/.bashrc' to reload in current shell"
}

# Install FZF
install_fzf() {
  step "Installing FZF (fuzzy finder)"

  if [ -d "$HOME/.fzf" ]; then
    warn "FZF already installed. Skipping..."
    return
  fi

  info "Cloning FZF repository..."
  git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"

  info "Running FZF installer..."
  "$HOME/.fzf/install" --key-bindings --completion --no-update-rc

  info "FZF installed!"
}

install_git() {
  step "Installing git"
  sudo apt install git -y
  safe_symlink "$DOTFILES_DIR/gitconfig" "$HOME/.bashrc"
}

# Install Neovim nightly
install_neovim() {
  step "Installing Neovim nightly"

  if [ ! -f "$DOTFILES_DIR/scripts/install-neovim.sh" ]; then
    error "Neovim installation script not found"
    return 1
  fi

  bash "$DOTFILES_DIR/scripts/install-neovim.sh"
}

install_hf_cache() {
  sudo mkdir /data/numa0/ming_hf_cache
  sudo chown 1080:1080 /data/numa0/ming_hf_cache
}

# Check for required tools
check_dependencies() {
  step "Checking dependencies"

  local missing_deps=()
  local missing_optional=()

  # Required
  if ! command -v git &>/dev/null; then
    missing_deps+=("git")
  fi

  # Optional but recommended
  if ! command -v nvim &>/dev/null; then
    missing_optional+=("neovim")
  fi

  if ! command -v tmux &>/dev/null; then
    missing_optional+=("tmux")
  fi

  if ! command -v make &>/dev/null; then
    missing_optional+=("make")
  fi

  if ! command -v gcc &>/dev/null && ! command -v clang &>/dev/null; then
    missing_optional+=("gcc or clang")
  fi

  # Handle required dependencies
  if [ ${#missing_deps[@]} -ne 0 ]; then
    error "Missing required dependencies: ${missing_deps[*]}"
    error "Please install them before continuing."
    echo ""
    echo "Installation commands:"
    echo "  Debian/Ubuntu: sudo apt install ${missing_deps[*]}"
    echo "  RHEL/CentOS:   sudo yum install ${missing_deps[*]}"
    echo "  Fedora:        sudo dnf install ${missing_deps[*]}"
    exit 1
  fi

  # Handle optional dependencies
  if [ ${#missing_optional[@]} -ne 0 ]; then
    warn "Optional dependencies not found: ${missing_optional[*]}"

    if [[ " ${missing_optional[*]} " =~ " tmux " ]]; then
      echo ""
      warn "Tmux not found. Installing"
      sudo apt update && sudo apt install tmux just -y
    fi

    # Offer to install neovim if missing
    if [[ " ${missing_optional[*]} " =~ " neovim " ]]; then
      echo ""
      warn "Neovim not found. We can install the latest nightly build for you."
      read -p "Install Neovim nightly? (y/N) " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        INSTALL_NVIM=true
      fi
    fi

    warn "Install them for the full experience:"
    echo ""
    echo "  Debian/Ubuntu: sudo apt install neovim tmux build-essential"
    echo "  RHEL/CentOS:   sudo yum install neovim tmux gcc make"
    echo "  Fedora:        sudo dnf install neovim tmux gcc make"
    echo ""

    if [ "$INSTALL_NVIM" != "true" ]; then
      read -p "Continue anyway? (y/N) " -n 1 -r
      echo
      if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
      fi
    fi
  fi

  info "All required dependencies found!"
}

# Print summary
print_summary() {
  echo ""
  echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║           Installation Complete! 🎉                 ║${NC}"
  echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
  echo ""

  info "Configuration files installed:"
  echo "  • Dotfiles: $DOTFILES_DIR"
  echo "  • Neovim:   ~/.config/nvim/ → $DOTFILES_DIR/nvim"
  echo "  • Tmux:     ~/.tmux.conf → $DOTFILES_DIR/tmux/tmux.conf"
  echo "  • Bash:     ~/.bashrc → $DOTFILES_DIR/bash/bashrc"
  echo "  • FZF:      ~/.fzf/"
  echo ""

  if [ -d "$BACKUP_DIR" ]; then
    info "Backup location: $BACKUP_DIR"
    echo ""
  fi

  echo -e "${BLUE}Next steps:${NC}"
  echo "  1. Reload your shell:"
  echo "     ${GREEN}source ~/.bashrc${NC}"
  echo ""
  echo "  2. Start tmux:"
  echo "     ${GREEN}tmux${NC}"
  echo ""
  echo "  3. Open neovim (plugins will auto-install on first run):"
  echo "     ${GREEN}nvim${NC}"
  echo ""

  echo -e "${YELLOW}Note:${NC} LazyVim plugins will be installed automatically"
  echo "      the first time you open Neovim. This may take a few minutes."
  echo ""

  echo -e "${BLUE}Useful commands:${NC}"
  echo "  • Update dotfiles:  cd ~/.dotfiles && git pull"
  echo "  • Neovim plugins:   :Lazy (inside nvim)"
  echo "  • Tmux reload:      tmux source ~/.tmux.conf"
  echo ""

  echo "Happy coding! 🚀"
  echo ""
}

# Main installation
main() {
  print_banner

  check_dependencies
  clone_dotfiles

  # Install neovim if user opted in
  if [ "$INSTALL_NVIM" = "true" ]; then
    install_neovim
  fi

  install_nvim_config
  install_tmux_config
  install_bashrc
  install_fzf
  install_hf_cache

  print_summary
}

# Run main function
main "$@"
