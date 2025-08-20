GPG_TTY=$(tty)
export GPG_TTY
#source ~/.secretsrc
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Platform-aware completion setup
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS with Homebrew
  if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
  fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux completion setup - add system completion directories
  FPATH="/usr/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

# FNM (Fast Node Manager) setup - cross-platform
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias sa='alias | fzf'
#unalias sa

# sa() {
#     local selected_alias=$(alias | fzf --print-query --preview="echo {}" | tail -n 1)
#     [ -n "$selected_alias" ] && BUFFER="${selected_alias%%=*} "
#     CURSOR=$#BUFFER
#     zle reset-prompt
# }
# zle -N sa
# bindkey '^s' sa

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export TMUX_PLUGINS_PATH=~/.tmux/plugins

tmux-window-name() {
	# Only run if we're in a tmux session and the plugin exists
	if [[ -n "$TMUX" ]] && [ -f "$TMUX_PLUGINS_PATH/tmux-window-name/scripts/rename_session_windows.py" ]; then
		($TMUX_PLUGINS_PATH/tmux-window-name/scripts/rename_session_windows.py &)
	fi
}

add-zsh-hook chpwd tmux-window-name

# Python environment
export PATH="${HOME}/.pyenv/shims:${PATH}"

# Git configuration (if exists)
[ -f ~/.afm-git-configrc ] && source ~/.afm-git-configrc

alias editmydotfiles='code $(yadm ls-tree --name-only --full-tree -r HEAD)'

# Platform-specific SSH agent setup
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS - 1Password SSH agent
  export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
else
  # Linux - use system SSH agent or gpg-agent
  if pgrep -x "gpg-agent" > /dev/null; then
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  fi
fi

movToGif() {
    TARGET="${2:-$1.gif}"
    ffmpeg -i "$1" -r 10 -f gif - | gifsicle --optimize=3 --delay=6 > "$TARGET"
}

alias checkCrowdstrike='sudo fs_usage $(ps -A | grep com.crowdstrike.falcon.Agent | awk "{print $1}" | head -1)'
alias gfm="git fetch origin master --prune --prune-tags"
alias af="cd ~/Projects/atlassian/atlassian-frontend/master"
alias cf="cd ~/Projects/atlassian/confluence-frontend/"
alias jf="cd ~/Projects/atlassian/jira-frontend/"
alias ap="cd ~/Projects/atlassian/"

alias ell="python3 ~/Projects/github/Elgato-Light-Controller/elgato-light-controller.py -address 192.168.68.51"
alias elr2="python3 ~/Projects/github/Elgato-Light-Controller/elgato-light-controller.py -address 192.168.68.71"
alias elr="python3 ~/Projects/github/Elgato-Light-Controller/elgato-light-controller.py -address 192.168.68.72"

alias outheadphone="SwitchAudioSource -s \"Marco’s AirPods Max\""
alias outspeakers="SwitchAudioSource -s \"iFi (by AMR) HD USB Audio \""

alias inmic="SwitchAudioSource -t input -s \"Wave Link MicrophoneFX\""
alias inheadphone="SwitchAudioSource -t input -s\"Marco’s AirPods Max\""

alias lightsOn="lightLeft -on && lightRight -on"
alias lightsOff="lightLeft -off && lightRight -off"

#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

# Platform-specific clipboard integration
if [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS clipboard integration
  alias sshpbcopy="nc -q0 localhost 5556"
  alias sshdaemon="while (true); do nc -l 5556 | pbcopy; done"
else
  # Linux clipboard integration
  alias sshpbcopy="nc -q0 localhost 5556"
  alias sshdaemon="while (true); do nc -l 5556 | xclip -selection clipboard; done"
fi
export PATH="$HOME/.cargo/bin:$PATH"

# Render tab characters 2 spaces wide
#tabs -2

export PATH="$HOME/.local/bin:$PATH"

# Java environment manager
if command -v jenv &>/dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# Work-specific paths (platform-agnostic)
export REVIEW_BASE="origin/master"
export PATH="/opt/atlassian/bin:$PATH"
export PATH="$HOME/.orbit/bin:$PATH"

# Load tmux virtual environment for tmux-window-name plugin (if it exists)
if [[ -f ~/.tmux_venv/bin/activate ]]; then
  source ~/.tmux_venv/bin/activate
fi
export PATH="/opt/atlassian/bin:$PATH"
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit


#compdef fnm

# Added by spr for shell completions
fpath=(~/.local/share/zsh/completions $fpath)
autoload -Uz compinit && compinit

fpath=($HOME/.local/share/zsh/completions $fpath)

# Git worktree PATH management
_current_worktree_bin=""

worktree_path_helper() {
    local git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    
    # Remove previous worktree bin from PATH if it exists
    if [[ -n "$_current_worktree_bin" ]]; then
        export PATH="${PATH//:$_current_worktree_bin/}"
        export PATH="${PATH//$_current_worktree_bin:/}"
        export PATH="${PATH//$_current_worktree_bin/}"
    fi
    
    # If we're in a git repo and it has a bin directory, add it to PATH
    if [[ -n "$git_root" ]] && [[ -d "$git_root/bin" ]]; then
        _current_worktree_bin="$git_root/bin"
        export PATH="$_current_worktree_bin:$PATH"
    else
        _current_worktree_bin=""
    fi
}

# Override cd to automatically manage worktree PATH
function cd() {
    builtin cd "$@" && worktree_path_helper
}

# Also override pushd and popd for completeness  
function pushd() {
    builtin pushd "$@" && worktree_path_helper
}

function popd() {
    builtin popd "$@" && worktree_path_helper
}

# Enhanced gWs function that also manages PATH
gWs() { 
    local wt=$(git worktree list | fzf | awk "{print \$1}")
    [[ -n "$wt" ]] && cd "$wt"
}

# Initialize worktree PATH management for current directory
worktree_path_helper

alias rovo="acli rovodev"
alias grd="git-root"

# bun completions
[ -s "/Users/mdejongh/.bun/_bun" ] && source "/Users/mdejongh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
