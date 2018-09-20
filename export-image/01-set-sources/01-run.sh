#!/bin/bash -e

on_chroot << EOF
apt-get update
apt-get -y dist-upgrade
apt-get clean
apt purge dbus -y
apt purge triggerhappy -y
apt purge rfkill -y
apt purge plymouth -y
apt purge ca-certificates -y
apt purge perl -y
apt purge alsa-utils -y #removes also raspi-config
apt purge python* -y
apt purge dosfstools -y
apt purge logrotate -y
apt purge mime-support -y
apt purge info -y
apt purge traceroute -y
apt purge netcat* -y
apt purge rsyslog -y
apt purge wget -y
apt purge whois -y
apt autoremove -y
EOF
