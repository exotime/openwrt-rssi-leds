## Synopsis

This is a small project to display wireless signal strength (RSSI) as a crude bar graph across the LEDs on front of an [Alfa AP121U](https://wiki.openwrt.org/toh/alfa.network/hornet-ub) running OpenWRT 12.09 (Attitude Adjustment).

## Motivation

I had two of these devices with directional, parabolic antennas that I needed to align over a significant distance - this allowed me to simply yet roughly tune them to an optimal angle.

## Origin

It is originally based on the scripts available on the [OpenWRT Wiki](https://wiki.openwrt.org/doc/howto/led.wifi.meter), but with the following modifications:

 * LEDs remapped to suit Alfa AP121U
 * LED pattern remapped to be from left-to-right, instead of right-to-left
 * Faster LED refresh
 * Hook to the WPS button:
   * Press the button down (for less than one second) to enable the RSSI meter
   * Press the button again to disable the RSSI meter and return to normal LED functionality
   * **Warning:** Holding for ten consecutive seconds will factory reset the device (jffs2reset).
   * **NOTE:** There is a bug in Attitude Adjustment, which has the WPS and RESET buttons configured backwards - so, pressing the WPS button would trigger RESET, and vice-versa. This broken functionality is handled in the script. If you're running Breaking Barrier 14.07 or higher, you'll want to rename the reset file in rc.button.

## Installation

Copy the files onto your OpenWRT device (the project files follow the root filesystem layout).

Reboot your OpenWRT device to have the /etc/rc.button/reset hook read by the system.

## Contributors

Pull requests welcome.

## License

This is licensed with the MIT license, to keep things simple.
