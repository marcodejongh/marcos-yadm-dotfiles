# Zellij integration for zsh
# Source this file in your .zshrc to enable automatic tab renaming and theme switching

# Function to update zellij tab name and theme based on current directory
function _zellij_update_context() {
    # Only run if we're in a zellij session
    if [[ -n "$ZELLIJ" ]]; then
        # Run the peacock sync script
        ~/bin/zellij-peacock-sync "$PWD" 2>/dev/null &
        
        # Optional: Apply theme switching (requires session restart currently)
        # This creates a project-specific config that could be used for new sessions
        local suggested_theme=$(~/bin/zellij-peacock-sync --get-theme 2>/dev/null)
        if [[ -n "$suggested_theme" && "$suggested_theme" != "gruvbox-dark" ]]; then
            # Store the suggested theme for potential use
            echo "# Suggested theme for this project: $suggested_theme" > ~/.config/zellij/.project-theme
        fi
    fi
}

# Hook to run on directory change
function chpwd() {
    _zellij_update_context
}

# Run once when shell starts
_zellij_update_context

# Optional: Add a function to manually switch themes (requires new session)
function zellij-theme() {
    if [[ -n "$1" ]]; then
        echo "theme \"$1\"" > ~/.config/zellij/.theme-override
        echo "Theme set to '$1'. Restart zellij session to apply:"
        echo "  zellij kill-session"
        echo "  zellij"
    else
        echo "Usage: zellij-theme <theme-name>"
        echo "Available custom themes:"
        ls ~/.config/zellij/themes/ | sed 's/\.kdl$//'
    fi
}

# Function to create a project-specific zellij session with appropriate theme
function zellij-project() {
    local project_dir="${1:-.}"
    local session_name="${2:-$(basename "$PWD")}"
    
    # Detect appropriate theme
    cd "$project_dir"
    ~/bin/zellij-peacock-sync "$PWD" 2>/dev/null
    local theme=$(~/bin/zellij-peacock-sync --get-theme 2>/dev/null)
    
    # Create temporary config with theme
    local temp_config="/tmp/zellij-${session_name}-config.kdl"
    cp ~/.config/zellij/config.kdl "$temp_config"
    
    # Update theme in temporary config
    if [[ "$theme" != "gruvbox-dark" ]]; then
        sed -i.bak "s/theme \"gruvbox-dark\"/theme \"$theme\"/" "$temp_config"
        echo "Starting zellij session '$session_name' with theme '$theme'"
    else
        echo "Starting zellij session '$session_name' with default theme"
    fi
    
    # Start zellij with custom config
    zellij --config "$temp_config" --session "$session_name"
    
    # Clean up
    rm -f "$temp_config" "$temp_config.bak"
}