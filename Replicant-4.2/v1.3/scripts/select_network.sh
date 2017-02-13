#
#	     THIS IS FREE SOFTWARE 
#
# Copyright 2016 Filippo "Fil" Bergamo
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# setup environment variables:
source "/data/misc/wifi/setup_variables.sh"
if [ $? -ne 0 ]; then
	exit 1
fi

bash "$scriptDiscon"
if [ $? -ne 0 ]; then
	exit 1
fi
sleep 1s

bash "$scriptStartWPA"
if [ $? -ne 0 ]; then
	exit 1
fi
sleep 1s


# scan for networks
echo -n "Scanning for networks... "
wpa_cli -p"$socketfile" -P"$pidfile" -i"$ifacename" scan
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
wpa_cli -p"$socketfile" -P"$pidfile" -i"$ifacename" scan_results > "$scanfile"
if [ $? -ne 0 ]; then
	exit 1
fi
#sleep 1s

# read the results in a variable:
networks=$(grep -v --invert-match '^bssid' $scanfile)

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

bash "$scriptWriteConf" "$selectedSSID" "$password" 
if [ $? -ne 0 ]; then
	exit 1
fi

#sleep 1s

echo "Do you want to connect to ""$selectedSSID"" now? [y/n] "
read answer

if [ $answer = "y" ] || [ $answer = "Y" ]; then
	bash "$scriptConnect"
	if [ $? -eq 0 ]; then
		# successfully connected
		# save password for future connections
		source "$knets_add" "$selectedSSID" "$password"
		echo "CONNECTED"
	else
		echo "FAILED TO CONNECT"
	fi
fi
