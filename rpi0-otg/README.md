# rpi0-otg

Build a minimal customized buidlroot image for Raspberry Pi 0 with
support for OTG.

## Instructions

> git clone git://git.buildroot.net/buildroot buildroot

Clone a copy of the buildroot repository.

> make -C buildroot BR2_EXTERNAL=$PWD rpi0-otg_defconfig

Configure buildroot to use our modifications.

> make -C buildroot

Compile everything.
