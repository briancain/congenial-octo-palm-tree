# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu/trusty64"
  #config.vm.provider "docker" do |d|
  #  d.image = "default"
  #end
  #config.vm.box = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.define "default", primary: true  do |vm|
    vm.vm.box = "hashicorp/precise64"
  end

  config.vm.define "virtualbox" do |vbox|
    vbox.vm.box = "hashicorp/precise64"
    vbox.vm.provider :virtualbox do |vb|
    end
  end
end
