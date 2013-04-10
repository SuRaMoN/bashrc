

function git-interactive-branch() {
	BRANCH="$1"
	if [ -z "$BRANCH" ]; then
		read -e -p "Branch to: " -i "ICPR-" BRANCH
	fi
	git checkout -b "$BRANCH" && git branch "$BRANCH" --edit-description
}

