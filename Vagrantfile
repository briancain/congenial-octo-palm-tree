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
    b.vm.box = "hashicorp/precise64"
    b.vm.box_url = "http://localhost:8000/box.json"
    b.vm.provider :virtualbox
  end

  config.vm.define "docker"  do |vm|
    vm.vm.provider "docker" do |d|
      d.image = "ubuntu"
      #d.build_dir = "."
      d.cmd = ["tail", "-f", "/dev/null"]
    end
  end

  config.vm.define "docker2"  do |vm|
    vm.vm.provider "docker" do |d|
      d.build_dir = "."
      d.compose = true
    end
  end


  #config.vm.define "default", primary: true  do |vm|
  #  vm.vm.box = "centos/7"

  #  vm.vm.provider :virtualbox do |v|
  #  end

  #  vm.vm.network "public_network"
  #  vm.vm.network :forwarded_port, host: 80, guest: 80
  #  vm.vm.network :forwarded_port, host: 8080, guest: 8080
  #  vm.vm.provision "shell", inline: <<-SHELL
  #    sudo python -m SimpleHTTPServer 80 &
  #  SHELL
  #end

  #config.vm.define "ubuntu"  do |vm|
  #  vm.vm.box = "bento/ubuntu-16.04"
  #  vm.vm.hostname = "ubuntu1.local"
  #  vm.vm.provider :virtualbox do |v|
  #    v.customize ["modifyvm", :id, "--memory", "2048"]
  #    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
  #  end
  #  vm.vm.provision "my file", type: "shell", inline: <<-SHELL
  #    echo $(hostname -f)
  #  SHELL
  #end

  config.vm.define "basic" do |b|
    b.vm.box = "bento/ubuntu-16.04"
    #b.vm.box = "bento/centos-7.3"
    b.vm.provider :virtualbox

    b.vm.network "private_network", ip: "192.168.42.10", netmask: "255.255.255.0"
    b.vm.network "private_network", ip: "192.168.42.20", netmask: "255.255.255.0"
    b.vm.network "private_network", ip: "192.168.42.30", netmask: "255.255.255.0"
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
    vbox.vm.box = "ubuntu/xenial64"
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

  config.vm.define "virtualbox" do |vbox|
    vbox.vm.box = "ubuntu/trusty64"
    #vbox.vm.box = "ubuntu/xenial64"
    vbox.vm.network "private_network", type: "dhcp"
    #vbox.vm.synced_folder ".", "/vagrant", type: "nfs"
    #vbox.vm.synced_folder ".", "/vagrant", type: "rsync",
    #  rsync__exclude: ".git/"
    vbox.vm.provider :virtualbox

    vbox.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update
    sudo apt-get install puppet-agent -y
    SHELL

    vbox.vm.provision :puppet

    vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
      echo 'hello' > hello.txt
      puppet --version
    SHELL
  end

  config.vm.define "virtualbox-nfs" do |vbox|
    vbox.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    vbox.vm.box = "ubuntu/xenial64"
    #vbox.vm.box = "ubuntu/trusty64"
    #vbox.vm.box = "bento/centos-7.2"
    #vbox.vm.box = "bento/debian-8.2"
    vbox.vm.network :private_network, ip: "10.0.8.178", type: "dhcp"
    vbox.ssh.forward_agent = true
    vbox.vm.synced_folder ".", "/vagrant", type: "nfs",
      rsync__exclude: ".git/"

    vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
      echo 'hello' > hello.txt
    SHELL
  end

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "ubuntu/xenial64"
    ansible.vm.provision "ansible" do |a|
      a.playbook = "playbook.yml"
    end
  end

  config.vm.define "salt" do |salt|
    salt.vm.box = "ubuntu/xenial64"

    salt.vm.provider :virtualbox

    salt.vm.provision :salt do |s|
      s.minion_config = "saltstack/etc/minion"
      s.install_type = "git"
      s.verbose = true
      s.run_highstate = true
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
    #arch.vm.box = "hashicorp-vagrant/archlinux"
    #arch.vm.box = "terrywang/archlinux"
    arch.vm.box = "wholebits/archlinux"
    #arch.vm.provider :vmware_fusion do |v|
    #  v.memory = 2048
    #  v.cpus = 2
    #  v.vmx['vhv.enable'] = 'TRUE'
    #  v.vmx['vhv.allow'] = 'TRUE'
    #end
    #arch.vm.network :private_network, ip: "192.168.33.10", type: "dhcp"
    #arch.vm.synced_folder ".", "/vagrant", type: "nfs",
    #  rsync__exclude: ".git/"
  end

  config.vm.define "windows" do |windows|
    windows.vm.box = "spox/windows-10"
    #arch.vm.network :private_network, ip: "192.168.33.10", type: "dhcp"
    #arch.vm.synced_folder ".", "/vagrant", type: "nfs",
    #  rsync__exclude: ".git/"
  end

end
