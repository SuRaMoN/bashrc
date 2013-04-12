 
function git-interactive-add-diff-commit() {
	local CURRENTBRANCH PULLFIRST

	CURRENTBRANCH=$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")
	read -p "Pull first from origin $CURRENTBRANCH ? [N/y] " PULLFIRST;
	if [ "$PULLFIRST" == "y" ]; then
		git pull origin "$CURRENTBRANCH"
		if [[ $? != 0 ]]; then
			return
		fi
	fi
	git add . && git add -u . && git diff HEAD && git commit
}

