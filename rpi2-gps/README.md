= rpi2-gps

Building a customized buildroot image for a Raspberry Pi 2 paired with
an Adafruit Ultimate GPS HAT for Raspberry Pi, in order to use it as a
reliable source of time.

> git clone git://git.buildroot.net/buildroot buildroot

> make -C buildroot BR2_EXTERNAL=$PWD rpi2-gps_defconfig

> make -C buildroot
