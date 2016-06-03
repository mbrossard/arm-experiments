#!/bin/sh

set -u
set -e

grep -qE 'g_serial' ${TARGET_DIR}/etc/inittab || \
perl -i -pe 's|(/etc/hostname)|$1\n::sysinit:/sbin/modprobe g_serial|' ${TARGET_DIR}/etc/inittab

# Add a console on ttyAMA0 tty1
grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab

grep -qE 'ttyGS0' ${TARGET_DIR}/etc/inittab || \
perl -i -pe 's|(tty1)|ttyGS0::respawn:/sbin/getty -L ttyGS0 0 vt100\n$1|' ${TARGET_DIR}/etc/inittab
