#
#	     THIS IS FREE SOFTWARE 
#
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


