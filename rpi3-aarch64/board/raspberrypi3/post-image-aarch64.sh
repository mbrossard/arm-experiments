#!/bin/sh

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOARD_NAME}-aarch64.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"
# copy Image to kernel8.img
cp ${BINARIES_DIR}/Image ${BINARIES_DIR}/kernel8.img

echo "add arm_64bit=1 in ${BINARIES_DIR}/rpi-firmware/config.txt"
grep -v '^kernel=' output/images/rpi-firmware/config.txt | grep -v '^arm_64bit=' | cat > ${BINARIES_DIR}/rpi-firmware/config.txt
echo "arm_64bit=1" >> ${BINARIES_DIR}/rpi-firmware/config.txt

genimage                           \
    --rootpath "${TARGET_DIR}"     \
    --tmppath "${GENIMAGE_TMP}"    \
    --inputpath "${BINARIES_DIR}"  \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"
