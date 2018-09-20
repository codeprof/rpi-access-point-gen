#!/bin/bash -e

IMG_FILE="${STAGE_WORK_DIR}/${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.img"
INFO_FILE="${STAGE_WORK_DIR}/${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.info"

on_chroot << EOF
/etc/init.d/fake-hwclock stop
hardlink -t /usr/share/doc
EOF

if [ -d "${ROOTFS_DIR}/home/master/.config" ]; then
	chmod 700 "${ROOTFS_DIR}/home/master/.config"
fi

rm -f "${ROOTFS_DIR}/etc/apt/apt.conf.d/51cache"
rm -f "${ROOTFS_DIR}/usr/bin/qemu-arm-static"

rm -f "${ROOTFS_DIR}/etc/apt/sources.list~"
rm -f "${ROOTFS_DIR}/etc/apt/trusted.gpg~"

rm -f "${ROOTFS_DIR}/etc/passwd-"
rm -f "${ROOTFS_DIR}/etc/group-"
rm -f "${ROOTFS_DIR}/etc/shadow-"
rm -f "${ROOTFS_DIR}/etc/gshadow-"
rm -f "${ROOTFS_DIR}/etc/subuid-"
rm -f "${ROOTFS_DIR}/etc/subgid-"

rm -f "${ROOTFS_DIR}"/var/cache/debconf/*-old
rm -f "${ROOTFS_DIR}"/var/lib/dpkg/*-old

rm -f "${ROOTFS_DIR}"/usr/share/icons/*/icon-theme.cache

rm -f "${ROOTFS_DIR}/var/lib/dbus/machine-id"

true > "${ROOTFS_DIR}/etc/machine-id"

ln -nsf /proc/mounts "${ROOTFS_DIR}/etc/mtab"

find "${ROOTFS_DIR}/var/log/" -type f -exec cp /dev/null {} \;

rm -f "${ROOTFS_DIR}/root/.vnc/private.key"
rm -f "${ROOTFS_DIR}/etc/vnc/updateid"

update_issue "$(basename "${EXPORT_DIR}")"
install -m 640 "${ROOTFS_DIR}/etc/rpi-issue" "${ROOTFS_DIR}/boot/issue.txt"
install files/LICENSE.oracle "${ROOTFS_DIR}/boot/"


rm -f "${ROOTFS_DIR}/boot/config.txt"
install files/config.txt "${ROOTFS_DIR}/boot/"

rm -f "${ROOTFS_DIR}/boot/bcm2710-rpi-cm3.dtb"
rm -f "${ROOTFS_DIR}/boot/bcm2710-rpi-3-b.dtb"
rm -f "${ROOTFS_DIR}/boot/bcm2709-rpi-2-b.dtb"
rm -f "${ROOTFS_DIR}/boot/bcm2708-rpi-cm.dtb"
rm -f "${ROOTFS_DIR}/boot/bcm2708-rpi-b-plus.dtb"
rm -f "${ROOTFS_DIR}/boot/bcm2708-rpi-b.dtb"
rm -f "${ROOTFS_DIR}/boot/bcm2708-rpi-0-w.dtb"
rm -f "${ROOTFS_DIR}/boot/kernel.img"
rm -f "${ROOTFS_DIR}/boot/overlays/*"


rm -f "${ROOTFS_DIR}/etc/sudoers.d/*nopasswd"

mkdir -p "${ROOTFS_DIR}/etc/hostapd"
mkdir -p "${ROOTFS_DIR}/etc/default"
mkdir -p "${ROOTFS_DIR}/etc/ssh"
mkdir -p "${ROOTFS_DIR}/etc/network"
mkdir -p "${ROOTFS_DIR}/etc/wpa_supplicant"
mkdir -p "${ROOTFS_DIR}/etc/modprobe.d"
mkdir -p "${ROOTFS_DIR}/etc/systemd"

chmod 644 /etc/passwd
chown root:root /etc/passwd
chmod 644 /etc/group
chown root:root /etc/group
chmod 600 /etc/shadow
chown root:root /etc/shadow
chmod 600 /etc/gshadow
chown root:root /etc/gshadow

install -m 600 files/reboot "${ROOTFS_DIR}/etc/cron.d/reboot"

install -m 600 files/sudoers "${ROOTFS_DIR}/etc/sudoers"
install -m 640 files/hostapd.conf "${ROOTFS_DIR}/etc/hostapd/hostapd.conf"
install -m 640 files/dhcpcd.conf "${ROOTFS_DIR}/etc/dhcpcd.conf"
install -m 600 files/wpa_supplicant.conf "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf"
install -m 640 files/iptables.ipv4.nat "${ROOTFS_DIR}/etc/iptables.ipv4.nat"
install -m 640 files/rc.local "${ROOTFS_DIR}/etc/rc.local"
install -m 640 files/interfaces "${ROOTFS_DIR}/etc/network/interfaces"
install -m 640 files/dnsmasq.conf "${ROOTFS_DIR}/etc/dnsmasq.conf"
install -m 600 files/sshd_config "${ROOTFS_DIR}/etc/ssh/sshd_config"
install -m 640 files/ntp.conf "${ROOTFS_DIR}/etc/ntp.conf"
install -m 640 files/blacklist.conf "${ROOTFS_DIR}/etc/modprobe.d/blacklist.conf"
install -m 640 files/journald.conf "${ROOTFS_DIR}/etc/systemd/journald.conf"

