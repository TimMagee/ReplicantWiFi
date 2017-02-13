
# this scripts outputs a tuple, formatted as <BSSID>[TAB]<PASSWORD>
# IF the requested bssid is found in the known networks file.
# it outputs nothing, if the bssid isn't found.

# setup environment variables:
source "/data/misc/wifi/setup_variables.sh"
if [ $? -ne 0 ]; then
	exit 1
fi

# validate input parameters
if [ $# -eq 0 ]; then
	echo "Missing arguments <bssid>"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Wrong arguments count!"
	exit 1
fi

# parse parameter <bssid>
netName=$1

# check if the known networks file exists
if ! [ -e "$knets_file" ]; then
	exit 0
fi

# read the file, omitting comments:
networks=$(grep -v --invert-match '^#' $knets_file)

if [ -z "$networks" ]; then
	exit 0
fi

tempNetsFile="$workdir""/tmpnts"
if [ -e "$tempNetsFile" ]; then
	rm "$tempNetsFile"
fi
echo "$networks" > "$tempNetsFile"

# count the number of saved networks:
netnum=$(echo "$networks" | wc -l)

# if there is no network in the list, return
if [ "$netnum" == "" ] || [ "$netnum" -lt 1 ]; then
	exit 0
fi

# iterate through networks, to see if the requested one is known:
idx=1
IFS=$'\t'
while read -r line
do
	tempLineFile="$workdir""/tmpln"
	if [ -e "$tempLineFile" ]; then
		rm "$tempLineFile"
	fi
	echo "$line" > "$tempLineFile"
	# split the line into the different properties:
	#the SSID is the 1st field, password is the 2nd
	read -r -a SUBAR < "$tempLineFile"
 	if [ "${SUBAR[0]}" = "$netName" ]; then
		# found the desired network.
		# outputs the tuple:
		echo -e "${SUBAR[0]}""\t""${SUBAR[1]}"
	fi
done < "$tempNetsFile"
IFS=

