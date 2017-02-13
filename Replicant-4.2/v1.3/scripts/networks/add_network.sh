
# setup environment variables:
source "/data/misc/wifi/setup_variables.sh"
if [ $? -ne 0 ]; then
	exit 1
fi

# parse arguments <ssid> <password>
if [ $# -eq 0 ]; then
	echo "Missing arguments <ssid> <password> "
	exit 1
fi

if [ $# -ne 2 ]; then
	echo "Wrong argument count!"
	exit 1
fi

curnet=$1
pass=$2
foundnet=$(bash "$knets_get" "$curnet")
if ! [ -z "$foundnet" ]; then
	# the network is already a known one,
	# remove it from the list, before adding the new password
	source "$knets_rem" "$curnet"
fi

if ! [ -e "$knets_file" ]; then
	echo -n "" > "$knets_file"
fi

echo -e "$curnet""\t""$pass" >> $knets_file
