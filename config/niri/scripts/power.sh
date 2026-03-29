#!/bin/bash

lock=" Lock"
reboot=" Reboot"
shutdown="⏻ Shutdown"

options="$lock\n$reboot\n$shutdown"

chosen="$(echo -e "$options" | wofi --dmenu --insensitive --width 500 --lines 4)"

case $chosen in
$lock)
    sleep 0.2
    pidof swaylock || swaylock
    ;;
$reboot)
    systemctl reboot
    ;;
$shutdown)
    systemctl poweroff
    ;;
esac
