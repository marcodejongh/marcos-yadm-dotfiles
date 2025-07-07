# Setup fzf
# ---------
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS with Homebrew
  if [[ ! "$PATH" == */opt/homebrew/bin* ]]; then
    PATH="${PATH:+${PATH}:}/opt/homebrew/bin"
  fi
  # Auto-completion
  [[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2>/dev/null
  # Key bindings
  source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh" 2>/dev/null
else
  # Linux - use system fzf
  if command -v fzf >/dev/null 2>&1; then
    # Only use autoload in zsh
    if [[ -n "$ZSH_VERSION" ]]; then
      # Load completion functions
      autoload -U compinit && compinit
      # Source completion and key bindings
      [[ -f /usr/share/zsh/site-functions/_fzf ]] && source "/usr/share/zsh/site-functions/_fzf" 2>/dev/null
    fi
    source "/usr/share/fzf/shell/key-bindings.zsh" 2>/dev/null
  fi
fi