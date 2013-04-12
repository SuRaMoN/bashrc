 
function git-interactive-pull-push() {
	local CONFIRM_PULL_REQUEST CURRENTBRANCH ACTION DEFAULT_REMOTE REMOTE REMOTES

	ALL_BRANCHES=0

	while :
	do
		case "$1" in
		-a | --all-branches)
			shift
			ALL_BRANCHES=1
			;;
		-h | --help )
			shift
			echo "Usage: $0 [-a|--all-branches]"
			echo "  -a|--all-branches         All branches"
			echo "  -h|--help              Show help"
			return
			;;
		--) # End of all options
			shift
			break;
			;;
		-*)
			echo "Error: Unknown option: $1" >&2
			return 1
			;;
		*)  # No more options
			break
			;;
		esac
	done

	ACTION="$1"

	if [ "$ALL_BRANCHES" == "1" ]; then
		CURRENTBRANCH=--all
	else
		CURRENTBRANCH="$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")"
	fi

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
		if [[ "$ACTION" == "push" && "${REMOTES[$REMOTE]}" != "origin" && "${REMOTES[$REMOTE]}" != "upstream" && "$CURRENTBRANCH" != "--all" ]]; then
			read -e -p "Send pull request? [y/n] " -i "n" CONFIRM_PULL_REQUEST
			if [[ "$CONFIRM_PULL_REQUEST" == "y" ]]; then
				hub pull-request
			fi
		fi
	done
}

function git-interactive-pull() {
	git-interactive-pull-push $* pull
}

function git-interactive-push() {
	git-interactive-pull-push $* push
}

