#!/bin/sh

BOARD_DIR="$(dirname $0)"
BOARD_NAME="rpi2-gps"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Mark the kernel as DT-enabled
mkdir -p "${BINARIES_DIR}/kernel-marked"
${HOST_DIR}/usr/bin/mkknlimg "${BINARIES_DIR}/zImage" \
	"${BINARIES_DIR}/kernel-marked/zImage"

echo "console=tty1 root=/dev/mmcblk0p2 rootwait" > "${BINARIES_DIR}/rpi-firmware/cmdline.txt"
if ! [ grep -q pps-gpio "${BINARIES_DIR}/rpi-firmware/config.txt" ] ; then \
    echo "dtoverlay=pps-gpio,gpiopin=4" >> "${BINARIES_DIR}/rpi-firmware/config.txt" ; \
fi

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
