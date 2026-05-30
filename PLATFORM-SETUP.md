# Multi-Platform Dotfiles Setup

This repository has been configured to work across multiple platforms: macOS, Fedora, and Ubuntu.

## Platform Support

### macOS
- Uses Homebrew for package management via `.Brewfile`
- Includes 1Password integration
- macOS-specific paths and configurations

### Fedora/RHEL
- Uses DNF package manager
- Package list in `.config/yadm/packages/fedora.txt`
- Uses FNM for Node.js management

### Ubuntu/Debian
- Uses APT package manager
- Package list in `.config/yadm/packages/ubuntu.txt`
- Uses FNM for Node.js management

## Installation

1. **Install YADM** (if not already installed):
   ```bash
   # macOS
   brew install yadm
   
   # Fedora
   sudo dnf install yadm
   
   # Ubuntu
   sudo apt install yadm
   ```

2. **Clone the repository**:
   ```bash
   yadm clone https://github.com/marcodejongh/marcos-yadm-dotfiles.git
   ```

3. **Run bootstrap**:
   ```bash
   yadm bootstrap
   ```

## Platform-Specific Features

### Shell Configuration
- **FNM vs NVM**: Linux uses FNM (Fast Node Manager), macOS can use either
- **SSH Agent**: macOS uses 1Password SSH agent, Linux uses system SSH agent or GPG agent
- **Clipboard**: macOS uses `pbcopy`, Linux uses `xclip`

### VS Code Settings
- **Linux**: Configuration in `.config/Code/User/settings.json##os.Linux`
- **macOS**: Configuration in `Library/Application Support/Code/User/settings.json##os.Darwin`

### Package Management
- **macOS**: Uses Homebrew with `.Brewfile`
- **Fedora**: Uses DNF with `.config/yadm/packages/fedora.txt`
- **Ubuntu**: Uses APT with `.config/yadm/packages/ubuntu.txt`

### Fonts
- **macOS**: Fonts installed to `~/Library/Fonts/`
- **Linux**: Fonts installed to `~/.local/share/fonts/`

## Template Files

YADM alternates are used for platform-specific configurations:
- Files ending with `##os.Darwin` are for macOS
- Files ending with `##os.Linux` are for Linux
- Files ending with `##distro.fedora` are for Fedora specifically
- Files ending with `##distro.ubuntu` are for Ubuntu specifically
- Files ending with `##class.proxmox` apply when `yadm config local.class proxmox` is set (Proxmox bootstrap sets this automatically)

On Darwin, `yadm alt` materializes the un-suffixed symlink to the matching source. On Linux, the suffixed source still occupies its tracked path in the work tree but no symlink is created, so the file has no effect.

### macOS-only files (`##os.Darwin`)

- `.Brewfile##os.Darwin` — Homebrew bundle
- `.config/alacritty/alacritty.toml##os.Darwin` — full Alacritty config (window/`option_as_alt`, `[terminal.shell]` pointing at `tmux-main-attach`)
- `Library/LaunchAgents/com.marcodejongh.tmux-main.plist##os.Darwin` — launchd unit for the managed tmux session
- `bin/tmux-main-attach##os.Darwin`, `bin/tmux-main-service##os.Darwin` — managed-tmux helpers (use `launchctl`)
- `bin/macos-privacy-preflight##os.Darwin` — warms macOS Privacy & Security prompts
- `Library/Application Support/Code/User/settings.json##os.Darwin` — VS Code settings (macOS path)

### Linux-only files (`##os.Linux`)

- `.config/alacritty/alacritty.toml##os.Linux` — Alacritty font block only
- `.config/Code/User/settings.json##os.Linux` — VS Code settings (Linux path)

### Cross-platform with conditional behavior

- `.zprofile`, `.zshrc` — SSH+tmux block prefers `~/bin/tmux-main-attach` (macOS managed session) and falls back to `exec tmux new-session -A -s main` on Linux.
- `.config/yadm/bootstrap` — branches on `uname -s` and `/etc/os-release`; loads the LaunchAgent only on macOS.

## Manual Setup Required

Some configurations require manual setup:

### 1Password (macOS)
- Install 1Password if not already installed
- Configure SSH agent integration
- Set up Git commit signing

### SSH Keys
- Generate SSH keys if needed
- Add to GitHub/GitLab/etc.

### Git Configuration
- Verify personal vs work email configurations
- Set up GPG signing if desired

## Troubleshooting

### Node.js Issues
- Make sure FNM is properly installed on Linux
- Check that the correct Node.js version is being used

### Font Issues
- Run `fc-cache -f -v` on Linux to refresh font cache
- Verify MesloLGS NF fonts are installed

### VS Code Issues
- Check that the correct platform-specific settings are being used
- Verify extensions are installed

## Contributing

When adding new configurations:
1. Consider platform differences
2. Use YADM templates for platform-specific files
3. Update package lists in `.config/yadm/packages/`
4. Update bootstrap script for new dependencies
5. Document platform-specific behavior in this README