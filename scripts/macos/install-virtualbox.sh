#!/bin/bash

VERSION=$1

echo "${VERSION}"

BUILD=$(curl https://download.virtualbox.org/virtualbox/${VERSION} | grep "VirtualBox-${VERSION}-[[:digit:]]\+-OSX.dmg" | cut -d'-' -f 3)
curl -O https://download.virtualbox.org/virtualbox/${VERSION}/VirtualBox-${VERSION}-${BUILD}-OSX.dmg
hdiutil attach VirtualBox-${VERSION}-${BUILD}-OSX.dmg
sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target / \
  || echo "==> ATTENTION: You must install the VirtualBox kernel extension through the GUI."
VBoxManage --version
