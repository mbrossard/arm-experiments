# rpi3-aarch64

Building a customized buildroot image for a Raspberry Pi 3 with an
AArch64 kernel and 64 bit user-space.

Work based on Maik Scholz patch.

> git clone git://git.buildroot.net/buildroot buildroot

Clone a copy of the buildroot repository.

> cat patches/rpi-firmware-aarch64.patch | (cd buildroot ; patch -p1)

Apply a patch to use a firmware version compatible with AArch64

> make -C buildroot BR2_EXTERNAL=$PWD rpi3-aarch64_defconfig

Configure buildroot to use our modifications.

> make -C buildroot

Compile everything.

If everything works according to plans, a disk image should appear at:

> buildroot/output/images/sdcard.img
