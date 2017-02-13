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

# parse arguments <ssid> <password>
if [ $# -eq 0 ]; then
	echo "Missing arguments <ssid> <password> "
	exit 1
fi

if [ $# -ne 2 ]; then
	echo "Wrong argument count!"
	exit 1
fi

curnet=$1
pass=$2
foundnet=$(bash "$knets_get" "$curnet")
if ! [ -z "$foundnet" ]; then
	# the network is already a known one,
	# remove it from the list, before adding the new password
	source "$knets_rem" "$curnet"
fi

if ! [ -e "$knets_file" ]; then
	echo -n "" > "$knets_file"
fi

echo -e "$curnet""\t""$pass" >> $knets_file
