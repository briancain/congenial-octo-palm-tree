#!/bin/sh

sudo pkg install -y virtualbox-ose virtualbox-ose-additions virtualbox-ose-kmod
echo 'vboxdrv_load="YES"\nvboxvs_load="YES"' | sudo tee -a /boot/loader.conf
echo 'vboxnet_enable="YES"' | sudo tee -a /etc/rc.conf
echo "Please reboot this machine to enable the VirtualBox kernel modules."
sudo pw groupmod vboxusers -m vagrant
