#!/bin/bash -eu

# Reduce installed languages to just "en_US"
echo "==> Configuring locales"
sed -i '/^[^# ]/s/^/# /' /etc/locale.gen
LANG=en_US.UTF-8
LC_ALL=$LANG
locale-gen --purge $LANG
update-locale LANG=$LANG LC_ALL=$LC_ALL

# Remove some packages to get a minimal install
echo "==> Removing all linux kernels except the currrent one"
dpkg --list 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ :]*\).*/\1/;/[0-9]/!d' | xargs apt-get -y purge
echo "==> Removing linux source"
dpkg --list | awk '{print $2}' | grep linux-source | xargs apt-get -y purge
echo "==> Removing documentation"
dpkg --list | awk '{print $2}' | grep -- '-doc$' | xargs apt-get -y purge
#### Removed to enable desktop with XWindow system (Start)
# echo "==> Removing X11 libraries"
# apt-get -y purge libx11-data xauth libxmuu1 libxcb1 libx11-6 libxext6 libxau6 libxdmcp6
# echo "==> Removing other oddities"
# apt-get -y purge accountsservice bind9-host busybox-static command-not-found dmidecode \
#     dosfstools friendly-recovery hdparm info install-info installation-report \
#     iso-codes krb5-locales language-selector-common laptop-detect lshw mtr-tiny nano \
#     ncurses-term ntfs-3g os-prober parted pci.ids pciutils plymouth popularity-contest powermgmt-base \
#     publicsuffix python-apt-common shared-mime-info ssh-import-id \
#    tasksel tcpdump ufw usb.ids usbutils uuid-runtime xdg-user-dirs
#### Removed to enable desktop with XWindow system (End)
apt-get -y autoremove --purge

# Clean up orphaned packages with deborphan
apt-get -y install --no-install-recommends deborphan
deborphan --find-config | xargs apt-get -y purge
while [ -n "$(deborphan --guess-all)" ]; do
    deborphan --guess-all | xargs apt-get -y purge
done
apt-get -y purge deborphan

# Clean up the apt cache
apt-get -y autoremove --purge
apt-get clean

echo "==> Removing APT files"
find /var/lib/apt -type f -exec rm -rf {} \;
echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;
