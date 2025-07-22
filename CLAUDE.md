# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for managing development environment configurations across multiple machines. It uses a custom deployment system with host-specific configuration support.

## Key Commands

### Deployment
- `./rcin all` - Full deployment: installs plugin managers and deploys all dotfiles
- `./rcin deploy` - Deploy dotfiles only (creates symlinks from repo to home directory)
- `./rcin clean` - Remove deployed files and restore from automatic backup
- Add `--dry-run` flag to any command to preview changes without executing

### Common Development Tasks

When modifying configurations:
1. Edit files in the `home/` directory (not in your actual home directory)
2. Run `./rcin deploy` to apply changes
3. The script automatically backs up existing files before overwriting

## Architecture

### Directory Structure
- `/home/` - Contains all dotfiles that will be symlinked to user's home directory
- `/etc/` - Additional configuration files
- `/home/.config/nvim/rc/hosts/{hostname}/` - Host-specific Neovim configurations
- `/home/.zsh/rc/hosts/{hostname}/` - Host-specific Zsh configurations

### Host-Specific Configurations
The system detects the current hostname and applies host-specific configurations automatically. Currently configured hosts:
- jouhousekyuritichimunoMacBook-Pro (current)
- akashisan
- coorie
- kuroimato
- myon
- sol

### Plugin Management
The repository manages three plugin systems:
- **Zinit** - Zsh plugin manager (installed to ~/.zsh/plug/zinit)
- **TPM** - Tmux Plugin Manager (installed to ~/.tmux/plug/tpm)
- **Dein.vim** - Neovim plugin manager (installed to ~/.local/share/dein)

All plugin managers are automatically installed/updated via `./rcin all`.

## Key Configuration Files

### Neovim
- Main config: `home/.config/nvim/init.vim`
- Plugin list: `home/.config/nvim/rc/dein.toml`
- Host-specific: `home/.config/nvim/rc/hosts/{hostname}/localhost.vim`

### Zsh
- Main config: `home/.zshrc`
- Plugin config: `home/.zsh/rc/plug.zsh`
- Aliases: `home/.zsh/rc/autoload/alias.zsh`
- Host-specific: `home/.zsh/rc/hosts/{hostname}/localhost.zsh`

### Tmux
- Main config: `home/.tmux.conf`
- Uses Ctrl-c as prefix key (instead of default Ctrl-b)

## Important Notes

- The deployment script (`rcin`) creates symlinks from this repository to your home directory
- Always edit files within this repository, not the symlinked files in your home directory
- Automatic backups are created in `~/dotfilesbak{timestamp}/` before any file is overwritten
- The system supports both macOS and Linux environments with host-specific adaptations