root_dir="/data/misc/wifi"
adb root
sleep 3
adb shell rm -r "$root_dir"
adb shell mkdir "$root_dir"
adb push ./scripts "$root_dir"
adb push ./scripts/networks "$root_dir""/networks"
