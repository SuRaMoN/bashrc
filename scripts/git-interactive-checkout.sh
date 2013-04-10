
function git-interactive-checkout() {
	local LISTONLY DELETE BRANCHPARAMS BRANCH BRANCHES GREEN NO_COLOUR I CONFIRM LOCALNAME BRANCHNUM

	LISTONLY=
	DELETE=
	BRANCHPARAMS=

	while :
	do
		case "$1" in
		-l | --list-only)
			shift
			LISTONLY=1
			;;
		-d | --delete)
			shift
			DELETE=1
			;;
		-m | --merged)
			shift
			BRANCHPARAMS="$BRANCHPARAMS --merged"
			;;
		-n | --no-merged)
			shift
			BRANCHPARAMS="$BRANCHPARAMS --no-merged"
			;;
		-r | --show-remotes)
			shift
			BRANCHPARAMS="$BRANCHPARAMS -a"
			;;
		-h | --help )
			shift
			echo "Usage: $0 [-l|--list-only] [-d|--delete] [-m|--merged] [-n|--no-merge] [-r|--show-remotes] [-h|--help]"
			echo "  -l|--list-only         List only (no interaction)"
			echo "  -d|--delete            Delete branch interactivly"
			echo "  -m|--merged            Show merged branches only"
			echo "  -n|--no-merged         Show unmerged branches only"
			echo "  -n|--show-remotes         Show remotes also"
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

	GREEN="\033[0;32m"
	NO_COLOUR="\033[0m"

	CURRENTBRANCH="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"

	echo "To checkout remote branches use the -r switch"
	echo

	## List all branches
	I=0
	for BRANCH in $(git branch $BRANCHPARAMS | grep -o "[^ ]*$"); do
		((I++))
		DESCR="$(git config branch.$BRANCH.description)"
		if [ "$CURRENTBRANCH" == "$BRANCH" ]; then
			echo -e "$GREEN$I) $BRANCH - $DESCR$NO_COLOUR"
		else
			echo "$I) $BRANCH - $DESCR"
		fi
		BRANCHES[$I]="$BRANCH"
	done

	if [ -n "$LISTONLY" ]; then
		return
	fi

	## Delete a branch
	if [ -n "$DELETE" ]; then
		read -p "Delete branch: " BRANCHNUM
		if [ -z "$BRANCHNUM" ]; then
			return
		fi
		BRANCH="${BRANCHES[$BRANCHNUM]}"
		read -p "You sure you wish to delete $BRANCH? [N/y]" CONFIRM
		if [ "$CONFIRM" != "y" ]; then
			return
		fi
		git branch -D "$BRANCH"
		return
	fi

	## actual checkout
	read -p "Checkout branch: " BRANCHNUM
	if [ -z "$BRANCHNUM" ]; then
		return
	fi
	BRANCH="${BRANCHES[$BRANCHNUM]}"
	if echo "$BRANCH" | grep -q "^remotes/"; then
		LOCALNAME="$(echo "$BRANCH" | grep -o '[^/]*$')"
		git checkout -b "$LOCALNAME" "$BRANCH"
	else
		git checkout "$BRANCH"
	fi
}

