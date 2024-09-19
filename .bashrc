# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR='vim'
export CLICOLOR=1
export HOMEBREW_AUTO_UPDATE_SECS=2592000

try-source() {
  [ -r "$1" ] && source "$1"
}
try-source /etc/bashrc
try-source "$HOME/.config/bash/completion.sh"
try-source "$HOME/.config/bash/ps1.sh"
try-source "$HOME/.bashrc_local"

# Make bash autocomplete with up arrow.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# TODO: fix these for mac.
# bind '"\e[1;5C": forward-word'
# bind '"\e[1;5D": backward-word'

alias ..='cd ..'

try-path() {
  [ -d "$1" ] && export PATH="$1:$PATH"
}
try-path "/opt/homebrew/bin"
try-path "$HOME/bin"
try-path "$HOME/bin_local"

# Makes sure this init script ends with error code 0.
env true
