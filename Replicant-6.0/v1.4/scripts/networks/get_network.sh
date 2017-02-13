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

# modified Feb 1st 2017: 
# seems like the previously used option --invert-match is not POSIX.
# the version of "grep" on Replicant 6.0 misses this option.
# the option -v is used instead
# read the file, omitting comments:
networks=$(grep -v '^#' $knets_file)

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

