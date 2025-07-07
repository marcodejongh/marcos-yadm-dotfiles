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

if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  autoload -Uz compinit
  compinit
fi

export PATH="/Users/mdejongh/.local/state/fnm_multishells/91339_1751348695248/bin":$PATH
export FNM_MULTISHELL_PATH="/Users/mdejongh/.local/state/fnm_multishells/91339_1751348695248"
export FNM_VERSION_FILE_STRATEGY="local"
export FNM_DIR="/Users/mdejongh/.local/share/fnm"
export FNM_LOGLEVEL="info"
export FNM_NODE_DIST_MIRROR="https://nodejs.org/dist"
export FNM_COREPACK_ENABLED="false"
export FNM_RESOLVE_ENGINES="true"
export FNM_ARCH="arm64"
rehash

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
	($TMUX_PLUGINS_PATH/tmux-window-name/scripts/rename_session_windows.py &)
}

add-zsh-hook chpwd tmux-window-name

export PATH="${HOME}/.pyenv/shims:${PATH}"
source ~/.afm-git-configrc

alias editmydotfiles='code $(yadm ls-tree --name-only --full-tree -r HEAD)'
export SSH_AUTH_SOCK=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

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

# https://gist.github.com/dergachev/8259104
alias sshpbcopy="nc -q0 localhost 5556"
alias sshdaemon="while (true); do nc -l 5556 | pbcopy; done"
export PATH="$HOME/.cargo/bin:$PATH"

# Render tab characters 2 spaces wide
#tabs -2

export PATH="/Users/mdejongh/.local/bin:$PATH"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"



export PATH="/Users/mdejongh/Projects/atlassian/afm/master/afm-tools/path:$PATH"

export REVIEW_BASE="origin/master"
export PATH="/opt/atlassian/bin:$PATH"

export PATH="/Users/mdejongh/.orbit/bin:$PATH"

# Load tmux virtual environment for tmux-window-name plugin
if [[ -f ~/.tmux_venv/bin/activate ]]; then
  source ~/.tmux_venv/bin/activate
fi
export PATH="/opt/atlassian/bin:$PATH"
fpath=(~/.zsh $fpath)
autoload -Uz compinit && compinit

# fnm
FNM_PATH="/Users/mdejongh/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/mdejongh/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(fnm env --use-on-cd --shell zsh)"

#compdef fnm

# Added by spr for shell completions
fpath=(~/.local/share/zsh/completions $fpath)
autoload -Uz compinit && compinit

fpath=(/Users/mdejongh/.local/share/zsh/completions $fpath)
gWs() { local wt=$(git worktree list | fzf | awk "{print \$1}"); [[ -n "$wt" ]] && cd "$wt"; }
