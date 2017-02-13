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

globresult=0

# check, for every module, if it is running,
# if not, insmod it.


# ---- mac80211 ----
mod=$(ls /sys/module | grep -c -Fx "mac80211")
if [ "$mod" = "0" ]; then
	echo -n -e "\tloading module mac80211.ko ..."
	insmod $mod_mac80211
	if [ $? = 0 ]; then
		echo " [ OK! ]"
	else
		globresult=1
		echo " [* FAIL! *]"
	fi
else
	echo -e "\tmac80211.ko already loaded [ OK! ]"
fi



# ---- ath.ko ----
mod=$(ls /sys/module | grep -c -Fx "ath")
if [ "$mod" = "0" ]; then
	echo -n -e "\tloading module ath.ko ..."
	insmod "$mod_ath"
	if [ $? = 0 ]; then
		echo " [ OK! ]"
	else
		globresult=-1
		echo " [* FAIL! *]"
	fi
else
	echo -e "\tath.ko already loaded [ OK! ]"
fi



# ---- ath9k_hw ----
mod=$(ls /sys/module | grep -c -Fx "ath9k_hw")
if [ "$mod" = "0" ]; then
	echo -n -e "\tloading module ath9k_hw.ko ..."
	insmod "$mod_ath9k_hw"
	if [ $? = 0 ]; then
		echo " [ OK! ]"
	else
		globresult=1
		echo " [* FAIL! *]"
	fi
else
	echo -e "\tath9k_hw.ko already loaded [ OK! ]"
fi



# ---- ath9k_common ----
mod=$(ls /sys/module | grep -c -Fx "ath9k_common")
if [ "$mod" = "0" ]; then
	echo -n -e "\tloading module ath9k_common.ko ..."
	insmod "$mod_ath9k_common"
	if [ $? = 0 ]; then
		echo " [ OK! ]"
	else
		globresult=1
		echo " [* FAIL! *]"
	fi
else
	echo -e "\tath9k_common.ko already loaded [ OK! ]"
fi



# ---- ath0k_htc ----
mod=$(ls /sys/module | grep -c -Fx "ath9k_htc")
if [ "$mod" = "0" ]; then
	echo -n -e "\tloading module ath9k_htc.ko ..."
	insmod "$mod_ath9k_htc"
	if [ $? = 0 ]; then
		echo " [ OK! ]"
	else
		globresult=1
		echo " [* FAIL! *]"
	fi
else
	echo -e "\tath9k_htc.ko already loaded [ OK! ]"
fi



# check for global result:
if [ "$globresult" -lt 0 ]; then
	echo "ERRORS loading one or more modules.."
	echo "Try re-running the script.."
	exit $globresult
else
	echo "All modules loaded!"
fi