chown root:root "${ROOTFS_DIR}/etc/ssh/sshd_config"

chown root:root "${ROOTFS_DIR}/etc/crontab"
chmod og-rwx "${ROOTFS_DIR}/etc/crontab"
chown root:root "${ROOTFS_DIR}/etc/cron.hourly"
chmod og-rwx "${ROOTFS_DIR}/etc/cron.hourly"
chown root:root "${ROOTFS_DIR}/etc/cron.daily"
chmod og-rwx "${ROOTFS_DIR}/etc/cron.daily"
chown root:root "${ROOTFS_DIR}/etc/cron.weekly"
chmod og-rwx "${ROOTFS_DIR}/etc/cron.weekly"
chown root:root "${ROOTFS_DIR}/etc/cron.monthly"
chmod og-rwx "${ROOTFS_DIR}/etc/cron.monthly"
chown root:root "${ROOTFS_DIR}/etc/cron.d"
chmod og-rwx "${ROOTFS_DIR}/etc/cron.d"
chown root:root "${ROOTFS_DIR}/etc/cron.d/reboot"
chmod og-rwx "${ROOTFS_DIR}/etc/cron.d/reboot"

echo "net.ipv4.ip_forward=1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "kernel.sysrq=0" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "fs.protected_hardlinks=1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "fs.protected_symlinks=1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "kernel.randomize_va_space=2" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "kernel.exec-shield=1" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "fs.suid_dumpable=0" >> "${ROOTFS_DIR}/etc/sysctl.conf"

echo "net.ipv4.conf.all.accept_redirects=0" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "net.ipv4.conf.default.accept_redirects=0" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "net.ipv4.conf.all.send_redirects=0" >> "${ROOTFS_DIR}/etc/sysctl.conf"
echo "net.ipv4.conf.default.send_redirects=0" >> "${ROOTFS_DIR}/etc/sysctl.conf"


echo "* hard core 0" >> "${ROOTFS_DIR}/etc/security/limits.conf"

echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' >> "${ROOTFS_DIR}/etc/default/hostapd"

find -L "${ROOTFS_DIR}/bin" -type f -exec chmod o-rwx {} +
find -L "${ROOTFS_DIR}/sbin" -type f -exec chmod o-rwx {} +
find -L "${ROOTFS_DIR}/usr" -type f -exec chmod o-rwx {} +
find -L "${ROOTFS_DIR}/etc" -type f -exec chmod o-rwx {} +

chmod o+x "${ROOTFS_DIR}/bin/bash"
chmod o+x "${ROOTFS_DIR}/bin/su"
chmod o+x "${ROOTFS_DIR}/bin/ls"
#setfacl -m u:master:x "${ROOTFS_DIR}/bin/su"


cp "$ROOTFS_DIR/etc/rpi-issue" "$INFO_FILE"


{
	firmware=$(zgrep "firmware as of" \
		"$ROOTFS_DIR/usr/share/doc/raspberrypi-kernel/changelog.Debian.gz" | \
		head -n1 | sed  -n 's|.* \([^ ]*\)$|\1|p')
	printf "\nFirmware: https://github.com/raspberrypi/firmware/tree/%s\n" "$firmware"

	kernel="$(curl -s -L "https://github.com/raspberrypi/firmware/raw/$firmware/extra/git_hash")"
	printf "Kernel: https://github.com/raspberrypi/linux/tree/%s\n" "$kernel"

	uname="$(curl -s -L "https://github.com/raspberrypi/firmware/raw/$firmware/extra/uname_string7")"

	printf "Uname string: %s\n" "$uname"
	printf "\nPackages:\n"
	dpkg -l --root "$ROOTFS_DIR"
} >> "$INFO_FILE"

ROOT_DEV="$(mount | grep "${ROOTFS_DIR} " | cut -f1 -d' ')"

unmount "${ROOTFS_DIR}"
zerofree -v "${ROOT_DEV}"

unmount_image "${IMG_FILE}"

mkdir -p "${DEPLOY_DIR}"

rm -f "${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.zip"

pushd "${STAGE_WORK_DIR}" > /dev/null
zip "${DEPLOY_DIR}/image_${IMG_DATE}-${IMG_NAME}${IMG_SUFFIX}.zip" \
	"$(basename "${IMG_FILE}")"
popd > /dev/null

cp "$INFO_FILE" "$DEPLOY_DIR"
