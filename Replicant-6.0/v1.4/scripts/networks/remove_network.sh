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

# parse arguments <bssid>
if [ $# -eq 0 ]; then
	echo "Missing arguments <bssid> "
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Wrong argument count!"
	exit 1
fi

curnet=$1
# check if the known networks file exists
if ! [ -e "$knets_file" ]; then
	exit 0
fi

# read the results in a variable:
# modified Feb 1st 2017: 
# seems like the previously used option --invert-match is not POSIX.
# the version of "grep" on Replicant 6.0 misses this option.
# the option -v is used instead
# get all file contents that do not begin with the bssid of the network to remove.
# read the file, omitting comments:
keptLines=$(grep -v "^$curnet" "$knets_file")

# overwrite the file, keeping only the filtered lines
echo "$keptLines" > "$knets_file"


