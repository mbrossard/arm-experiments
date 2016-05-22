
all: .kernel.compile

.kernel.checkout:
	if [ -d linux-pine64 ] ; then \
		git clone https://github.com/longsleep/linux-pine64 ; \
	    (cd linux-pine64 ; git checkout pine64-hacks-1.2) ; \
	fi
	touch .kernel.checkout

sun50i-a64-pine64-plus.dts:
	curl -sSL https://github.com/longsleep/build-pine64-image/raw/master/blobs/pine64.dts > $@

.kernel.compile: .kernel.checkout sun50i-a64-pine64-plus.dts
	make -C linux-pine64 ARCH=arm64 sun50iw1p1smp_linux_defconfig
	cp sun50i-a64-pine64-plus.dts linux-pine64/arch/arm64/boot/dts
	make -C linux-pine64 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j 4 Image sun50i-a64-pine64-plus.dtb modules
	touch .kernel.compile
