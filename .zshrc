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

# Fast git checkout using fzf with recent branches from reflog
gcb() {
  local branch
  branch=$(git reflog 2>/dev/null |
    grep 'checkout: moving from' |
    sed 's/.*checkout: moving from .* to \(.*\)/\1/' |
    awk '!seen[$0]++' |
    head -30 |
    fzf --height 40% --reverse --prompt="Checkout branch: ")

  if [[ -n "$branch" ]]; then
    git checkout "$branch"
  fi
}

# Override Prezto's __git_branch_names to only show recent branches from reflog
# This affects all git commands that complete branch names
__git_branch_names() {
  local expl
  declare -a branch_names

  branch_names=(${(f)"$(git reflog 2>/dev/null |
    grep 'checkout: moving from' |
    sed 's/.*checkout: moving from .* to \(.*\)/\1/' |
    awk '!seen[$0]++' |
    head -30)"})

  _wanted branch-names expl 'recent branch' compadd -a - branch_names
}

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

# Disable gitstatusd for AFM directories (prevents git index lock contention)
POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN='*/atlassian/afm/*'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export TMUX_PLUGINS_PATH=~/.tmux/plugins

# Disabled tmux hooks for performance - uncomment if needed
# tmux-window-name() {
# 	# Only run if we're in a tmux session, plugin exists, and we're in work directories
# 	if [[ -n "$TMUX" ]] && [ -f "$TMUX_PLUGINS_PATH/tmux-window-name/scripts/rename_session_windows.py" ] && [[ "$PWD" == */Projects/* ]]; then
# 		($TMUX_PLUGINS_PATH/tmux-window-name/scripts/rename_session_windows.py &)
# 	fi
# }

# tmux-peacock-update() {
# 	# Sync tmux pane colors with VSCode Peacock colors
# 	# Only run in large repos to reduce overhead
# 	if [[ -n "$TMUX" ]] && [[ -x "~/bin/tmux-peacock-sync" ]] && [[ "$PWD" == */atlassian/* ]]; then
# 		# Run the script directly without killing processes
# 		~/bin/tmux-peacock-sync "$PWD" 2>/dev/null
# 	fi
# }

# Hooks disabled for performance - uncomment to re-enable
# add-zsh-hook chpwd tmux-window-name
# add-zsh-hook chpwd tmux-peacock-update

# Python environment
export PATH="${HOME}/.pyenv/shims:${PATH}"

# Git configuration (if exists)
[ -f ~/.afm-git-configrc ] && source ~/.afm-git-configrc

alias editmydotfiles='code $(yadm ls-tree --name-only --full-tree -r HEAD)'


# Consolidate PATH management to prevent duplicates
_add_to_path() {
  local dir="$1"
  [[ -d "$dir" ]] && [[ ":$PATH:" != *":$dir:"* ]] && PATH="$dir:$PATH"
}

# Clean and rebuild essential PATH entries
_add_to_path "$HOME/.local/bin"
_add_to_path "$HOME/.cargo/bin"
_add_to_path "$HOME/.bun/bin"
_add_to_path "$HOME/.orbit/bin"
_add_to_path "/opt/atlassian/bin"

movToGif() {
    TARGET="${2:-$1.gif}"
    ffmpeg -i "$1" -r 10 -f gif - | gifsicle --optimize=3 --delay=6 > "$TARGET"
}

alias checkCrowdstrike='sudo fs_usage $(ps -A | grep com.crowdstrike.falcon.Agent | awk "{print $1}" | head -1)'
_git_main_or_master_branch() {
    local branch

    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "not inside a git repository" >&2
        return 1
    fi

    branch=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null)
    branch="${branch#origin/}"

    if [[ "$branch" == "main" || "$branch" == "master" ]]; then
        printf '%s\n' "$branch"
        return 0
    fi

    if git show-ref --verify --quiet refs/remotes/origin/main || git show-ref --verify --quiet refs/heads/main; then
        printf 'main\n'
    elif git show-ref --verify --quiet refs/remotes/origin/master || git show-ref --verify --quiet refs/heads/master; then
        printf 'master\n'
    else
        echo "couldn't determine whether this repo uses main or master" >&2
        return 1
    fi
}

# Replace Prezto git aliases with branch-aware helpers below.
unalias gfm 2>/dev/null
unalias gri 2>/dev/null

gfm() {
    local branch

    branch=$(_git_main_or_master_branch) || return 1
    git pull origin "$branch"
}

gri() {
    if [[ -n "$1" ]]; then
        git rebase --interactive "$1"
        return
    fi

    local branch

    branch=$(_git_main_or_master_branch) || return 1
    git rebase --interactive "origin/$branch"
}
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
# Render tab characters 2 spaces wide
#tabs -2

# Java environment manager
if command -v jenv &>/dev/null; then
  export PATH="$HOME/.jenv/bin:$PATH"
  eval "$(jenv init -)"
fi

# Work-specific paths (platform-agnostic)
export REVIEW_BASE="origin/master"

# Load tmux virtual environment for tmux-window-name plugin (if it exists)
if [[ -f ~/.tmux_venv/bin/activate ]]; then
  source ~/.tmux_venv/bin/activate
fi
# Completion setup - consolidate to prevent duplicates
fpath=(~/.zsh ~/.local/share/zsh/completions $HOME/.local/share/zsh/completions $fpath)
# Only run compinit once
autoload -Uz compinit && compinit

#compdef fnm

# Git repository bin directory PATH management (using zsh hooks)
source "$HOME/bin-path-manager.zsh"

# Enhanced gWs function that works with the hook-based PATH management
gWs() { 
    local wt=$(git worktree list | fzf | awk "{print \$1}")
    [[ -n "$wt" ]] && cd "$wt"
}

alias rovo="acli rovodev tui"
alias grd="git-root"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
export PATH="$PATH:$JAVA_HOME/bin"

[[ -n "$ZSH_VERSION" && -f "$HOME/.afm-bin-path-manager.zsh" ]] && source "$HOME/.afm-bin-path-manager.zsh"

[[ -n "$BASH_VERSION" && -f "$HOME/.afm-bin-path-manager.bash" ]] && source "$HOME/.afm-bin-path-manager.bash"

# git-doctor: shell environment configuration
[ -f "$HOME/.git-doctor/env.sh" ] && source "$HOME/.git-doctor/env.sh"

# fnm
FNM_PATH="/home/developer/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"
[ -f ~/.claude_env ] && source ~/.claude_env
export PATH="$HOME/.bun/bin:$PATH"
[ -z "$TMUX" ] && [ -n "$SSH_CONNECTION" ] && [ -t 0 ] && exec tmux new-session -A -s main
