
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
