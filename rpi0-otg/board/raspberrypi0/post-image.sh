#!/bin/sh

BOARD_DIR="$(dirname $0)"
BOARD_NAME="rpi0-otg"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Mark the kernel as DT-enabled
mkdir -p "${BINARIES_DIR}/kernel-marked"
${HOST_DIR}/usr/bin/mkknlimg "${BINARIES_DIR}/zImage" \
	"${BINARIES_DIR}/kernel-marked/zImage"

echo "console=tty1 root=/dev/mmcblk0p2 rootwait modules-load=dwc2,g_serial" > "${BINARIES_DIR}/rpi-firmware/cmdline.txt"
grep -qE dwc2 "${BINARIES_DIR}/rpi-firmware/config.txt" || \
echo "dtoverlay=dwc2" >> "${BINARIES_DIR}/rpi-firmware/config.txt"

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"

exit $?
