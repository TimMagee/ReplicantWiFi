# Copyright (C) 2016, 2017 Filippo Fil Bergamo
#
# This file is part of "RepWifi", a set of shell scripts to ease libre wifi connectivity.
#
# RepWifi is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# RepWifi is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.



# setup environment variables:
source "/data/misc/wifi/setup_variables.sh"
if [ $? -ne 0 ]; then
	echo "Failed to setup variables"
	exit 1
fi

bash "$scriptDiscon"
if [ $? -ne 0 ]; then
	"Failed to kill wpa_supplicant"
	exit 1
fi
sleep 1s

bash "$scriptStartWPA"
if [ $? -ne 0 ]; then
	"Failed to start wpa_supplicant"
	exit 1
fi
sleep 1s

wpa_comm="wpa_cli -p$socketfile -P$pidfile -i$ifacename"

# scan for networks
echo -n "Scanning for networks... "
$wpa_comm scan
if [ $? -ne 0 ]; then
	exit 1
fi
sleep 2s


# store the scan results on file
if [ -e "$scanfile" ]; then
	rm "$scanfile"
fi
#sleep 1s

echo "Retrieving network list... "
$wpa_comm scan_results > "$scanfile"
if [ $? -ne 0 ]; then
	exit 1
fi
#sleep 1s

# read the results in a variable:
# modified Feb 1st 2017: 
# seems like the previously used option --invert-match is not POSIX.
# the version of "grep" on Replicant 6.0 misses this option.
# the option -v is used instead
networks=$(grep -v '^bssid' $scanfile)

tmpNetsFile="$workdir""/""tmpnts"
if [ -e "$tmpNetsFile" ]; then
	rm "$tmpNetsFile"
fi
echo "$tmpNetsFile"
echo "$networks" > "$tmpNetsFile"

# count the number of networks:
netnum=$(echo "$networks" | wc -l)

# check if there is at least one network in the list
if [ "$netnum" == "" ] || [ "$netnum" -lt 1 ]; then
	echo "No networks found!"
	exit 1
fi


echo ""
echo "Please input the number of the network you want to connect to:"
echo -e "\t # |  SSID"
echo -e "\t---|------------------"

tmpLineFile="$workdir""/""tmpln"
idx=1
declare -a AR
while IFS= read -r line
do
	# split the line into the different properties:
	if [ -e "$tmpLineFile" ]; then
		rm "$tmpLineFile"
	fi
	echo "$line" > "$tmpLineFile"
	# Set IFS to tab only. Needed to correctly parse SSIDs containig spaces.
	IFS='	'
	read -r -a SUBAR < "$tmpLineFile"
	AR[$idx]="${SUBAR[4]}" #the SSID is the 4th field
	echo -e "\t"$idx") | ""${SUBAR[4]}"

	idx=$(($idx+1))
done < "$tmpNetsFile"
# reset default IFS
IFS=

# read user's choice
read selnet

if ! [[ "$selnet" =~ ^[0-9]+$ ]]; then
	echo "Invalid input!"
	exit
fi

if [ "$selnet" -le 0 ] || [ "$selnet" -gt "$netnum" ]; then
	echo "Invalid number!"
	exit
fi

selectedSSID="${AR[$selnet]}"

# check if the selected network is a known one:
knownnet=$(bash "$knets_get" "$selectedSSID")
if [ -z "$knownnet" ]; then
	# network not found among the known ones
	# ask for a password:
	echo "Enter a password for "$selectedSSID
	read password
else
	# extract the password from the tuple:
	tmpTupleFile="$workdir""/tmptpl"
	if [ -e "$tmpTupleFile" ]; then
		rm "$tmpTupleFile"
	fi
	echo "$knownnet" > "$tmpTupleFile"
	IFS=$'\t'
	read -r -a TUPLE < "$tmpTupleFile"
	password="${TUPLE[1]}"
	IFS=
fi

#sleep 1s

echo "Do you want to connect to ""$selectedSSID"" now? [y/n] "
read answer

if [ $answer = "y" ] || [ $answer = "Y" ]; then
	bash "$scriptConnect" ""$selectedSSID"" ""$password""
	if [ $? -eq 0 ]; then
		# successfully connected
		# save password for future connections
		source "$knets_add" "$selectedSSID" "$password"
		echo "CONNECTED"
	else
		echo "FAILED TO CONNECT"
	fi
fi
