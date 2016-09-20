# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make bash autocomplete with up arrow.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[1;5C": forward-word'
bind '"\e[1;5D": backward-word'

export EDITOR='vim'

function __git_ps1_cygwin_branch() {
  # On Cygwin, git is quite slow. That's why we parse HEAD manually.
  local slashes=${PWD//[^\/]/}
  local gitdir="$PWD"
  for (( n=${#slashes}; n>0; --n )); do
    if [ -f "$gitdir/.git/HEAD" ]; then
      local ref=$(<"$gitdir/.git/HEAD")
      echo " [${ref##*/}]"
      return
    fi
    gitdir="$gitdir/.."
  done
}

function __git_ps1_branch() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [ -n "$branch" ]; then
    echo " [$branch]"
  fi
}

function __ps1_setup() {
  local time_p='\[\e[1;30m\]\t'
  local host_p='\[\e[1;32m\]\h'
  local path_p='\[\e[1;34m\]\w'
  local end_p='\[\e[0m\]\$ '
  case $OSTYPE in
    *win*|*msys*)
      local branch_p='\[\e[1;33m\]$(__git_ps1_cygwin_branch)'
      export PS1="$time_p $host_p $path_p$branch_p$end_p"
      ;;
    *)
      local branch_p='\[\e[1;33m\]$(__git_ps1_branch)'
      export PS1="$time_p $host_p:$path_p$branch_p$end_p"
      ;;
  esac
}

__ps1_setup

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias vi='vim -X'
alias vim='vim -X'
alias vimdiff='vimdiff -X'
alias less='less -S'
alias rmorig='find . -name *.orig -delete'
alias rmpyc='find . -name *.pyc -delete'
alias wip="git commit -a -m'WIP.'"

# Local settings.

[ -d "$HOME/bin" ] && export PATH="$HOME/bin/:$PATH"
[ -d "$HOME/bin_local" ] && export PATH="$HOME/bin_local/:$PATH"
[ -f $HOME/.bashrc_local ] && source $HOME/.bashrc_local

# TMUX stuff.
export DEPOT="$HOME/depot"
# It's OK to list sessions while in TMUX session.
function lsc() {
  $HOME/bin/tmux-complete.py
}

if [ -z "$TMUX" ]; then
  # Not in TMUX session, adding TMUX attach commands.
  function rsc() {
    local client="$1"
    if [ -z "$client" ]; then
      tmux list-session | cut -f1 -d:
      return
    fi
    if [ ! $(tmux list-sessions | grep --quiet "^$client:") ]; then
      tmux -q new-session -d -s "$client" > /dev/null
    fi
    local sessionid="$client.$$"
    tmux -q new-session -t "$client" -s "$sessionid" \;\
        set-option destroy-unattached \;\
        attach-session -t "$sessionid" > /dev/null
  }
  complete -o nospace -C "$HOME/bin/tmux-complete.py" rsc
fi
