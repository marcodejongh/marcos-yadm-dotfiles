# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/Cellar/fzf/0.44.1/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/Cellar/fzf/0.44.1/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/Cellar/fzf/0.44.1/shell/completion.zsh" 2>/dev/null

# Key bindings
# ------------
source "/opt/homebrew/Cellar/fzf/0.44.1/shell/key-bindings.zsh"
