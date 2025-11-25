# Setup Instructions

Follow these steps to get your dotfiles repository ready and create a gist for easy installation.

## Step 1: Update the Installation Script

Edit `install.sh` and replace `YOUR_USERNAME` with your actual GitHub username:

```bash
# Line 17 in install.sh
DOTFILES_REPO="https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git"
```

## Step 2: Push to GitHub

```bash
# Initialize and commit all files
git add -A
git commit -m "Initial dotfiles setup for public clusters"

# Create a new repository on GitHub named 'dotfiles'
# Then push to GitHub
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/dotfiles.git
git branch -M main
git push -u origin main
```

## Step 3: Test the Installation

On a test machine or different directory:

```bash
# Test the installation script
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/dotfiles/main/install.sh)
```

## Step 4: Create a Gist (Optional)

If you want a shorter URL, create a gist:

1. Go to https://gist.github.com
2. Create a new gist named `install.sh`
3. Copy the contents of your `install.sh` file
4. Make it public
5. Create the gist

Then you can use:
```bash
bash <(curl -fsSL https://gist.githubusercontent.com/YOUR_USERNAME/GIST_ID/raw/install.sh)
```

## One-Line Installation Command

After pushing to GitHub, share this with others:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/dotfiles/main/install.sh)
```

## Quick Start on a New Machine

```bash
# 1. Install git if not available (you may need sudo)
# sudo apt install git  # Debian/Ubuntu
# sudo yum install git  # RHEL/CentOS

# 2. Run the one-line installer
bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/dotfiles/main/install.sh)

# 3. Reload your shell
source ~/.bashrc

# 4. Start using tmux
tmux

# 5. Open neovim
nvim
```

## What's Included

```
dotfiles/
├── bash/
│   └── bashrc           # Bash configuration with aliases and FZF integration
├── nvim/
│   └── init.lua         # Neovim configuration (Lua-based)
├── tmux/
│   └── tmux.conf        # Tmux configuration
├── install.sh           # One-line installation script
├── README.md            # Comprehensive documentation
└── .gitignore          # Git ignore rules
```

## Customization Tips

### Add Your Own Aliases

Edit `bash/bashrc` and add your custom aliases:

```bash
# My custom aliases
alias deploy='ssh user@server'
alias backup='rsync -avz ~/important /backup/'
```

### Add Neovim Plugins (Optional)

If you want to add plugins later, you can integrate a plugin manager like:
- lazy.nvim
- packer.nvim
- vim-plug

But for public clusters, the zero-plugin setup is often the best approach.

### Customize Tmux Colors

Edit `tmux/tmux.conf` to change the status bar colors and appearance.

## Sharing with Team

If your team needs the same setup:

1. Share the one-line install command
2. They can customize by creating `~/.bashrc.local`
3. No conflicts with existing configs - everything is backed up

## Maintenance

### Update Your Dotfiles

```bash
cd ~/.dotfiles
git pull
source ~/.bashrc
```

### Sync Changes Across Machines

```bash
# On machine where you made changes
cd ~/.dotfiles
git add -A
git commit -m "Updated configurations"
git push

# On other machines
cd ~/.dotfiles
git pull
source ~/.bashrc
tmux source-file ~/.tmux.conf  # if tmux is running
```

## Troubleshooting

### Installation fails with "git not found"
```bash
# Install git first
sudo apt install git  # or sudo yum install git
```

### curl command fails
```bash
# Download the script manually
wget https://raw.githubusercontent.com/YOUR_USERNAME/dotfiles/main/install.sh
bash install.sh
```

### Neovim shows errors
```bash
# Make sure neovim is installed
which nvim

# Check version (should be 0.5+)
nvim --version
```

---

**Ready to go!** Your dotfiles are now portable and can be installed anywhere with a single command.
