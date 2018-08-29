# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "bork" do |b|
    b.vm.box = "bento/ubuntu-18.04"
    # Start a web server locally to serve up box
    #b.vm.box = "hashicorp/precise64_custom"
    #b.vm.box_url = "http://localhost:8000/box.json"

    b.vm.provider :virtualbox
    #b.vm.provider :vmware_fusion do |v|
    #  v.memory = 8048
    #  v.cpus = 2
    #  v.vmx['vhv.enable'] = 'TRUE'
    #  v.vmx['vhv.allow'] = 'TRUE'
    #end

    #b.vm.synced_folder "../vagrant",
    #  "/opt/vagrant/embedded/gems/gems/vagrant-2.0.2"
  end

  config.vm.define "vbox" do |b|
    b.vm.box = "bento/ubuntu-16.04"

    b.vm.provider :vmware_fusion do |v|
      v.memory = 8048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    version = "2.1.2"
    b.vm.provision "VirtualBox", type: "shell", inline: <<-SHELL
    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
    sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
    sudo apt-get update
    sudo apt-get install virtualbox-5.2 -y
    vboxmanage --version
    curl -O https://releases.hashicorp.com/vagrant/#{version}/vagrant_#{version}_x86_64.deb
    sudo dpkg -i vagrant_#{version}_x86_64.deb
    SHELL

    #b.vm.synced_folder "../vagrant",
    #  "/opt/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"
  end

  (1..3).each do |i|
    config.vm.define "docker-#{i}"  do |vm|
      vm.vm.synced_folder ".", "/guest/dir1", docker_consistency: "cached"
      vm.vm.synced_folder "../vagrant", "/dev/vagrant", docker_consistency: "delegated"
      vm.vm.provider "docker" do |d|
        #d.image = "ubuntu"
        d.build_dir = "docker"
        d.cmd = ["tail", "-f", "/dev/null"]
        d.compose = true
      end
    end
  end

  config.vm.define "chef" do |chef|
    chef.vm.box = "bento/ubuntu-16.04"
    chef.vm.provider :virtualbox
    #chef.vm.provider :vmware

    chef.vm.provision 'chef_solo'
    #chef.vm.provision :chef_solo do |c|
    #  c.add_recipe "test"
    #end

    #chef.vm.provision :chef_zero do |c|
    #  c.cookbooks_path = "."
    #  c.add_recipe "test"
    #  c.nodes_path = ["~/code/vagrant-sandbox/nodes"]
    #end
  end

  config.vm.define "puppet" do |vbox|
    vbox.vm.box = "bento/ubuntu-16.04"

    vbox.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update
    sudo apt-get install puppet-agent
    SHELL

    vbox.vm.provision :puppet do |p|
      p.module_path = ['modules', 'site']
    end

    vbox.vm.provider :virtualbox

    vbox.vm.provision "shell", inline: <<-SHELL
      puppet --version
    SHELL
  end

  config.vm.define "centos" do |centos|
    centos.vm.box = "bento/centos-7.5"
    centos.vm.network "private_network", type: "dhcp"
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

    salt.vm.provision :salt do |s|
      s.minion_config = "saltstack/etc/minion"
      s.install_type = "git"
      s.verbose = true
      s.run_highstate = true
      s.salt_call_args = ["--force-color", "--output-diff"]
    end
  end

  config.vm.define "windows" do |windows|
    windows.vm.box = "StefanScherer/windows_10"

    windows.vm.provision "shell", path: "scripts/info.ps1"

    #windows.vm.provision :salt do |s|
    #  s.minion_config = "saltstack/etc/minion"
    #  s.install_type = "gitwindows.vm.provider :virtualbox
    windows.vm.provider :vmware_fusion do |v|
      v.memory = "10000"
      v.cpus = 4
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    #windows.vm.synced_folder "../vagrant",
    #  "/hashicorp/vagrant/embedded/gems/2.1.2/gems/vagrant-2.1.2"
  end

  config.vm.define "macos" do |m|
    m.vm.box = "hashicorp-vagrant/osx-10.9"
  end

  config.vm.define "arch" do |arch|
    arch.vm.provider :virtualbox
    #arch.vm.box = "hashicorp-vagrant/archlinux"
    arch.vm.box = "generic/arch"

    arch.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end

  config.vm.define "openindiana" do |o|
    o.vm.provider :virtualbox
    o.vm.box = "openindiana/hipster"
  end

  config.vm.define "debian" do |d|
    #d.vm.box = "bento/debian-7.8"
    d.vm.box = "bento/debian-8.6"
    d.vm.host_name = "debian.local"
    d.vm.network "private_network", ip: "192.168.116.80"
    #d.vm.box = "bento/debian-9.4"
    d.vm.provider :virtualbox
  end

  config.vm.define "ubuntu17" do |u|
    u.vm.box = "bento/ubuntu-17.10"
    #u.vm.box = "ubuntu/artful64"
    u.vm.provider :virtualbox
    u.vm.network :private_network, ip: "192.168.33.10"
    u.vm.network "private_network", ip: "fde4:8dba:82e1::c4"
  end
end
