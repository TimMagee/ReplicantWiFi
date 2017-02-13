# setup environment variables:
source "/data/misc/wifi/setup_variables.sh"
if [ $? -ne 0 ]; then
	exit 1
fi

# parse arguments <bssid>
if [ $# -eq 0 ]; then
	echo "Missing arguments <bssid> "
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Wrong argument count!"
	exit 1
fi

curnet=$1
# check if the known networks file exists
if ! [ -e "$knets_file" ]; then
	exit 0
fi

# get all file contents that do not begin with the bssid of the network to remove.
# read the file, omitting comments:
keptLines=$(grep -v --invert-match "^$curnet" "$knets_file")

# overwrite the file, keeping only the filtered lines
echo "$keptLines" > "$knets_file"


