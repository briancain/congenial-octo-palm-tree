# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.define "bork" do |b|
    b.vm.box = "bento/ubuntu-16.04"
    #b.vm.box_url = "http://localhost:8000/box.json"

    #b.vm.provider :virtualbox
    b.vm.provider :vmware_fusion do |v|
      v.memory = 8048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    b.vm.provision "shell", inline: <<-SHELL
    echo hello
    SHELL

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

    version = "2.0.3"
    b.vm.provision "VirtualBox", type: "shell", inline: <<-SHELL
    sudo apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
    sudo apt -y install gcc make linux-headers-$(uname -r) dkms
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" >> /etc/apt/sources.list'
    sudo apt update
    sudo apt install virtualbox-5.1 -y
    vboxmanage --version
    curl -O https://releases.hashicorp.com/vagrant/#{version}/vagrant_#{version}_x86_64.deb
    sudo dpkg -i vagrant_#{version}_x86_64.deb
    SHELL

    #b.vm.synced_folder "../vagrant",
    #  "/opt/vagrant/embedded/gems/gems/vagrant-2.0.2"
  end
  (1..3).each do |i|
    config.vm.define "docker-#{i}"  do |vm|
      vm.vm.provider "docker" do |d|
        d.image = "ubuntu"
        #d.build_dir = "."
        d.cmd = ["tail", "-f", "/dev/null"]
      end
    end
  end

  config.vm.define "chef" do |chef|
    chef.vm.box = "bento/ubuntu-16.04"
    #chef.vm.provider :virtualbox
    chef.vm.provider :vmware

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
    vbox.vm.provider :vmware

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

  config.vm.define "centos" do |vbox|
    vbox.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "2048"]
    end

    vbox.vm.box = "bento/centos-7.2"
    #vbox.vm.box = "centos/7"
    #vbox.vm.network :private_network, ip: "192.191.91.10"

    #vbox.vm.synced_folder ".", "/vagrant", type: "nfs",
    #  rsync__exclude: ".git/"
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

  config.vm.define "windows" do |windows|
    windows.vm.box = "windowsbase"
    #windows.vm.box = "windowswsl"
    #windows.vm.box = "windowshyperv"
    #windows.vm.box = "windows7oldps"
    #windows.vm.box = "opentable/win-2008r2-standard-amd64-nocm"

    #windows.vm.provision "shell", inline: <<-SHELL
    #Write-Host "Downloading Powershell Upgrade"
    #(New-Object System.Net.WebClient).DownloadFile('https://download.microsoft.com/download/E/7/6/E76850B8-DA6E-4FF5-8CCE-A24FC513FD16/Windows6.1-KB2506143-x64.msu', 'C:\Windows\Temp\ps-upgrade.msu')
    #Write-Host "Installing Powershell Upgrade"
    #Start-Process "C:\Windows\Temp\ps-upgrade.msu" "/quiet /forcerestart" -Wait
    #SHELL

    windows.vm.provision "shell", inline: <<-SHELL
    Write-Host "HypervisorPresent ?"
    $(Get-ComputerInfo).HypervisorPresent
    Write-Host "Hyper-v Enabled ?"
    $(Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online).State
    Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
    Write-Host "Windows Version:"
    $(gwmi win32_operatingsystem).Version
    SHELL

    #windows.vm.provision :salt do |s|
    #  s.minion_config = "saltstack/etc/minion"
    #  s.install_type = "git"
    #  s.verbose = true
    #  s.run_highstate = true
    #  s.masterless = true
    #  s.install_args = "v2017.1.0"
    #  #s.salt_call_args = ["--force-color", "--output-diff"]
    #end

    #windows.vm.provider :virtualbox
    windows.vm.provider :vmware_fusion do |v|
      v.memory = "10000"
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    #windows.vm.synced_folder "../vagrant",
    #  "/hashicorp/vagrant/embedded/gems/gems/vagrant-2.0.2"
  end

  config.vm.define "macos" do |m|
    m.vm.box = "hashicorp-vagrant/osx-10.9"
  end

  config.vm.define "arch" do |arch|
    arch.vm.box = "hashicorp-vagrant/archlinux"
  end

  config.vm.define "openbsd" do |bsd|
    bsd.vm.box = "generic/openbsd6"
    bsd.vm.network :private_network, type: "dhcp"
  end

  config.vm.define "gentoo" do |g|
    g.vm.box = "generic/gentoo"
    g.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "debian" do |d|
    d.vm.box = "debian/stretch64"
    #d.vm.box = "debian/jessie64"
    #d.vm.box = "bento/debian-8.2"
    #d.vm.box = "debian93"
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

  config.vm.define "suse" do |s|
    s.vm.box = "generic/opensuse42"
    s.vm.provider :virtualbox
  end
end
