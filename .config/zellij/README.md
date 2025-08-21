# Zellij Configuration - Tmux Feature Parity

This zellij configuration provides feature parity with your existing tmux setup while preserving your tmux configuration for side-by-side evaluation.

## Installation & Setup

1. **Install Zellij** (if not already installed):
   ```bash
   brew install zellij
   ```

2. **Files Created**:
   - `~/.config/zellij/config.kdl` - Main configuration
   - `~/.config/zellij/layouts/default.kdl` - Default layout
   - `~/bin/zellij-peacock-sync` - Peacock integration script
   - All files are tracked by yadm

## Key Mapping Comparison

### Prefix Key
- **Tmux**: `Ctrl-b` (unchanged from default)
- **Zellij**: `Ctrl-b` (custom tmux mode) + `Ctrl-g` (locked mode)

### Navigation (No Prefix Needed)
| Function | Tmux | Zellij |
|----------|------|--------|
| Pane Navigation | `Ctrl-h/j/k/l` | `Ctrl-h/j/k/l` ✓ |
| Next Window/Tab | `Ctrl-Space` | `Ctrl-Space` ✓ |
| Previous Window/Tab | `Ctrl-\` | `Ctrl-\` ✓ |
| Command Palette | `Ctrl-p` | `Ctrl-p` ✓ |
| Window Switcher | `Ctrl-o` | `Ctrl-o` ✓ |

### Prefix Mode (`Ctrl-b` then...)
| Function | Tmux | Zellij |
|----------|------|--------|
| Detach | `d` | `d` ✓ |
| New Window/Tab | `c` | `c` ✓ |
| Split Horizontal | `s` | `s` ✓ |
| Split Vertical | `v` | `v` ✓ |
| Previous Window | `h` | `h` ✓ |
| Next Window | `l` | `l` ✓ |
| Resize Panes | `H/J/K/L` | `H/J/K/L` ✓ |
| Reload Config | `r` | `r` ✓ |
| Refresh | `R` | `R` ✓ |
| Paste | `p` | `p` ✓ |
| Copy Mode | `[` | `[` ✓ |

### Number Keys (Direct Tab Access)
- **Both**: `Ctrl-b` then `1-9` switches to tab/window by number

## Features Comparison

### ✅ Fully Supported
- **Vim-style navigation**: `hjkl` keys work everywhere
- **Mouse support**: Enabled by default, can be toggled
- **Session persistence**: Native session resurrection (replaces tmux-resurrect/continuum)
- **Copy/paste**: Native support with system clipboard integration
- **Scrollback**: 10,000 lines (matching tmux config)
- **256 colors**: Automatic terminal color support
- **1-based indexing**: Windows/tabs start at 1 (like tmux config)
- **Command palette**: Built-in fuzzy finder (replaces tmux-fzf)
- **Vi mode**: Built into copy/search mode

### ⚠️ Partially Supported / Different
- **Peacock sync**: Limited by zellij's runtime theming capabilities
  - Script focuses on tab naming instead of border colors
  - Future zellij versions may add better runtime theming
- **Synchronize panes**: Not directly supported in zellij
  - Alternative: Use multiple panes with same command
- **Dynamic border colors**: Limited compared to tmux
  - Uses themes instead of runtime color changes

### 🆕 Zellij Advantages
- **Session resurrection**: Works across reboots without plugins
- **Hot config reload**: Changes apply immediately without restart
- **Better plugin system**: WASM-based plugins with built-in UI
- **Floating panes**: Native floating window support
- **Command palette**: More powerful than tmux-fzf
- **Web interface**: Can access sessions via browser (optional)

## Usage Notes

### Starting Zellij
```bash
# Start with default layout
zellij

# Start with specific layout
zellij --layout ~/.config/zellij/layouts/default.kdl

# Attach to existing session
zellij attach main

# List sessions
zellij list-sessions
```

### Session Management
- Sessions automatically save every second
- Exited sessions can be resurrected
- Use `Ctrl-b d` to detach (same as tmux)
- Use `zellij attach <session>` to reattach

### Modes Overview
1. **Normal Mode**: Default mode, most navigation works
2. **Locked Mode** (`Ctrl-g`): Prevents accidental shortcuts
3. **Tmux Mode** (`Ctrl-b`): Prefix-based commands like tmux
4. **Search Mode**: Copy/scroll mode (like tmux copy-mode)

### Differences from Tmux

#### Session Persistence
- **Tmux**: Requires plugins (tmux-resurrect, tmux-continuum)
- **Zellij**: Built-in, automatic, works across reboots

#### Plugin Ecosystem
- **Tmux**: Shell-based plugins
- **Zellij**: WASM plugins with better integration

#### Configuration
- **Tmux**: Shell scripting style
- **Zellij**: KDL format, hot-reloadable

#### Copy Mode
- **Tmux**: Custom keybindings needed for vi-style
- **Zellij**: Vi-style built-in

## Troubleshooting

### Keybinding Conflicts
If some shortcuts don't work:
1. Check if terminal supports the key combination
2. Verify zellij is running: `echo $ZELLIJ`
3. Reload config: `Ctrl-b r`

### Mouse Issues
- Toggle mouse: `Ctrl-b m` (on) / `Ctrl-b M` (off)
- Some terminals have mouse integration conflicts

### Theme Issues
- Themes are set at startup, not runtime (unlike tmux)
- Use different themes by editing `config.kdl` and restarting

## Migration Strategy

1. **Keep both**: Your tmux config is preserved
2. **Test workflow**: Try zellij for a few days
3. **Compare features**: See which tool fits your workflow better
4. **Gradual transition**: Use both for different projects

## Future Enhancements

Areas where zellij may improve to better match tmux:
- Runtime theme switching for better peacock integration
- Pane synchronization feature
- More granular border customization

Your tmux configuration remains fully functional and unchanged.