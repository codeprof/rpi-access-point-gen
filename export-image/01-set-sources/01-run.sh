#!/bin/bash -e

on_chroot << EOF
apt-get update
apt-get -y dist-upgrade
apt-get clean
apt purge dbus -y
apt purge triggerhappy -y
apt purge rfkill -y
apt purge plymouth -y
apt autoremove -y
EOF
