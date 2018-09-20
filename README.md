# rpi-access-point-gen

Fork of RPi-Distro/pi-gen. 
Creates an images for an minimalistic and hardended raspberry pi access point (only Model 3 B+)

## Dependencies

rpi-access-point-gen runs on Debian based operating systems. Currently it is only supported on
either Debian Stretch or Ubuntu Xenial and is known to have issues building on
earlier releases of these systems.

To install the required dependencies for rpi-access-point-gen you should run:

```bash
apt-get install quilt parted realpath qemu-user-static debootstrap zerofree pxz zip \
dosfstools bsdtar libcap2-bin grep rsync xz-utils
```

The file `depends` contains a list of tools needed.  The format of this
package is `<tool>[:<debian-package>]`.

