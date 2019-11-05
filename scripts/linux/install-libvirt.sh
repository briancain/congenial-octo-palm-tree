#!/bin/bash

sudo apt-get update
sudo apt-get install nfs-kernel-server libvirt-bin libvirt-doc libvirt-dev -y

virsh version
