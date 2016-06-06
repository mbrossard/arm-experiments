# rpi0-otg

Build a minimal customized buidlroot image for Raspberry Pi Zero with
support for OTG. Compared to a minimal build from buildroot it should
allow to connect the Raspberry Pi to a computer and use the USB cable
for power and as a serial connection.

## Build instructions

> git clone git://git.buildroot.net/buildroot buildroot

Clone a copy of the buildroot repository.

> make -C buildroot BR2_EXTERNAL=$PWD rpi0-otg_defconfig

Configure buildroot to use our modifications.

> make -C buildroot

Compile everything.
