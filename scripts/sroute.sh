
function sroute() {
	local LINE LINES VALUES ROUTE NET GATEWAY NETMASK IFACE ROUTE_ARGS ROUTE_FIELDS ACTION

	LINES=()
	while read LINE; do
		LINES=("${LINES[@]}" "$LINE" "")
	done < <(route -n)

	ROUTE=$(dialog --stdout --menu "Select route" 20 100 20 \
		"${LINES[@]}" \
		"Add new" "")
	if [ $? -ne 0 ]; then return; fi


	if [ "$ROUTE" == "Add new" ]; then
		VALUES=$(dialog --stdout --form "Anter route details" 20 50 0 \
			"Net:"		1	1	""	1 10 20 0 \
			"Gateway:"	3	1	""	3 10 20 0 \
			"Netmask:"	5	1	""	5 10 20 0 \
			"Iface:"	7	1	""	7 10 20 0)
		NET=$(echo "$VALUES" | head -n 1 | tail -n 1)
		GATEWAY=$(echo "$VALUES" | head -n 2 | tail -n 1)
		NETMASK=$(echo "$VALUES" | head -n 3 | tail -n 1)
		IFACE=$(echo "$VALUES" | head -n 4 | tail -n 1)
		ROUTE_ARGS=("$NET")
		if [ "$GATEWAY" != "" ]; then ROUTE_ARGS=("${ROUTE_ARGS[@]}" gw "$GATEWAY"); fi
		if [ "$NETMASK" != "" ]; then ROUTE_ARGS=("${ROUTE_ARGS[@]}" netmask "$NETMASK"); fi
		if [ "$IFACE" != "" ]; then ROUTE_ARGS=("${ROUTE_ARGS[@]}" "$IFACE"); fi
		echo sudo route add "${ROUTE_ARGS[@]}"
		sudo route add "${ROUTE_ARGS[@]}"
	fi

	if [ "$ROUTE" != "Add new" ]; then
		ROUTE_FIELDS=()
		for I in {1..8}; do
			ROUTE_FIELDS[$I]=$(echo "$ROUTE" | sed -e 's/ \+/ /g' | cut -d " " -f $I)
		done

		ACTION=$(dialog --stdout --menu "What you want to do with the route?" 20 30 20 \
			"Delete" "")
		if [ $? -ne 0 ]; then return; fi

		case "$ACTION" in
			"Delete")
				echo sudo route del -net "${ROUTE_FIELDS[1]}" gw "${ROUTE_FIELDS[2]}" netmask "${ROUTE_FIELDS[3]}"
				sudo route del -net "${ROUTE_FIELDS[1]}" gw "${ROUTE_FIELDS[2]}" netmask "${ROUTE_FIELDS[3]}"
			;;
		esac
	fi
}

