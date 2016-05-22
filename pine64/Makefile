#

DEBIAN=stretch
SOURCE=http://ftp.debian.org/debian

all: .kernel.install

check-dependencies:
	sudo apt-get install -y git mount dosfstools parted debootstrap binfmt-support qemu qemu-user-static
	sudo apt-get install -t testing gcc-aarch64-linux-gnu

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

.bootstrap.first: .mount.partitions
	sudo debootstrap --foreign --arch=arm64 --include=vim,locales,dialog,apt $(DEBIAN) ./root $(SOURCE)
	touch .boostrap.first

.bootstrap.second: .bootstrap.first .mount.vfs
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
		rm .mount.partitions ; \
	fi

.kernel.checkout:
	if [ -d linux-pine64 ] ; then \
		git clone https://github.com/longsleep/linux-pine64 ; \
	    (cd linux-pine64 ; git checkout pine64-hacks-1.2) ; \
	else \
		(cd linux-pine64 ; git pull) ; \
	fi
	touch .kernel.checkout

sun50i-a64-pine64-plus.dts:
	curl -sSL https://github.com/longsleep/build-pine64-image/raw/master/blobs/pine64.dts > $@

.kernel.compile: .kernel.checkout sun50i-a64-pine64-plus.dts
	make -C linux-pine64 ARCH=arm64 sun50iw1p1smp_linux_defconfig
	cp sun50i-a64-pine64-plus.dts linux-pine64/arch/arm64/boot/dts
	make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j 4 Image sun50i-a64-pine64-plus.dtb modules
	touch .kernel.compile

.kernel.install: .kernel.compile .mount.vfs
	mkdir -p boot/pine64
	cp linux-pine64/arch/arm64/boot/dts/sun50i-a64-pine64-plus.dtb linux-pine64/arch/arm64/boot/Image boot/pine64
	make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=$PWD/root/boot
	make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_FW_PATH=$PWD/root/lib/firmware
	touch .kernel.install

clean-kernel:
	rm -rf .kernel.checkout .kernel.compile .kernel.install
