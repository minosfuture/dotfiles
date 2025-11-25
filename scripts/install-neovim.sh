#!/bin/bash
# Install latest Neovim (nightly) based on CPU architecture
# Usage: ./install-neovim.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
step() { echo -e "${BLUE}==>${NC} $1"; }

# Detect CPU architecture
detect_arch() {
  local arch=$(uname -m)
  case "$arch" in
    x86_64 | amd64)
      echo "linux64"
      ;;
    aarch64 | arm64)
      echo "linux-arm64"
      ;;
    *)
      error "Unsupported architecture: $arch"
      error "Supported: x86_64, arm64"
      exit 1
      ;;
  esac
}

# Main installation
main() {
  step "Detecting CPU architecture"
  ARCH=$(detect_arch)
  info "Architecture: $ARCH"

  INSTALL_DIR="$HOME/.local"
  NVIM_DIR="$INSTALL_DIR/nvim-$ARCH"
  DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-$ARCH.tar.gz"
  TARBALL="/tmp/nvim-$ARCH.tar.gz"

  step "Downloading Neovim nightly for $ARCH"
  info "URL: $DOWNLOAD_URL"

  if ! curl -fLo "$TARBALL" "$DOWNLOAD_URL"; then
    error "Failed to download Neovim"
    exit 1
  fi

  step "Extracting Neovim"
  mkdir -p "$INSTALL_DIR"

  # Remove old installation if exists
  if [ -d "$NVIM_DIR" ]; then
    warn "Removing old Neovim installation: $NVIM_DIR"
    rm -rf "$NVIM_DIR"
  fi

  tar -xzf "$TARBALL" -C "$INSTALL_DIR"
  rm "$TARBALL"

  step "Setting up PATH"
  NVIM_BIN="$NVIM_DIR/bin"

  if [ ! -f "$NVIM_BIN/nvim" ]; then
    error "Neovim binary not found at $NVIM_BIN/nvim"
    exit 1
  fi

  info "Neovim installed to: $NVIM_DIR"
  info "Binary location: $NVIM_BIN/nvim"

  # Check if PATH is already in bashrc
  if ! grep -q "export PATH=.*nvim-.*bin" "$HOME/.bashrc" 2>/dev/null; then
    step "Adding to PATH in ~/.bashrc"
    echo "" >>"$HOME/.bashrc"
    echo "# Neovim nightly" >>"$HOME/.bashrc"
    echo "export PATH=\"$NVIM_BIN:\$PATH\"" >>"$HOME/.bashrc"
    info "Added Neovim to PATH in ~/.bashrc"
  else
    warn "Neovim PATH already in ~/.bashrc, skipping"
  fi

  # Make nvim available in current session
  export PATH="$NVIM_BIN:$PATH"

  step "Verifying installation"
  if command -v nvim &>/dev/null; then
    NVIM_VERSION=$(nvim --version | head -n1)
    info "✅ Success! $NVIM_VERSION"
    info "Run 'source ~/.bashrc' or restart your shell"
  else
    error "Neovim command not found. Please add $NVIM_BIN to your PATH manually"
    exit 1
  fi

  echo ""
  info "Installation complete!"
  echo "  • Location: $NVIM_DIR"
  echo "  • Binary:   $NVIM_BIN/nvim"
  echo "  • Reload:   source ~/.bashrc"
}

main "$@"
