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

    #b.vm.network :private_network, type: :dhcp

    #b.vm.provision "shell", inline:<<-SHELL
    #SHELL

    #b.vm.synced_folder "scripts", "/vagrant"
    #b.vm.synced_folder "scripts", "/vagrant", type: "rsync"
    #  rsync__args: ["-avz", "--copy-links"]

    b.vm.provider :virtualbox
    #b.vm.provider :virtualbox do |v|
    #  v.linked_clone = true
    #end
    #b.vm.provider :vmware_desktop do |v|
    #  v.memory = 8048
    #  v.cpus = 2
    #  v.vmx['vhv.enable'] = 'TRUE'
    #  v.vmx['vhv.allow'] = 'TRUE'
    #end
  end

  # vagrant@precise64:~$ dhclient --version
  # isc-dhclient-4.1-ESV-R4
  config.vm.define "hashicorp" do |h|
    h.vm.box = "hashicorp/precise64"
    h.vm.hostname = "test.test"
    h.vm.provider :virtualbox
    h.vm.provision "shell", inline:<<-SHELL
    echo 'hello there'
    touch file.txt
    ls -lah
    hostname -f
    SHELL
  end

  config.vm.define "vbox" do |b|
    b.vm.box = "bento/ubuntu-18.04"

    b.vm.provider :vmware_desktop do |v|
      v.memory = 8048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    version = "2.2.0"
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
    vagrant --version
    SHELL

   #b.vm.synced_folder "../vagrant",
   #  "/opt/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"
  end

  (1..3).each do |i|
    config.vm.define "docker-#{i}"  do |vm|
      vm.vm.synced_folder "../vagrant", "/dev/vagrant"
      vm.vm.provider "docker" do |d|
        #d.image = "ubuntu"
        d.build_dir = "docker"
        #d.git_repo = "https://github.com/briancain/nginx-docker-test.git"
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

  config.vm.define "puppet" do |p|
    p.vm.box = "bento/ubuntu-16.04"

    p.vm.provision "shell", inline: <<-SHELL
    wget https://apt.puppetlabs.com/puppet5-release-xenial.deb
    sudo dpkg -i puppet5-release-xenial.deb
    sudo apt update
    sudo apt-get install puppet-agent
    SHELL

    p.vm.provision :puppet do |p|
      p.module_path = ['modules', 'site']
    end

    p.vm.provider :virtualbox

    p.vm.provision "shell", inline: <<-SHELL
      puppet --version
    SHELL
  end

  config.vm.define "centos" do |centos|
    centos.vm.provider :virtualbox
    centos.vm.box = "bento/centos-7.5"
    #centos.vm.box = "centos/7"
  end

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "bento/ubuntu-16.04"
    ansible.vm.provision "ansible" do |a|
      a.playbook = "playbook.yml"
    end
  end

  config.vm.define "salt" do |salt|
    salt.vm.box = "bento/ubuntu-16.04"
    #salt.vm.box = "boxcutter/win10"

    salt.vm.provider :virtualbox

    salt.vm.provision :salt do |s|
      s.minion_config = "saltstack/etc/minion"
      s.install_type = "git"
      s.verbose = true
      s.run_highstate = true
      s.salt_call_args = ["--force-color", "--output-diff"]

      s.pillar({
          "demo" => "HELLO"
        })
    end

    salt.vm.provision "shell", inline:<<-SHELL
    salt-call --version
    SHELL
  end

  config.vm.define "windows" do |windows|
    windows.vm.box = "windows2016" # virtualbox

    windows.vm.provision "shell", path: "scripts/info.ps1"
    windows.vm.provision "shell", path: "scripts/setup.ps1"

    windows.vm.provider :vmware_desktop do |v|
      v.gui = true
      v.memory = "15000"
      v.cpus = 4
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
      v.vmx["hypervisor.cpuid.0"] = "FALSE"
    end

    windows.trigger.after :destroy do |trigger|
      trigger.warn = "MAKE SURE TO COMMENT OUT SYNCED FOLDER"
    end

    version = "2.2.0"
    #windows.vm.synced_folder "../vagrant",
    #  "/hashicorp/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"

    #windows.vm.provision :puppet do |p|
    #  p.module_path = ['modules', 'site']
    #end

  end

  config.vm.define "windows-hyperv" do |windows|
    windows.vm.box = "windows_10" # hyper-v

    windows.vm.provision "shell", path: "scripts/info.ps1"
    windows.vm.provision "shell", path: "scripts/setuphyperv.ps1"

    windows.vm.provider :vmware_desktop do |v|
      v.gui = true
      v.memory = "10000"
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
      v.vmx["hypervisor.cpuid.0"] = "FALSE"
    end

    windows.vm.synced_folder "windows-sandbox", "/Users/vagrant/test"

    windows.trigger.after :destroy do |trigger|
      trigger.warn = "MAKE SURE TO COMMENT OUT SYNCED FOLDER"
    end

    version = "2.2.0"

    windows.vm.synced_folder "../vagrant",
      "/hashicorp/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"
  end

  config.vm.define "macos" do |m|
    m.vm.box = "macOS/high-sierra"
    m.vm.provider :vmware_desktop do |v|
      v.gui = true
      v.memory = "4096"
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
      v.vmx["hypervisor.cpuid.0"] = "FALSE"
    end
  end

  config.vm.define "fedora" do |c|
    c.vm.box = "generic/fedora28"
    c.vm.provider :virtualbox
  end

  config.vm.define "arch" do |arch|
    arch.vm.provider :virtualbox
    arch.vm.box = "generic/arch"

    arch.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end

  config.vm.define "debian" do |d|
    #d.vm.box = "bento/debian-7.8"
    d.vm.box = "bento/debian-8.6"
    #d.vm.box = "debian/jessie64"
    #d.vm.box = "bento/ubuntu-18.04"
    #d.vm.box = "bento/debian-9.4"
    d.vm.provider :virtualbox
    d.vm.hostname = "test.test"
    d.vm.synced_folder ".", "/vagrant", disabled: true
    d.vm.network "private_network", type: "dhcp"
  end

  config.vm.define "dockervm" do |d|
    d.vm.box = "bento/ubuntu-18.04"
    d.vm.provider :virtualbox

    d.vm.provision "shell", inline:<<-SHELL
    sudo apt-get update
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt-get install docker-ce -y
    SHELL
  end
end
