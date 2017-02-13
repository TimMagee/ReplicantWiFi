#!/system/bin/bash
#
# Copyright (C) 2017 Wolfgang Wiedmeyer <wolfgit@wiedmeyer.de>
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

# Set SSID and password of your wifi access point
# WPA-Personal authentication method is assumed
SSID="$1"
PASSWORD="$2"

wpa_comm="wpa_cli -p$socketfile -P$pidfile -i$ifacename"

sup_pid=$(pidof wpa_supplicant)
dhcp_pid=$(pidof dhcpcd)

if ! [ -z "$sup_pid" ]; then
	killall -SIGINT wpa_supplicant
fi

if ! [ -z "$dhcp_pid" ]; then
	killall -SIGINT dhcpcd
fi

sleep 1s

ndc network destroy 1
ndc interface clearaddrs "$ifacename"

# seems like explicitly pulling up the interface is necessary..
# without this step, the interface gets removed during the execution of the script.
ifconfig "$ifacename" up

wpa_supplicant -B -dd -i"$ifacename" -C"$socketfile" -P"$pidfile" -I/system/etc/wifi/wpa_supplicant_overlay.conf -e/data/misc/wifi/entropy.bin

sleep 1s

if [ $? -ne 0 ]; then
	echo "[DEBUG]starting wpa_supplicant FAILED!"
	exit 1
fi

$wpa_comm add_network
if [ $? -ne 0 ]; then
	echo "[DEBUG]add_network FAILED!"
	exit 1
fi
$wpa_comm set_network 0 ssid '"'"$SSID"'"'
if [ $? -ne 0 ]; then
	echo "[DEBUG]set_network ssid FAILED!"
	exit 1
fi
$wpa_comm set_network 0 psk '"'"$PASSWORD"'"'
if [ $? -ne 0 ]; then
	echo "[DEBUG]set_network psk FAILED!"
	exit 1
fi
$wpa_comm select_network 0
if [ $? -ne 0 ]; then
	echo "[DEBUG]select_network 0 FAILED!"
	exit 1
fi
$wpa_comm enable_network 0
if [ $? -ne 0 ]; then
	echo "[DEBUG] enable_network 0 FAILED!"
	exit 1
fi
$wpa_comm reassociate
if [ $? -ne 0 ]; then
	echo "[DEBUG] reassociate FAILED!"
	exit 1
fi

# negotiate a dhcp leasing
dhcpcd "$ifacename"

# get gateway
gateway=$(ip route show 0.0.0.0/0 dev wlan0 | cut -d\  -f3)

ndc network create 1
ndc network interface add 1 "$ifacename"
ndc network route add 1 "$ifacename"  0.0.0.0/0 "$gateway"
ndc resolver setnetdns 1 "" "$ipDNS1" "$ipDNS2"
ndc network default set 1
