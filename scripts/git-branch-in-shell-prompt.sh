 

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \[\1\]/'
}

get_hostname_in_color_by_hash() {
	local i HASH
	HASH=0
	for (( i=0; i< ${#HOSTNAME}; i++ )); do
	  ((HASH+=$(printf '%d' "'${HOSTNAME:$i:1}'")))
	done
	echo -e "\033[$(($HASH%2));$((30+($HASH/2)%8))m$HOSTNAME\033[00m"
}

if [[ ${EUID} == 0 ]] ; then
	PS1='\n$(get_hostname_in_color_by_hash) \[\033[01;31m\]\u\[\033[01;35m\]$(parse_git_branch)\[\033[01;34m\] \[\033[01;32m\]${PWD/$HOME/~}\[\033[00m\]\n\$ \[\033[00m\]'
else
	PS1='\n$(get_hostname_in_color_by_hash) \[\033[01;31m\]\u\[\033[00;33m\]$(parse_git_branch)\[\033[00m\] \[\033[01;32m\]${PWD/$HOME/~}\[\033[00m\]\n\$ '
fi

# Change the window title of X terminals
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'

