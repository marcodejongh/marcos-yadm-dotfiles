#!/usr/bin/env zsh
#
# bin-path-manager.zsh - Automatic PATH management for repository bin directories
#
# This script automatically adds/removes repository bin directories to/from PATH
# when navigating between directories using zsh's chpwd hook system.
#
# Usage: source this file in your .zshrc:
#   source /path/to/bin-path-manager.zsh
#
# Features:
# - Uses standard zsh hooks (chpwd) for maximum compatibility
# - Handles git repositories and their bin/ directories
# - Cleans up PATH when leaving repositories
# - Supports multiple nested repositories
# - Works with all directory change methods (cd, pushd, popd, autocd, etc.)
#

# Global variable to track current repository bin path
typeset -g _current_repo_bin=""

# Function to manage repository bin directory in PATH
_manage_repo_bin_path() {
    emulate -L zsh
    
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    local new_bin_path=""
    
    # If we're in a git repo and it has a bin directory, set the new path
    if [[ -n "$git_root" ]] && [[ -d "$git_root/bin" ]]; then
        new_bin_path="$git_root/bin"
    fi
    
    # Only make changes if the bin path has actually changed
    if [[ "$_current_repo_bin" != "$new_bin_path" ]]; then
        # Remove previous repository bin from PATH if it exists
        if [[ -n "$_current_repo_bin" ]]; then
            # Remove from beginning, middle, or end of PATH
            export PATH="${PATH//:$_current_repo_bin/}"
            export PATH="${PATH//$_current_repo_bin:/}"
            export PATH="${PATH//$_current_repo_bin/}"
        fi
        
        # Add new repository bin to PATH if it exists
        if [[ -n "$new_bin_path" ]]; then
            export PATH="$new_bin_path:$PATH"
        fi
        
        # Update tracking variable
        _current_repo_bin="$new_bin_path"
    fi
}

# Load the hook system and register our function
autoload -Uz add-zsh-hook
add-zsh-hook chpwd _manage_repo_bin_path

# Initialize PATH management for current directory
_manage_repo_bin_path

# Make functions available for manual use if needed
repo-bin-status() {
    echo "Current repo bin: $_current_repo_bin"
}