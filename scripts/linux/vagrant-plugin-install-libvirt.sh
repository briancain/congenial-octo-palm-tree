#!/bin/bash

VERSION=$1

echo "${VERSION}"

sudo rpm -i -y curl
curl -O https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.rpm
sudo rpm -i vagrant_${VERSION}_x86_64.rpm
vagrant --version

CONFIGURE_ARGS='with-ldflags=-L/opt/vagrant/embedded/lib with-libvirt-include=/usr/include/libvirt with-libvirt-lib=/usr/lib' GEM_HOME=~/.vagrant.d/gems GEM_PATH=$GEM_HOME:/opt/vagrant/embedded/gems PATH=/opt/vagrant/embedded/bin:$PATH vagrant plugin install vagrant-libvirt
