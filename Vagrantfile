# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.trigger.before :up do |trigger|
    trigger.run = {path: "test.sh", args: ["-Test", "#{File.dirname(__FILE__) + 'path/to/test.pem'}"]}
  end

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
    #b.vm.box = "generic/ubuntu1804"
    #b.vm.box = "bento/debian-9.4"

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
    mkdir /home/vagrant/vagrantsandbox
    cd /home/vagrant/vagrantsandbox
    vagrant init bento/ubuntu-16.04
    vagrant box add bento/ubuntu-16.04
    SHELL

    #b.vm.synced_folder "../vagrant",
    #  "/opt/vagrant/embedded/gems/gems/vagrant-2.1.1"
  end

  (1..3).each do |i|
    config.vm.define "docker-#{i}"  do |vm|
      vm.vm.provider "docker" do |d|
        #d.image = "ubuntu"
        d.build_dir = "."
        d.cmd = ["tail", "-f", "/dev/null"]
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
    vbox.vm.network "private_network", type: "dhcp"
    vbox.vm.provider :vmware

    vbox.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update
    sudo apt-get install puppet-agent
    SHELL

    vbox.vm.provision :puppet

    vbox.vm.provision "puppet" do |puppet|
    end

    #vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
    #  puppet --version
    #SHELL
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
    windows.vm.box = "windowsbase"
    #windows.vm.box = "windows10vbox"
    #windows.vm.box = "mwrock/Windows2016"
    #windows.vm.box = "StefanScherer/windows_2016_docker"
    #windows.vm.box = "windowswsl"
    #windows.vm.box = "windowshyperv"
    #windows.vm.box = "opentable/win-2008r2-standard-amd64-nocm"

    windows.vm.provision "shell", path: "scripts/info.ps1"

    #windows.vm.provision :salt do |s|
    #  s.minion_config = "saltstack/etc/minion"
    #  s.install_type = "gitwindows.vm.provider :virtualbox
    windows.vm.provider :vmware_fusion do |v|
      v.memory = "10000"
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    #windows.vm.synced_folder "../vagrant",
    #  "/hashicorp/vagrant/embedded/gems/2.1.1/gems/vagrant-2.1.1"
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

  config.vm.define "openbsd" do |bsd|
    bsd.vm.box = "generic/openbsd6"
    bsd.vm.network :private_network, type: "dhcp"
  end

  config.vm.define "gentoo" do |g|
    g.vm.box = "generic/gentoo"
  end

  config.vm.define "debian" do |d|
    #d.vm.box = "debian/stretch64"
    #d.vm.box = "debian/jessie64"
    d.vm.box = "bento/debian-8.2"
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

  config.vm.define "dockerwindows" do |d|
    d.vm.box = "StefanScherer/windows_2016_docker"
    d.vm.box_version = "2017.12.14"
    d.vm.provision "docker" do |d|
      d.images = ["ubuntu"]
    end
  end
end
