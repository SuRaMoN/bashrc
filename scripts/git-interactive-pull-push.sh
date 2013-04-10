 
function git-interactive-pull-push() {
	local CONFIRM_PULL_REQUEST CURRENTBRANCH ACTION DEFAULT_REMOTE REMOTE REMOTES
	
	CURRENTBRANCH="$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")"
	ACTION="$2"

	echo "git $ACTION <????> $CURRENTBRANCH"
	I=0
	DEFAULT_REMOTE=0
	for REMOTE in $(git remote); do
		((I++))
		echo -e "$I) $REMOTE"
		if [ "$REMOTE" == "upstream" ]; then
			DEFAULT_REMOTE="$I"
		fi
		if [ "$REMOTE" == "origin" -a "$DEFAULT_REMOTE" == 0 ]; then
			DEFAULT_REMOTE="$I"
		fi
		REMOTES[$I]="$REMOTE"
	done
	if [ "$DEFAULT_REMOTE" == 0 ]; then
		DEFAULT_REMOTE=1
	fi

	read -e -p "Remote no: " -i "$DEFAULT_REMOTE" REMOTEKEYS
	if [ -z "$REMOTEKEYS" ]; then
		return
	fi

	for REMOTE in $(echo $REMOTEKEYS | tr "," " "); do
		echo git $ACTION "${REMOTES[$REMOTE]}" "$CURRENTBRANCH"
		git $ACTION "${REMOTES[$REMOTE]}" "$CURRENTBRANCH"
		echo "$ACTION"
		if [[ "$ACTION" == "push" && "${REMOTES[$REMOTE]}" != "origin" && "${REMOTES[$REMOTE]}" != "upstream" ]]; then
			read -e -p "Send pull request? [y/n] " -i "n" CONFIRM_PULL_REQUEST
			if [[ "$CONFIRM_PULL_REQUEST" == "y" ]]; then
				echo hub pull-request
			fi
		fi
	done
}

function git-interactive-pull() {
	git-interactive-pull-push "$1" pull
}

function git-interactive-push() {
	git-interactive-pull-push "$1" push
}

