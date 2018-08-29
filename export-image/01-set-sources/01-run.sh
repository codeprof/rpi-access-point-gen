#!/bin/bash -e

on_chroot << EOF
apt-get update
apt-get -y dist-upgrade
apt-get clean
apt purge dbus -y
apt purge triggerhappy -y
apt purge rfkill -y
apt purge plymouth -y
apt purge less -y
apt purge ca-certificates -y
apt purge perl -y
apt purge alsa-utils -y #removes also raspi-config
apt purge python* -y
apt purge dosfstools -y
apt purge logrotate -y
apt purge mime-support -y
apt autoremove -y
EOF
