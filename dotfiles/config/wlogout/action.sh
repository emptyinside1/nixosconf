#!/usr/bin/env bash
echo "Action called with arg: $1 at $(date)" >> /tmp/wlogout_debug.log
case "$1" in
    lock)
        /home/daniil/.config/hypr/scripts/LockScreen.sh >> /tmp/wlogout_debug.log 2>&1
        ;;
    logout)
        hyprctl dispatch exit >> /tmp/wlogout_debug.log 2>&1
        ;;
    shutdown)
        systemctl poweroff -i >> /tmp/wlogout_debug.log 2>&1
        ;;
    reboot)
        systemctl reboot >> /tmp/wlogout_debug.log 2>&1
        ;;
    suspend)
        systemctl suspend >> /tmp/wlogout_debug.log 2>&1
        ;;
    hibernate)
        systemctl hibernate >> /tmp/wlogout_debug.log 2>&1
        ;;
esac
