#!/bin/bash -e

install -m 640 files/cmdline.txt "${ROOTFS_DIR}/boot/"
install -m 640 files/config.txt "${ROOTFS_DIR}/boot/"
