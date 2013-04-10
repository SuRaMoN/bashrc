 

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}

if [[ ${EUID} == 0 ]] ; then
	PS1='\[\033[01;31m\]\u@\h\[\033[01;35m\]$(parse_git_branch)\[\033[01;34m\] \[\033[01;32m\]${PWD/$HOME/~}\[\033[00m\]\n\$ \[\033[00m\]'
else
	PS1='\[\033[01;31m\]\u@\h\[\033[00;33m\]$(parse_git_branch)\[\033[00m\] \[\033[01;32m\]${PWD/$HOME/~}\[\033[00m\]\n\$ '
fi

# Change the window title of X terminals
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'

