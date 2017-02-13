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

suppid=$(pidof wpa_supplicant)
dhcppid=$(pidof dhcpcd)

if ! [ -z "$suppid" ]; then
	killall -SIGINT wpa_supplicant
fi

if ! [ -z "$dhcppid" ]; then
	killall -SIGINT dhcpcd
fi

exit 0
