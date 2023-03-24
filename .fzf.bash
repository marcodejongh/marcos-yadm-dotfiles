# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/marcodejongh/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/marcodejongh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/marcodejongh/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/marcodejongh/.fzf/shell/key-bindings.bash"
