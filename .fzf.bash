# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/Cellar/fzf/0.42.0/bin* ]]; then
  PATH="${PATH:+${PATH}:}/opt/homebrew/Cellar/fzf/0.42.0/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/Cellar/fzf/0.42.0/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/opt/homebrew/Cellar/fzf/0.42.0/shell/key-bindings.bash"
