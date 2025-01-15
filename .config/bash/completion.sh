# Enable bash programmable completion features in interactive shells
if [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

# Make target completion.
complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' ?akefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make

source "$HOME/.config/bash/git-completion.bash"

# Hack to make 'git dd' complete to branch names.
_git_dd() { _git_diff ; }
_git_p() { _git_diff ; }

if command -v kubectl &> /dev/null; then
    source "$HOME/.config/bash/kubectl-completion.sh"

    alias k=kubectl
    complete -o default -F __start_kubectl k
    # Namespace related:
    alias kx='f() { [ "$1" ] && kubectl config use-context "$1" || kubectl config get-contexts ; } ; f'
    alias kn='f() { [ "$1" ] && kubectl config set-context --current --namespace "$1" || kubectl config get-contexts ; } ; f'
fi

