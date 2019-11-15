#!/bin/bash

VERSION=$1

echo "${VERSION}"

curl -O https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.dmg
hdiutil attach vagrant_${VERSION}_x86_64.dmg
sudo installer -pkg /Volumes/Vagrant/vagrant.pkg -target /
vagrant --version
