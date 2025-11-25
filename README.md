# Portable Dotfiles Configuration

> Personal development environment for public clusters - Neovim (LazyVim) + Tmux + Bash + FZF

Portable dotfiles setup based on my personal configuration, stripped of all proprietary dependencies. Works on any public cluster without requiring special permissions.

## Quick Install

Install everything with a single command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/minosfuture/dotfiles/main/install.sh)
```

**Important**: Replace `minosfuture` with your actual GitHub username in:
- `install.sh` (line 16)
- This README

## What's Included

### 🚀 Neovim - LazyVim Configuration

Full LazyVim setup with 40+ carefully curated plugins for a modern IDE experience.

**Core Features**:
- **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) - Fast and modern
- **Framework**: [LazyVim](https://github.com/LazyVim/LazyVim) - Supercharged Neovim config
- **Color Scheme**: TokyoNight Storm with orange borders
- **Vi Mode**: Full modal editing workflow
- **No Clipboard**: Intentionally disabled for security
- **Relative Line Numbers**: Auto-toggle on insert/normal mode
- **2-Space Indentation**: Soft tab stop

**Key Plugins**:
- **Navigation**: [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Seamless tmux/vim pane switching with Ctrl+hjkl
- **Fuzzy Finding**: [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) + [telescope-fzf-native](https://github.com/nvim-telescope/telescope-fzf-native.nvim)
- **Syntax**: [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - AST-based highlighting
- **Completion**: [blink.cmp](https://github.com/saghen/blink.cmp) - Fast completion engine
- **LSP**: [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Language servers
- **Formatting**: [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) - Formatting and linting
- **Git Signs**: [vim-signify](https://github.com/mhinz/vim-signify) - VCS diff indicators
- **Symbols**: [vista.vim](https://github.com/liuchengxu/vista.vim) - Tag/symbol viewer
- **AI Assistant**: [sidekick.nvim](https://github.com/folke/sidekick.nvim) - AI coding assistant with tmux integration
- **UI**: [bufferline](https://github.com/akinsho/bufferline.nvim), [lualine](https://github.com/nvim-lualine/lualine.nvim), [notify](https://github.com/rcarriga/nvim-notify)
- **Snippets**: [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Flash**: [flash.nvim](https://github.com/folke/flash.nvim) - Enhanced navigation
- **Whitespace**: [vim-better-whitespace](https://github.com/ntpeters/vim-better-whitespace)

**Keybindings** (Leader = Space):
```
Space + p       Find files (Telescope)
Space + e       File explorer
Space + w/q     Save/Quit
Space + h       Switch header/source (C++)
Space + aa      Toggle AI assistant
Ctrl + hjkl     Navigate vim/tmux panes
Tab             Cycle through completions
```

### 🖥️  Tmux Configuration

Enhanced terminal multiplexer with vim integration.

**Features**:
- **500,000 Line History**: Never lose your output
- **Vim-Tmux Integration**: Ctrl+hjkl seamlessly navigates both vim and tmux panes
- **Vi Mode**: Vi keybindings in copy mode
- **Smart Windows**: New windows/panes open in current directory
- **Zero Escape Time**: Instant response for vim
- **256 Color Support**: Full color terminal
- **Custom Status Bar**: Shows hostname and timestamp

**Key Bindings**:
```
Ctrl + h/j/k/l      Navigate panes (vim-aware)
Ctrl + b + %        Horizontal split
Ctrl + b + "        Vertical split
Ctrl + b + c        New window
Ctrl + b + d        Detach session
```

### 💻 Bash Configuration

Rich shell environment with powerful aliases and functions.

**Features**:
- **Unlimited History**: 1,000,000 commands
- **Vi Mode**: Vi-style command line editing
- **FZF Integration**: Fuzzy finding everywhere
- **Custom Functions**: Productivity helpers
- **Git Shortcuts**: Quick git commands
- **Conditional Loading**: CUDA, Go, Rust support

**Custom Functions**:
```bash
pr_list [days] [author]       # List GitHub PRs
clean_cache                   # Clean vLLM/torch caches
clean_process                 # Kill Python/vLLM processes
vllm_profile_start [host]     # Start vLLM profiling
vllm_profile_stop [host]      # Stop vLLM profiling
wait_for_server [port]        # Wait for server health
lf [path]                     # List most recent file
show                          # Pipe to less with color
awk_param file delimiter      # Extract params with awk
```

**Aliases**:
```bash
vi=nvim
ll='ls -alF'        # Detailed list with file types
la='ls -A'          # List all except . and ..
l='ls -CF'          # Compact list with file types
le='less -R'        # Less with colors
gs='git status'
wait_vllm='wait_for_server'
stop_vllm='stop_server'
```

### 🔍 FZF Integration

Fuzzy finder for everything.

**Features**:
- Command history search (Ctrl+r)
- File finding with preview
- Directory navigation
- Git branch switching
- Customized preview windows

## Installation

### Prerequisites

**Required**:
- `git` - For cloning the repository

**Recommended**:
- `neovim` (v0.9+) - Text editor
- `tmux` (v3.0+) - Terminal multiplexer
- `make` - For building telescope-fzf-native
- `gcc` or `clang` - C compiler for native extensions

**Optional**:
- `gh` - GitHub CLI (for pr_list function)
- `fd` - Fast file finder (better than find)
- `rg` (ripgrep) - Fast grep (better than grep)
- `bat` - Better cat with syntax highlighting
- `tree` - Directory visualization
- `curl` - For API calls in helper functions

### Install Prerequisites

**Debian/Ubuntu**:
```bash
sudo apt update
sudo apt install git neovim tmux build-essential
```

**RHEL/CentOS/Rocky Linux**:
```bash
sudo yum install git neovim tmux gcc make
```

**Fedora**:
```bash
sudo dnf install git neovim tmux gcc make
```

### Run Installation

```bash
# One-line install (clones to ~/.dotfiles)
bash <(curl -fsSL https://raw.githubusercontent.com/minosfuture/dotfiles/main/install.sh)

# Install from custom directory
DOTFILES_DIR=/path/to/dotfiles bash <(curl -fsSL https://raw.githubusercontent.com/minosfuture/dotfiles/main/install.sh)

# Or clone first, then install locally
git clone https://github.com/minosfuture/dotfiles.git ~/my-dotfiles
cd ~/my-dotfiles
./install.sh --local

# Install from existing repo in current directory
./install.sh --local
```

**Installation modes**:
- **Default**: Clones repo to `~/.dotfiles`
- **Custom directory**: Set `DOTFILES_DIR` environment variable
- **Local install**: Use `--local` flag to install from current directory (no git clone)
- **Re-entrant**: Safe to run multiple times - skips existing symlinks, backs up changed files

The script will:
1. Check dependencies
2. **Offer to install Neovim nightly** if not found (optional)
3. Backup existing configurations
4. Install Neovim, Tmux, and Bash configs
5. Install FZF
6. Set up LazyVim (plugins auto-install on first nvim launch)

### Install Neovim Nightly (Optional)

If Neovim is not installed on your system, the installation script will offer to install the latest nightly build automatically. Alternatively, you can install it manually:

```bash
# Automatic (during main installation)
# The install.sh script will prompt you

# Manual installation
~/.dotfiles/scripts/install-neovim.sh
```

The script automatically detects your CPU architecture (x86_64 or arm64) and downloads the appropriate binary. Neovim will be installed to `~/.local/nvim-{arch}/` and added to your PATH.

**Supported architectures**:
- x86_64 / amd64 (Intel/AMD processors)
- aarch64 / arm64 (ARM processors, e.g., AWS Graviton, Apple M-series via Rosetta)

### First Launch

After installation:

```bash
# Reload your shell
source ~/.bashrc

# Start tmux
tmux

# Open neovim (LazyVim will auto-install plugins - takes 2-3 minutes)
nvim
```

**Note**: The first time you open Neovim, LazyVim will automatically download and install all plugins. This is normal and will take a few minutes.

## Configuration

### Directory Structure

```
~/.dotfiles/
├── nvim/
│   ├── init.lua                    # Main config
│   └── lua/
│       ├── config/
│       │   ├── autocmds.lua        # Auto commands
│       │   ├── keymaps.lua         # Key mappings
│       │   └── options.lua         # Vim options
│       └── plugins/
│           ├── cmp.lua             # Completion config
│           ├── coding.lua          # Coding plugins
│           ├── colorscheme.lua     # Theme config
│           ├── editor.lua          # Editor plugins
│           ├── flash.lua           # Flash navigation
│           ├── lsp.lua             # LSP configuration
│           ├── treesitter.lua      # Treesitter config
│           └── ui.lua              # UI plugins
├── tmux/
│   └── tmux.conf                   # Tmux configuration
├── bash/
│   └── bashrc                      # Bash configuration
├── scripts/
│   └── install-neovim.sh           # Neovim nightly installer
├── install.sh                      # Main installation script
└── README.md                       # This file
```

### Customization

**Local Overrides**: Create `~/.bashrc.local` for machine-specific bash customizations:
```bash
# ~/.bashrc.local
export MY_CUSTOM_VAR="value"
alias my_alias="command"
```

**Neovim Plugins**: Edit `~/.config/nvim/lua/plugins/*.lua` to add/remove plugins.

**Tmux**: Edit `~/.tmux.conf` and reload with `tmux source ~/.tmux.conf`.

## Updating

### Update Dotfiles
```bash
cd ~/.dotfiles
git pull
source ~/.bashrc
tmux source ~/.tmux.conf  # If in tmux
```

### Update Neovim Plugins
Inside Neovim:
```vim
:Lazy sync
```

### Update FZF
```bash
cd ~/.fzf
git pull
./install --key-bindings --completion --no-update-rc
```

## Key Differences from Work Setup

What's preserved:
- ✅ Full LazyVim framework with all plugins
- ✅ TokyoNight Storm theme with orange borders
- ✅ Vim-tmux-navigator integration
- ✅ All custom functions and aliases
- ✅ Vi mode everywhere
- ✅ FZF integration
- ✅ Rust/Cargo and Go environment setup
- ✅ All keybindings and preferences

## Troubleshooting

### Neovim: Plugins not installing
```bash
# Inside nvim
:Lazy restore
:Lazy sync
```

### Tmux: Ctrl+hjkl not working
Make sure you installed the vim-tmux-navigator plugin. Check `:checkhealth` in nvim.

### Bash: FZF not working
```bash
~/.fzf/install --key-bindings --completion --no-update-rc
source ~/.bashrc
```

### LSP: Language server not working
Install the language server for your language. Inside nvim:
```vim
:Mason
```
Then install the server you need.

### Build errors for telescope-fzf-native
Make sure you have `make` and `gcc`/`clang` installed:
```bash
sudo apt install build-essential  # Debian/Ubuntu
sudo yum install gcc make          # RHEL/CentOS
```

## Backup and Restore

The install script automatically creates backups in `~/.dotfiles_backup_YYYYMMDD_HHMMSS/`.

To restore:
```bash
# Find your backup
ls -la ~ | grep dotfiles_backup

# Restore specific files
cp ~/.dotfiles_backup_*/nvim ~/.config/ -r
cp ~/.dotfiles_backup_*/bashrc ~/.bashrc
cp ~/.dotfiles_backup_*/tmux.conf ~/.tmux.conf
```

## Uninstallation

```bash
# Remove installed configs
rm -rf ~/.config/nvim
rm ~/.tmux.conf
rm ~/.bashrc  # Be careful! You may want to restore backup instead

# Remove FZF
rm -rf ~/.fzf

# Remove dotfiles repo
rm -rf ~/.dotfiles

# Restore from backup
cp ~/.dotfiles_backup_*/bashrc ~/.bashrc
# ... restore other files as needed
```

## Tips for Public Clusters

1. **No sudo required** - Everything installs in your home directory
2. **Portable** - Works on any Linux system with git, nvim, tmux
3. **Fast** - LazyVim optimized for performance
4. **Shareable** - Easy to replicate on multiple machines
5. **Safe** - All existing configs are backed up before installation

## Contributing

Feel free to fork and customize! This is a personal configuration meant to be adapted to your needs.

## License

MIT License - Use freely

## Author

Personal dotfiles for productive terminal work on public clusters

---

**Happy Coding!** 🚀
