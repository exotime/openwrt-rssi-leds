#!/bin/sh
#
# Create a bar graph of the wireless signal strength (RSSI) using the LEDs on
# the front of the device.
#
# This script will continue to run until interrupted.

AVLEDS=`ls /sys/class/leds`
ELED=`ls /sys/class/leds|grep -wo -m1 "$1"`
OLD_STRENGTH=-1

# Led order (right to left)
LED1="alfa:blue:wan"
LED2="alfa:blue:usb"
LED3="alfa:blue:lan"
LED4="alfa:blue:wlan"

Led_On() {
    echo 255 > /sys/class/leds/$1/brightness
}

Led_Off() {
    echo 0 > /sys/class/leds/$1/brightness
}

Led_Reset() {
    /etc/init.d/led restart
    echo "Got Ctrl-C, quitting."
    exit
}

trap Led_Reset 2;

# Turn off all of the LEDs.
echo none > /sys/class/leds/$LED1/trigger
echo none > /sys/class/leds/$LED2/trigger
echo none > /sys/class/leds/$LED3/trigger
echo none > /sys/class/leds/$LED4/trigger

# Loop until interrupted, update the LED "display"
while true ; do
    RSSI=`cat /proc/net/wireless | awk 'NR==3 {print $4}' | sed 's/\.//'`
    if [ -z $RSSI ] || [ $RSSI -ge 0 ]; then
        STRENGTH=0 # Error
    elif [ $RSSI -ge -65 ] ; then
        STRENGTH=4 # Excellent
    elif [ $RSSI -ge -73 ] ; then
        STRENGTH=3 # Good
    elif [ $RSSI -ge -80 ] ; then
        STRENGTH=2 # Fair
    elif [ $RSSI -ge -94 ] ; then
        STRENGTH=1 # Bad
    else
        STRENGTH=0
    fi

    # Convert the integer we determined above to a sequence of LEDs, if the
    # result is different to the last iteration.
    if [ $OLD_STRENGTH != $STRENGTH ] ; then
        case $STRENGTH in
            4)  Led_On  $LED1; Led_On  $LED2; Led_On  $LED3; Led_On  $LED4 ;;
            3)  Led_On  $LED1; Led_On  $LED2; Led_On  $LED3; Led_Off $LED4 ;;
            2)  Led_On  $LED1; Led_On  $LED2; Led_Off $LED3; Led_Off $LED4 ;;
            1)  Led_On  $LED1; Led_Off $LED2; Led_Off $LED3; Led_Off $LED4 ;;
            0)  Led_Off $LED1; Led_Off $LED2; Led_Off $LED3; Led_Off $LED4 ;;
        esac
        echo "Signal Strength (0-4): $STRENGTH, RSSI (dB): $RSSI"
    fi

    OLD_STRENGTH=$STRENGTH

    # Update once per second.
    sleep 1
done
