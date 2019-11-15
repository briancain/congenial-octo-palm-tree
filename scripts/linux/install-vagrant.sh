#!/bin/bash

VERSION=$1

echo "${VERSION}"

sudo apt-get install -y curl
curl -O https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.deb
sudo dpkg -i vagrant_${VERSION}_x86_64.deb
vagrant --version
