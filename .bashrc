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
  local host_p='\[\e[1;32m\]\h'
  local path_p='\[\e[1;34m\]\w'
  local end_p='\[\e[0m\]\$'
  case $OSTYPE in
    *win*|*msys*)
      local branch_p='\[\e[1;33m\]$(__git_ps1_cygwin_branch)'
      export PS1="$host_p $path_p$branch_p$end_p "
      ;;
    *)
      if [ -f /.dockerenv ]; then
        if [ $BASHPID == 1 ]; then
          host_p='*\[\e[1;35m\]\h'
        else
          host_p='\[\e[1;35m\]\h'
        fi
      fi
      local branch_p='\[\e[1;33m\]$(__git_ps1_branch)'
      export PS1="$host_p:$path_p$branch_p$end_p "
      ;;
  esac
}

__ps1_setup

# sets terminal title to hostname
echo -ne "\033]0;${HOSTNAME}\007"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ..='cd ..'
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'
alias less='less -S'
if [ -x /usr/bin/vim ]; then
    alias vi='vim -X'
    alias vim='vim -X'
    alias vimdiff='vimdiff -X'
fi

alias blaze='bazel'
alias wip="git commit -a -m'WIP.'"

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

[ -d "$HOME/bin" ] && export PATH="$HOME/bin/:$PATH"
[ -d "$HOME/bin_local" ] && export PATH="$HOME/bin_local/:$PATH"
[ -f $HOME/.bashrc_local ] && source $HOME/.bashrc_local

# Makes sure this init script ends with error code 0.
/bin/true
