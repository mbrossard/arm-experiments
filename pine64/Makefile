#

DEBIAN=stretch
SOURCE=http://ftp.debian.org/debian
UBOOT=apritzel

all: .bootstrap .kernel.install .firmware.compile .u-boot-$(UBOOT).compile .sunxi-tools.compile
	$(MAKE) .finalize

check-dependencies:
	sudo apt-get install -y git mount dosfstools parted debootstrap binfmt-support qemu qemu-user-static
	sudo apt-get install -t testing gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf device-tree-compiler

.disk.img:
	dd if=/dev/zero of=disk.img bs=1M count=4096
	sudo losetup /dev/loop0 disk.img
	sudo parted -s /dev/loop0 mklabel msdos
	sudo parted -s /dev/loop0 unit cyl mkpart primary fat32 -- 0 16
	sudo parted -s /dev/loop0 set 1 boot on
	sudo parted -s /dev/loop0 unit cyl mkpart primary ext2 -- 16 -2
	sudo mkfs.vfat -n Boot /dev/loop0p1
	sudo mkfs.ext4 -L Root /dev/loop0p2
	sudo losetup -d /dev/loop0
	touch .disk.img

.mount.partitions: .disk.img
	sudo losetup /dev/loop0 disk.img
	mkdir -p root boot
	sudo mount /dev/loop0p1 ./boot
	sudo mount /dev/loop0p2 ./root
	touch .mount.partitions

.mount.vfs: .mount.partitions
	sudo mount -o bind /dev ./root/dev
	sudo mount -o bind /dev/pts ./root/dev/pts
	sudo mount -o bind /sys ./root/sys
	sudo mount -o bind /proc ./root/proc
	sudo cp /proc/mounts ./root/etc/mtab
	sudo cp /usr/bin/qemu-aarch64-static ./root/usr/bin
	touch .mount.vfs

.bootstrap.first:
	$(MAKE) .mount.partitions
	sudo debootstrap --foreign --arch=arm64 --include=vim,locales,dialog,apt $(DEBIAN) ./root $(SOURCE)
	touch .boostrap.first

.bootstrap.second:
	$(MAKE) .bootstrap.first .mount.vfs
	sudo cp second-stage ./root
	sudo LC_ALL=C LANGUAGE=C LANG=C chroot ./root bash /second-stage $(DEBIAN)
	sudo rm ./root/second-stage 
	touch .bootstrap.second

.finalize:
	if [ -f .mount.vfs ] ; then \
		sudo umount -lf ./root/dev/pts ; \
		sudo umount -lf ./root/sys	   ; \
		sudo umount -lf ./root/dev	   ; \
		sudo umount -lf ./root/proc    ; \
		sudo rm -f ./root/etc/mtab ./root/usr/bin/qemu-aarch64-static ; \
		rm .mount.vfs ; \
	fi
	if [ -f .mount.partitions ] ; then \
		sudo umount ./boot ; \
		sudo umount ./root ; \
		sudo losetup -d /dev/loop0 ; \
		rm .mount.partitions ; \
	fi

.kernel.checkout:
	if ! [ -d linux-pine64 ] ; then \
		git clone --depth 1 --single-branch -b pine64-hacks-1.2 https://github.com/longsleep/linux-pine64 ; \
	else \
		(cd linux-pine64 ; git pull) ; \
	fi
	touch .kernel.checkout

.blobs.checkout:
	if ! [ -d build-pine64-image ] ; then \
		git clone https://github.com/longsleep/build-pine64-image.git ; \
	else \
		(cd build-pine64-image ; git pull) ; \
	fi
	touch .blobs.checkout

.kernel.compile: .kernel.checkout .blobs.checkout
	make -C linux-pine64 ARCH=arm64 sun50iw1p1smp_linux_defconfig
	cp build-pine64-image/blobs/pine64.dts linux-pine64/arch/arm64/boot/dts/sun50i-a64-pine64-plus.dts
	make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j 4 Image sun50i-a64-pine64-plus.dtb modules
	touch .kernel.compile

.kernel.install: .kernel.compile
	$(MAKE) .mount.vfs
	sudo mkdir -p boot/pine64
	sudo cp linux-pine64/arch/arm64/boot/dts/sun50i-a64-pine64-plus.dtb linux-pine64/arch/arm64/boot/Image boot/pine64
	sudo make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=$PWD/root/boot
	sudo make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_FW_PATH=$PWD/root/lib/firmware
	touch .kernel.install
.u-boot-longsleep.checkout:
	if ! [ -d u-boot-longsleep ] ; then \
		git clone --depth 1 --branch pine64-hacks --single-branch https://github.com/longsleep/u-boot-longsleep.git u-boot-longsleep ; \
	else \
		(cd u-boot-longsleep ; git pull) ; \
	fi
	touch .u-boot-longsleep.checkout

.u-boot-longsleep.compile: .u-boot-longsleep.checkout
	make -C u-boot-longsleep sun50iw1p1_config
	make -C u-boot-longsleep ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
	touch .u-boot-longsleep.compile

.u-boot-apritzel.checkout:
	if ! [ -d u-boot-apritzel ] ; then \
		git clone --depth 1 --branch pine64 --single-branch https://github.com/apritzel/u-boot u-boot-apritzel ; \
	else \
		(cd u-boot-apritzel ; git pull) ; \
	fi
	touch .u-boot-apritzel.checkout

.u-boot-apritzel.compile: .u-boot-apritzel.checkout
	make -C u-boot-apritzel pine64_defconfig
	make -C u-boot-apritzel ARCH=arm CROSS_COMPILE=aarch64-linux-gnu-
	touch .u-boot-apritzel.compile

.firmware.checkout:
	if ! [ -d arm-trusted-firmware-pine64 ] ; then \
		git clone --depth 1 --branch allwinner --single-branch https://github.com/apritzel/arm-trusted-firmware.git arm-trusted-firmware-pine64 ; \
	else \
		(cd arm-trusted-firmware-pine64 ; git pull) ; \
	fi
	touch .firmware.checkout

.firmware.compile: .firmware.checkout
	make -C arm-trusted-firmware-pine64 ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- PLAT=sun50iw1p1 bl31
	touch .firmware.compile

.sunxi-tools.checkout:
	if ! [ -d sunxi-pack-tools ] ; then \
		git clone https://github.com/longsleep/sunxi-pack-tools.git sunxi-pack-tools ; \
	else \
		(cd sunxi-pack-tools ; git pull) ; \
	fi
	touch .sunxi-tools.checkout

.sunxi-tools.compile: .sunxi-tools.checkout
	make -C sunxi-pack-tools
	touch .sunxi-tools.compile

clean-kernel:
	rm -rf .kernel.checkout .kernel.compile .kernel.install

