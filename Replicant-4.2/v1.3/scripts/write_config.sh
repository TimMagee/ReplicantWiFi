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
	exit
fi

#read SSID and password from command line:
ssid=$1
pass=$2

#check if config file exists
if [ -e $wpaconfile ]; then
	rm $wpaconfile
fi

#write fixed lines:
echo -e "ctrl_interface=DIR=""$socketfile""
update_config=1
network={
\tssid=\"$ssid\"
\tpsk=\"$pass\"
}" > $wpaconfile

chmod 777 "$wpaconfile"

echo "Network connection has been set up for "$ssid"!"


