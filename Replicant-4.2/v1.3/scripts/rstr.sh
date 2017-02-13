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

echo "Beginning a best-effort attempt to setup/restore Libre WiFi connectivity:"

idx=1

echo -n $idx") chmod -R 777 $workdir... "
chmod -R 777 $workdir
if [ $? = 0 ]; then
	echo " [ OK! ]"
else
	echo " [* FAIL! *]"
fi

if [ -e "$wpaconfile" ]; then

	idx=$(($idx+1))
	echo -n $idx") chmod 777 "$wpaconfile"... "
	chmod 777 "$wpaconfile"
	if [ $? = 0 ]; then
		echo " [ OK! ]"
	else
		echo " [* FAIL! *]"
	fi
fi

idx=$(($idx+1))
echo $idx") Check and load needed modules:"
source "$scriptChkMod"

