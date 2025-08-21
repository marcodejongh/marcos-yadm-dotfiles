# Zellij Peacock Integration

This enhanced zellij configuration provides dynamic pane coloring and tab naming similar to your tmux setup, integrated with VSCode Peacock extension colors.

## Features Added

### 🎨 Dynamic Theming
- **Custom peacock themes**: Blue, green, and purple themes based on VSCode Peacock colors
- **Automatic theme detection**: Script analyzes `.vscode/settings.json` for peacock colors
- **Project-specific sessions**: Start sessions with appropriate themes

### 🏷️ Automatic Tab Naming
- **Directory-based naming**: Tabs automatically rename based on current directory
- **Git worktree support**: Shows worktree names for better project context
- **Shell integration**: Updates happen automatically on directory changes

### 🔧 Shell Integration (zsh)
- **Automatic updates**: Tab names update when changing directories
- **Theme suggestions**: Detects appropriate themes for projects
- **Project sessions**: Launch themed sessions for specific projects

## Setup Instructions

### 1. Source the zsh integration
Add this line to your `~/.zshrc`:
```bash
source ~/.config/zellij/zsh-integration.zsh
```

### 2. Reload your shell
```bash
source ~/.zshrc
```

### 3. Test the integration
```bash
# Navigate to a directory with VSCode peacock settings
cd /path/to/project/with/.vscode/settings.json

# Start zellij - tab should be named after directory
zellij

# Change directories - tab name should update automatically
cd subdirectory
```

## Available Commands

### `zellij-theme <theme-name>`
Manually set theme for next session:
```bash
zellij-theme peacock-blue
zellij-theme peacock-green  
zellij-theme peacock-purple
```

### `zellij-project [directory] [session-name]`
Start a themed session for a project:
```bash
# Start session with auto-detected theme
zellij-project

# Start session for specific directory
zellij-project ~/projects/myapp

# Start with custom session name
zellij-project ~/projects/myapp myapp-dev
```

## How It Works

### Tab Naming Logic
1. **Worktree names**: If in a git worktree (e.g., `afm/feature-branch`), uses branch name
2. **Directory names**: Otherwise uses current directory basename
3. **Home directory**: Shows `~` for home directory

### Theme Detection
The `zellij-peacock-sync` script:
1. Looks for `.vscode/settings.json` in current directory
2. Reads `peacock.color` setting
3. Maps colors to custom themes:
   - Blue colors → `peacock-blue` theme
   - Green colors → `peacock-green` theme  
   - Purple colors → `peacock-purple` theme
   - Other/none → `gruvbox-dark` (default)

### Shell Hook Process
1. `chpwd()` hook runs when directory changes
2. Calls `zellij-peacock-sync` with current directory
3. Script updates tab name via `zellij action rename-tab`
4. Creates state file with suggested theme for future use

## Differences from Tmux Version

### ✅ Equivalent Features
- **Tab naming**: Same logic as tmux pane titles
- **Peacock integration**: Detects and uses VSCode colors
- **Git worktree support**: Same AFM worktree detection
- **Automatic updates**: Responds to directory changes

### ⚠️ Current Limitations
- **Runtime theme switching**: Themes require session restart (zellij limitation)
- **Per-pane colors**: Themes apply session-wide, not per-pane
- **Border customization**: Less granular than tmux's dynamic borders

### 🆕 Improvements
- **Project sessions**: `zellij-project` creates themed sessions automatically
- **Better theme detection**: More robust color mapping
- **State persistence**: Themes suggestions stored for consistency

## Troubleshooting

### Tab names not updating
1. Check if zsh integration is sourced: `type _zellij_update_context`
2. Verify script is executable: `ls -la ~/bin/zellij-peacock-sync`
3. Test script manually: `~/bin/zellij-peacock-sync`

### Themes not working
1. Check available themes: `zellij-theme` (no arguments)
2. Verify theme in config: Look for `themes {` section in `config.kdl`
3. Restart zellij session after theme changes

### Script errors
- Check script permissions: `chmod +x ~/bin/zellij-peacock-sync`
- Test peacock detection: `~/bin/zellij-peacock-sync --get-theme`
- Check VSCode settings format in `.vscode/settings.json`

## Example VSCode Settings

For testing, create `.vscode/settings.json` in a project:
```json
{
    "peacock.color": "#007ACC",
    "peacock.affectActivityBar": true,
    "peacock.affectStatusBar": true,
    "peacock.affectTitleBar": true
}
```

This will trigger the blue theme when you navigate to that directory.