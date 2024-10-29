[ -f "$HOME/.config/bash/git-prompt.sh" ] && source "$HOME/.config/bash/git-prompt.sh"

# Fallback for git prompt.
if ! type __git_ps1 >/dev/null 2>&1; then
  __git_ps1() {
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
fi

export VIRTUAL_ENV_DISABLE_PROMPT=1
function __ps1_venv() {
  if [ "$VIRTUAL_ENV" != "" ]; then
    echo "venv "
  fi
}

function __ps1_setup() {
  local venv_p='\[\e[1;35m\]$(__ps1_venv)'
  local path_p='\[\e[1;34m\]\w'
  local branch_p='\[\e[1;33m\]$(__git_ps1 " [%s]")'
  local end_p='\[\e[0m\] $ '
  export PS1="$venv_p$path_p$branch_p$end_p"
}
__ps1_setup

# sets terminal title to hostname
echo -ne "\033]0;${HOSTNAME}\007"
