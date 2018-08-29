#!/bin/bash -e

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi

on_chroot << EOF
export LANGUAGE=e_DE.UTF-8
export LANG=e_DE.UTF-8
export LC_ALL=e_DE.UTF-8
locale-gen e_DE.UTF-8
EOF
