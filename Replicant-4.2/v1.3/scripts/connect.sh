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

# terminate both dhcpcd and wpa_supplicant, in case there are previous connections pending...
bash "$scriptDiscon"

# launch wpa_supplicant on interface wlan0
# specifing our custom configuration and the socket file
wpa_supplicant -B -dd -i"$ifacename" -c"$wpaconfile" -P"$pidfile"

# negotiate a dhcp leasing
dhcpcd "$ifacename"

# set DNS's
setprop net.dns1 "$ipDNS1"
setprop net.dns2 "$ipDNS2"

# re-give permissions on the pid file and on the socket folder,
# in case wpa_supplicant changed them,
# to be still able to interact with wpa_cli
chmod 777 "$pidfile"
chmod -R 777 "$socketfile"

# read wpa status, to check if connection was successfull:
state_variable="wpa_state"
status_connected="COMPLETED"

wpastatus=$(wpa_cli -p$socketfile -P$pidfile -i$ifacename status)
if [ $? -ne 0 ]; then
	exit 1
fi
#sleep 2s

tmpStatusFile="$workdir""/tmpStus"
if [ -e "$tmpStatusFile" ]; then
	rm "$tmpStatusFile"
fi
echo "$wpastatus" > "$tmpStatusFile"

tmpLineFile="$workdir""/tmpln"

# loop through wpa_cli's output, to find the wpa_state field:
while IFS= read -r line
do
	if [ -e "$tmpLineFile" ]; then
		rm "$tmpLineFile"
	fi
	echo "$line" > "$tmpLineFile"
	# split the line into couples of <property>=<value>:
	IFS='='
	read -r -a FIELDS < "$tmpLineFile"
	IFS=
	if [ "${FIELDS[0]}" = "$state_variable" ]; then
		# found the status property. Read its value:
		currentStatus="${FIELDS[1]}"
		if [ "$currentStatus" = "$status_connected" ]; then
			# exit with success
			exit 0
		else
			# exit fail
			exit 1
		fi
	fi
	idx=$(($idx+1))
done < "$tmpStatusFile"


