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

YADM templates are used for platform-specific configurations:
- Files ending with `##os.Darwin` are for macOS
- Files ending with `##os.Linux` are for Linux
- Files ending with `##distro.fedora` are for Fedora specifically
- Files ending with `##distro.ubuntu` are for Ubuntu specifically

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