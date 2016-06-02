# rpi2-gps

Building a customized buildroot image for a Raspberry Pi 2 paired with
an Adafruit Ultimate GPS HAT for Raspberry Pi, in order to use it as a
reliable source of time.

> git clone git://git.buildroot.net/buildroot buildroot

Clone a copy of the buildroot repository.

> make -C buildroot BR2_EXTERNAL=$PWD rpi2-gps_defconfig

Configure buildroot to use our modifications.

> make -C buildroot

Compile everything.

If everythin works according to plans, a disk image should appear at

> buildroot/output/images/sdcard.img
