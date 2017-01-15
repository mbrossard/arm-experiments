# rpi3-aarch64

Building a customized buildroot image for a Raspberry Pi 3 with an
AArch64 kernel and 64 bit user-space.

> git clone git://git.buildroot.net/buildroot buildroot

Clone a copy of the buildroot repository.

> make -C buildroot BR2_EXTERNAL=$PWD rpi3-aarch_defconfig

Configure buildroot to use our modifications.

> make -C buildroot

Compile everything.

If everything works according to plans, a disk image should appear at:

> buildroot/output/images/sdcard.img
