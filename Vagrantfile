# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu/trusty64"
  #config.vm.define "docker" do |d|
  #  d.vm.provider "docker" do |dk|
  #    dk.image = "ubuntu"
  #    #dk.build_dir = "./"
  #  end
  #end
  #config.vm.box = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  #config.vm.box = "iamseth/rhel-7.3"
  #config.vm.provision "mah docker", type: "docker"  do |d|
  #  d.image = "ubuntu"
  #end

  config.vm.define "bork" do |b|
    b.vm.box = "bento/ubuntu-16.04"
    #b.vm.box_url = "http://localhost:8000/box.json"
    b.vm.provider :virtualbox
    #b.vm.network "forwarded_port", guest: 80, host: 8080
    #b.vm.network "forwarded_port", guest: 90, host: 9090
    #b.vm.hostname = "bork"
    #b.vm.synced_folder ".", "/vagrant", type: "nfs"
    #b.vm.network :private_network, ip: "192.168.44.20", type: "dhcp"
    b.vm.network :public_network
  end

  config.vm.define "docker"  do |vm|
    vm.vm.provider "docker" do |d|
      d.image = "ubuntu"
      #d.build_dir = "."
      d.cmd = ["tail", "-f", "/dev/null"]
    end
  end

  config.vm.define "chef" do |chef|
    chef.vm.box = "bento/ubuntu-16.04"
    chef.vm.provider :virtualbox

    chef.vm.provision :chef_solo do |c|
      c.add_recipe "test"
    end

    #chef.vm.provision :chef_zero do |c|
    #  c.cookbooks_path = "."
    #  c.add_recipe "test"
    #  c.nodes_path = "/not/real"
    #end
  end

  config.vm.define "puppet" do |vbox|
    vbox.vm.box = "bento/ubuntu-16.04"
    vbox.vm.network "private_network", type: "dhcp"
    vbox.vm.provider :virtualbox

    vbox.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update
    sudo apt-get install puppet-agent
    SHELL

    vbox.vm.provision :puppet

    vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
      puppet --version
    SHELL
  end

  config.vm.define "vbox-nfs" do |vbox|
    vbox.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    vbox.vm.box = "bento/centos-7.2"
    vbox.vm.network :private_network, ip: "10.0.8.178", type: "dhcp"

    vbox.vm.synced_folder ".", "/vagrant", type: "nfs",
      rsync__exclude: ".git/"
  end

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "bento/ubuntu-16.04"
    ansible.vm.provision "ansible" do |a|
      a.playbook = "playbook.yml"
    end
  end

  config.vm.define "salt" do |salt|
    salt.vm.box = "bento/ubuntu-16.04"

    salt.vm.provider :virtualbox
    salt.vm.synced_folder ".", "/vagrant", type: "nfs"
    salt.vm.network :private_network, ip: "192.168.44.20", type: "dhcp"

    salt.vm.provision :salt do |s|
      s.minion_config = "saltstack/etc/minion"
      s.install_type = "git"
      s.verbose = true
      s.run_highstate = true
      s.salt_call_args = ["--force-color", "--output-diff"]
    end
  end

  config.vm.define "spec-ubuntu" do |ubuntu|
    ubuntu.vm.box = "spox/ubuntu-16.04"
    ubuntu.vm.network :private_network, ip: "192.168.33.10"
  end

  config.vm.define "spec-centos" do |centos|
    centos.vm.box = "spox/centos-7"
    #centos.vm.network :private_network, ip: "192.168.33.10", type: "dhcp"
    #centos.vm.synced_folder ".", "/vagrant", type: "nfs",
    #  rsync__exclude: ".git/"
  end

  config.vm.define "arch" do |arch|
    arch.vm.box = "wholebits/archlinux"
    arch.vm.provider :vmware_fusion do |v|
      v.memory = 2048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    arch.vm.synced_folder "../vagrant",
      "/opt/vagrant/embedded/gems/gems/vagrant-1.9.7"
    #arch.vm.network :private_network, ip: "192.168.33.10", type: "dhcp"
    #arch.vm.synced_folder ".", "/vagrant", type: "nfs",
    #  rsync__exclude: ".git/"
  end

  config.vm.define "windows" do |windows|
    windows.vm.box = "spox/windows-10"

    #windows.vm.provision :salt do |s|
    #  s.minion_config = "saltstack/etc/minion"
    #  s.install_type = "git"
    #  s.verbose = true
    #  s.run_highstate = true
    #  s.masterless = true
    #  s.install_args = "v2017.1.0"
    #  #s.salt_call_args = ["--force-color", "--output-diff"]
    #end

    #windows.vm.provision "file",
    #  source: "./scripts",
    #  destination: "C:\\Users\\vagrant\\scripts\\morefolders"

    windows.vm.synced_folder "../vagrant",
      "/hashicorp/vagrant/embedded/gems/gems/vagrant-2.0.0"
  end

  config.vm.define "windows-dev" do |windows|
    windows.vm.box = "spox/windows-10"
    #windows.vm.synced_folder "../vagrant", "/vagrant-dev", rsync__exclude: ".git/"
    windows.vm.synced_folder "../vagrant",
      "/hashicorp/vagrant/embedded/gems/gems/vagrant-1.9.8.dev"
  end

  config.vm.define "macos" do |windows|
    windows.vm.box = "hashicorp-vagrant/osx-10.9"
    #arch.vm.network :private_network, ip: "192.168.33.10", type: "dhcp"
    #arch.vm.synced_folder ".", "/vagrant", type: "nfs",
    #  rsync__exclude: ".git/"
  end
end
