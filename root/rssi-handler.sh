#!/bin/sh
#
# Small state script to track whether the RSSI meter is currently running or
# not - this is a hook from /etc/rc.button/reset, which will call this scripts
# for single, short button presses.

STATEFILE="/tmp/rssibar.state"

if [ $# -eq 1 ]; then
    case $1 in
        "up"|"on")
            STATE=off
        ;;
        "down"|"off")
            STATE=on
        ;;
    esac
else
    if [ ! -e ${STATEFILE} ]; then
        STATE=on
    else
        . ${STATEFILE}
    fi
fi
if [ -z ${STATE} ]; then
    STATE=on
fi

if [ ${STATE} == "on" ]; then
    logger "Received signal to kill the RSSI LED indicator."
    killall rssi.sh
    /etc/init.d/led restart
    STATE=off
else
    logger "Received signal to start the RSSI LED indicator."
    /root/rssi.sh &
    STATE=on
fi

echo "STATE=${STATE}" > ${STATEFILE}
