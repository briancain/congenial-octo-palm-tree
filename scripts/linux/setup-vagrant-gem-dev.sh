#!/bin/bash

VERSION=$1

echo "Installed version to override: ${VERSION}"

echo "Building current source version of Vagrant as a gem and copying to current Vagrant project dir..."

rm -rf vagrant-*.gem vagrant-*
cd ${GOPATH}/src/github.com/hashicorp/vagrant
rvm use 2.6.5@vagrant
gem build vagrant.gemspec

cp vagrant-*.dev.gem /home/brian/code/vagrant-sandbox/disk-mgmt/hyperv/
