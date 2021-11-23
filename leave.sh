#!/bin/sh

actions="lock\nlogout\nreboot\nshutdown"
selection=$(echo -e $actions | dmenu)

case "$selection" in
    lock)
        FILE='/tmp/i3lock'
        scrot -z $FILE
        convert $FILE -blur '5x4' $FILE
        i3lock -p default -u -i $FILE
        rm $FILE
        ;;
    logout)
        i3-msg exit
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        exit 2
        ;;
esac

exit 0
