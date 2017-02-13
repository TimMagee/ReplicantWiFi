# setup environment variables:
source "/data/misc/wifi/setup_variables.sh"
if [ $? -ne 0 ]; then
	exit
fi

# run wpa_supplicant without configuration file,
# but providing a PID file and a socket, to let wpa_cli communicate with it
wpa_supplicant -B -dd -i"$ifacename" -C"$socketfile" -P"$pidfile"
