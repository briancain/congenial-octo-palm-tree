#!/bin/bash

sudo apt-get update
sudo apt-get install libvirt-bin libvirt-doc libvirt-dev -y

virsh version
