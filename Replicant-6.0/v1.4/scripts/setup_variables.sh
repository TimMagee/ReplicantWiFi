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

# working directory path
export workdir="/data/misc/wifi"

# network parameters
export ifacename="wlan0"
export ipDNS1="193.183.98.154"
export ipDNS2="87.98.175.85"

# aux files
export scanfile="$workdir""/scanres.txt"
export socketfile="$workdir""/sockets"
export pidfile="$workdir""/pidfile"
export wpaconfile="$workdir""/wpa_supplicant.conf"

# script paths
export scriptChkMod="$workdir""/check_modules.sh"
export scriptWriteConf="$workdir""/write_config.sh"
export scriptStartWPA="$workdir""/startwpa.sh"
export scriptConnect="$workdir""/connect.sh"
export scriptDiscon="$workdir""/disconnect.sh"

# kernel modules
export modulesPath="/system/lib/modules"
export mod_mac80211="$modulesPath""/mac80211.ko"
export mod_ath="$modulesPath""/ath.ko"
export mod_ath9k_hw="$modulesPath""/ath9k_hw.ko"
export mod_ath9k_common="$modulesPath""/ath9k_common.ko"
export mod_ath9k_htc="$modulesPath""/ath9k_htc.ko"

# known networks database
export knets_dir="networks"
export knets_file="$workdir""/""$knets_dir""/known-networks"
export knets_add="$workdir""/""$knets_dir""/add_network.sh"
export knets_rem="$workdir""/""$knets_dir""/remove_network.sh"
export knets_get="$workdir""/""$knets_dir""/get_network.sh"
