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

