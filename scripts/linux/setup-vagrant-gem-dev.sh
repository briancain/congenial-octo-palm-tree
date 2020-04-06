#!/bin/bash

VERSION=$1

echo "${VERSION}"

rm -rf vagrant-*.gem vagrant-*
cd ${GOPATH}/src/github.com/hashicorp/vagrant
rvm use 2.6.5@vagrant
gem build vagrant.gemspec

cp vagrant-*.dev.gem /home/brian/code/vagrant-sandbox/hyperv-disks/
