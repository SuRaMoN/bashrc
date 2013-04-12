
CB=( \
	"/home/matthias/public_html/iBiller" \
	"/home/matthias/public_html/ic.platform" \
	"/home/matthias/Projects/Bash/IcAdmin" \
	"/home/matthias/Projects/PHP/credico-exports" \
	"/home/matthias/Projects/PHP/ic.export" \
	"/home/matthias/Projects/PHP/ic.puppet" \
	"/home/matthias/Projects/PHP/puppet" \
	"/home/matthias/Projects/PHP/itertools" \
	"/home/matthias/Projects/PHP/cocobase" \
	"/home/matthias/Projects/PHP/itertools" \
	)

function cb() {
	local B

	for B in "${CB[@]}"; do
		if [ "$(basename "$B")" == "$1" ]; then
			cd "$B"
			return
		fi
	done
	cd "$1"
}

function _cbCompletion() {
	local QUERY B BASE

    QUERY="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=()

	for B in "${CB[@]}"; do
		BASE="$(basename "$B")"
		if [ "${BASE:0:${#QUERY}}" == "$QUERY" ]; then
			COMPREPLY+=("$BASE")
		fi
	done
}

complete -F _cbCompletion cb

