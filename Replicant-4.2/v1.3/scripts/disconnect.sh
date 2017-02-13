suppid=$(pidof wpa_supplicant)
dhcppid=$(pidof dhcpcd)

if ! [ -z "$suppid" ]; then
	killall -SIGINT wpa_supplicant
fi

if ! [ -z "$dhcppid" ]; then
	killall -SIGINT dhcpcd
fi

exit 0
