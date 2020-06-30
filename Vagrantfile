# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

VAGRANT_VERSION = "2.2.9"

Vagrant.configure("2") do |config|
  config.vm.define "bork" do |b|
    b.vm.box = "bento/ubuntu-18.04"
    b.vm.provision "Sandbox", type: "file",
      source: "linux-sandbox/Vagrantfile",
      destination: "/home/vagrant/test/Vagrantfile"

    # Start a web server locally to serve up box
    #b.vm.box = "hashicorp/precise64_custom"
    #b.vm.box_url = "http://localhost:8000/box.json"

    #b.vm.network :private_network, type: :dhcp
    #b.vm.network :private_network, ip: "fde4:8dba:82e1::c4"
    #b.vm.network "private_network", ip: "192.168.55.99"

    #b.vm.provision :shell, inline:<<-SHELL
    #SHELL

    #b.vm.synced_folder ".", "/vagrant", nfs: true
    #b.vm.synced_folder "scripts", "/vagrant", type: "rsync",
    #  rsync__exclude: ["data/"]
    #  rsync__args: ["-avz", "--copy-links"]

    b.vm.provider :virtualbox do |vb|
      #vb.linked_clone = true
    end
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
    #h.vm.box = "hashicorp/precise64"
    h.vm.box = "hashicorp/bionic64"
    #h.vm.hostname = "test.test"
    h.vm.provider :virtualbox
  end

  config.vm.define "vagrant-share" do |h|
    h.vm.box = "hashicorp/bionic64"
    h.vm.provider :virtualbox

    h.vm.network "private_network", ip: "192.168.55.99"
    h.vm.network "forwarded_port", guest: 80, host: 8080

    h.vm.provision :shell, inline:<<-SHELL
    sudo apt-get update
    sudo apt-get install nginx -y
    sudo service nginx start
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

    b.vm.provider :virtualbox do |v|
      v.memory = 8048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    b.vm.provision "file",
      source: "linux-sandbox/Vagrantfile",
      destination: "/home/vagrant/test/Vagrantfile"

    virtualbox_version = "6.1"
    b.vm.provision "VirtualBox", type: "shell",
      #run: "never",
      path: "scripts/linux/install-vbox.sh",
      args: virtualbox_version

    b.vm.provision "Vagrant", type: "shell",
      #run: "never",
      path: "scripts/linux/install-vagrant.sh",
      args: VAGRANT_VERSION

    b.vm.provision "Debug", type: "shell", path: "scripts/linux/setup-debug-env.sh", run: "never"

    b.vm.provision "Docker", type: "shell", path: "scripts/linux/install-docker.sh", run: "never"

    #b.vm.synced_folder "../vagrant-share", "/home/vagrant/.vagrant.d/gems/2.4.6/gems/vagrant-share-1.1.9"

    #b.vm.synced_folder "#{ENV['GOPATH']}/src/github.com/hashicorp/vagrant", "/opt/vagrant/embedded/gems/#{VAGRANT_VERSION}/gems/vagrant-#{VAGRANT_VERSION}"
  end

  config.vm.define "libvirt" do |b|
    b.vm.box = "bento/ubuntu-18.04"

    b.vm.provider :vmware_desktop do |v|
      v.memory = 8048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    b.vm.provider :virtualbox do |v|
      v.memory = 8048
      v.cpus = 2
      v.customize ["modifyvm", :id, "--nested-hw-virt", "on"]
    end

    b.vm.provision "file",
      source: "libvirt-sandbox/Vagrantfile",
      destination: "/home/vagrant/test/Vagrantfile"

    virtualbox_version = "6.0"
    b.vm.provision "VirtualBox", type: "shell",
      path: "scripts/linux/install-vbox.sh",
      args: virtualbox_version,
      run: "never"

    b.vm.provision "Libvirt", type: "shell",
      path: "scripts/linux/install-libvirt.sh"

    b.vm.provision "Vagrant", type: "shell",
      path: "scripts/linux/install-vagrant.sh",
      args: VAGRANT_VERSION

    b.vm.provision "vagrant-libvirt plugin", type: "shell", privileged: false,
      inline: "vagrant plugin install vagrant-libvirt"

    b.vm.provision "Debug", type: "shell", path: "scripts/linux/setup-debug-env.sh", run: "never"

    #b.vm.synced_folder "#{ENV['GOPATH']}/src/github.com/hashicorp/vagrant", "/opt/vagrant/embedded/gems/#{VAGRANT_VERSION}/gems/vagrant-#{VAGRANT_VERSION}"
  end

  (1..3).each do |i|
    config.vm.define "docker-#{i}"  do |docker|
      docker.vm.synced_folder "#{ENV['GOPATH']}/src/github.com/hashicorp/vagrant", "/dev/vagrant"
      #docker.vm.network :public_network, type: "dhcp"
      #docker.vm.network :private_network, ip: "172.20.128.#{i+1}", netmask: "16"
      #docker.vm.network :private_network, type: "dhcp", subnet: "2a02:6b8:b010:9020:1::/80"
      docker.vm.provider "docker" do |d|
        #d.compose = true
        #d.build_args = { "foo" => "bar" }
        #d.build_args = ["foo","bar"]
        #d.image = "ubuntu"
        d.build_dir = "docker"
        #d.git_repo = "https://github.com/briancain/nginx-docker-test.git"
        d.cmd = ["tail", "-f", "/dev/null"]
      end
    end
  end

  config.vm.define "chef" do |chef|
    chef.vm.box = "bento/ubuntu-18.04"
    #chef.vm.box = "windows_10"
    #chef.vm.provider :virtualbox
    chef.vm.provider :vmware_desktop do |v|
      v.gui = false
      v.memory = "10000"
      v.cpus = 4
    end

    chef.vm.provision :chef_solo do |c|
      c.add_recipe "test"
      c.custom_config_path = "chef/CustomConfiguration.chef"
      #c.version = "15.0.293"
      #c.version = "14.12.9"
    end

    chef.vm.provision "shell", inline:<<-SHELL
    chef-solo --version
    knife --version
    SHELL

    #chef.vm.provision :chef_zero do |c|
    #  c.cookbooks_path = "."
    #  c.add_recipe "test"
    #  c.nodes_path = ["~/code/vagrant-sandbox/nodes"]
    #end
  end

  config.vm.define "puppet" do |p|
    #p.vm.box = "bento/ubuntu-18.04"
    p.vm.box = "hashicorp/bionic64"

    p.vm.provision "shell", run: "once", inline: <<-SHELL
    wget https://apt.puppet.com/puppet6-release-bionic.deb
    sudo dpkg -i puppet6-release-bionic.deb
    sudo apt update
    sudo apt-get install puppet-agent tree -y
    SHELL

    p.vm.provision :puppet do |p|
      p.module_path = ['puppet/modules', 'puppet/site']
      p.manifests_path = 'puppet/manifests'
    end

    p.vm.provider :virtualbox

    p.vm.provision "shell", inline: <<-SHELL
      puppet --version
    SHELL
  end

  config.vm.define "centos" do |centos|
    centos.vm.provider :virtualbox
    centos.vm.box = "bento/centos-8"
    #centos.vm.box = "bento/centos-7"
    #centos.vm.synced_folder ".", "/vagrant", type: "nfs"
    #centos.vm.network :private_network, type: "dhcp"
  end

  config.vm.define "fedora" do |f|
    f.vm.box = "bento/fedora-31"
    f.vm.provider :virtualbox
    #f.vm.synced_folder ".", "/vagrant", disabled: true

    f.vm.provider :vmware_desktop do |v|
      v.memory = 8048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    f.vm.provision "KVM", type: "shell", path: "scripts/linux/install-libvirt-fedora.sh"
    f.vm.provision "vagrant-libvirt", type: "shell",
      path: "scripts/linux/vagrant-plugin-install-libvirt.sh",
      args: VAGRANT_VERSION
  end

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "hashicorp/bionic64"
    #ansible.vm.box = "generic/alpine38"
    #ansible.vm.box = "archlinux/archlinux"
    #ansible.vm.box = "bento/debian-10"
    # required for pip install ansible on alpine guest
    #ansible.vm.provision :shell, inline: "apk add build-base libffi-dev python3-dev openssl-dev"
    ansible.vm.provision "ansible_local" do |a|
    #ansible.vm.provision "ansible" do |a|
      a.install_mode = 'pip'
      a.playbook = "ansible/playbook.yml"
    end
    #ansible.vm.box = "generic/freebsd11"
    ansible.vm.synced_folder ".", "/vagrant", disabled: false
    #ansible.vm.network "private_network", ip: "192.168.55.99"
    ansible.vm.provider :virtualbox
  end

  config.vm.define "salt" do |salt|
    salt.vm.box = "bento/ubuntu-18.04"

    salt.vm.provider :virtualbox

    salt.vm.provision :salt do |s|
      s.minion_config = "saltstack/etc/minion"
      s.install_type = "stable"
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

  config.vm.define "arch" do |arch|
    arch.vm.provider :virtualbox
    arch.vm.box = "archlinux/archlinux"
    #arch.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end

  config.vm.define "alpine" do |a|
    a.vm.provider :virtualbox
    a.vm.box = "generic/alpine310"
    a.vm.hostname = "alpine.example.org"

    #a.vm.synced_folder ".", "/vagrant", type: "rsync"
    #a.vm.network "private_network", ip: "192.168.50.10"
    #a.vm.network "private_network", type: "dhcp"

    #a.vm.provision :shell, inline:<<-SHELL
    #SHELL
  end

  config.vm.define "debian" do |d|
    d.vm.box = "bento/debian-10"
    #d.vm.box = "debian/stretch64"
    d.vm.provider :virtualbox
    #d.vm.synced_folder ".", "/vagrant", disabled: true # disabled because stretch64 uses rsync
    #d.vm.network "private_network", ip: "10.10.0.191"
    #d.vm.network "private_network", ip: "192.168.33.99"
  end

  config.vm.define "dockervm" do |d|
    d.vm.box = "bento/ubuntu-18.04"
    d.vm.provider :virtualbox

    d.vm.provision "Install", type: "shell", path: "scripts/linux/install-docker.sh"

    d.vm.provision "Sandbox", type: "file",
      source: "linux-sandbox/Vagrantfile",
      destination: "/home/vagrant/test/Vagrantfile"

    d.vm.provision "Vagrant", type: "shell",
      path: "scripts/linux/install-vagrant.sh",
      args: VAGRANT_VERSION

    #d.vm.synced_folder "#{ENV['GOPATH']}/src/github.com/hashicorp/vagrant", "/opt/vagrant/embedded/gems/#{VAGRANT_VERSION}/gems/vagrant-#{VAGRANT_VERSION}"

    d.vm.provision "Debug", type: "shell", path: "scripts/linux/setup-debug-env.sh", run: "never"

    d.vm.provision "docker" do |d|
      d.run "ubuntu",
        cmd: "tail -f /dev/null",
        args: "-p 8080:80"
    end
  end

  # Update /etc/pkg/FreeBSD.conf to be latest instead of quarterly
  # sudo pkg update
  # sudo pkg upgrade
  # then
  # sudo pkg install virtualbox-ose-additions
  # sudo pkg install virtualbox-ose-kmod  https://forums.freebsd.org/threads/new-freebsd-user-virtualbox-shared-folders.66278/
  #
  # edit /boot/loader.conf with:
  #   vboxvfs_load="YES"
  # reboot
  #
  # mount!!!
  #
  config.vm.define "freebsd" do |f|
    f.vm.box = "bento/freebsd-11"
    #f.vm.box = "freebsd/FreeBSD-12.0-RELEASE"
    f.vm.provider :virtualbox
    #f.vm.synced_folder ".", "/vagrant", disabled: false
    #f.vm.provider :vmware_desktop do |v|
    #  v.memory = 8048
    #  v.cpus = 2
    #  v.vmx['vhv.enable'] = 'TRUE'
    #  v.vmx['vhv.allow'] = 'TRUE'
    #end
  end

  # Need `vagrant-ignition` plugin to work
  config.vm.define "coreos" do |c|
    update_channel = "alpha"
    c.vm.box = "coreos-#{update_channel}"
    c.vm.box_url = "https://#{update_channel}.release.core-os.net/amd64-usr/current/coreos_production_vagrant_virtualbox.json"
    c.vm.provider :virtualbox
    c.vm.network :private_network, type: "dhcp"
    c.ssh.insert_key = false
    c.ssh.forward_agent = true
    c.vm.hostname = "coreos.#{update_channel}.local"
    #c.ignition.enabled = true
  end

  config.vm.define "opensuse" do |o|
    #o.vm.box = "bento/opensuse-leap-15"
    #o.vm.box = "generic/opensuse15" # vmware
    #o.vm.box = "bento/opensuse-leap-42"
    #o.vm.box = "opensuse/openSUSE-Tumbleweed-Vagrant.x86_64"
    o.vm.provider :virtualbox
    o.vm.hostname = "opensuse.local"
    o.vm.synced_folder ".", "/vagrant", disabled: true
    o.vm.provision "shell", inline: "hostname -f"
    #o.vm.synced_folder ".", "/vagrant", type: "nfs"
    #o.vm.network :private_network, type: :dhcp
    #o.vm.network :private_network, ip: "fde4:8dba:82e1::c4"
  end

  config.vm.define "windows" do |windows|
    #windows.vm.box = "StefanScherer/windows_2016"
    windows.vm.box = "StefanScherer/windows_10"

    #windows.winrm.username = 'vagrant\vagrant'

    windows.vm.provision "Info", type: "shell", path: "scripts/windows/info.ps1"
    windows.vm.provision "Setup", type: "shell", reboot: true, path: "scripts/windows/setup.ps1"

    windows.vm.provider :vmware_desktop do |v|
      v.gui = true
      v.memory = "15000"
      v.cpus = 4
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
      v.vmx["hypervisor.cpuid.0"] = "FALSE"
    end

    #windows.vm.provision :puppet do |p|
    #  p.module_path = ['modules', 'site']
    #end

    windows.vm.provision "file",
      source: "windows-sandbox/Vagrantfile",
      destination: "/Users/vagrant/test/Vagrantfile"

    # run me with the `provision` command
    windows.vm.provision "shell", path: "scripts/windows/admin.ps1", run: "never"

    windows.vm.provision "SSH", type: "shell", privileged: true, reboot: true,
      path: "scripts/windows/setupssh.ps1", run: "never"

    #windows.vm.synced_folder "#{ENV['GOPATH']}/src/github.com/hashicorp/vagrant", "/hashicorp/vagrant/embedded/gems/#{VAGRANT_VERSION}/gems/vagrant-#{VAGRANT_VERSION}"
  end

  config.vm.define "windows-hyperv" do |windows|
    windows.vm.box = "StefanScherer/windows_10" # hyper-v

    #windows.vm.communicator = :winssh
    #windows.ssh.username = "vagrant"
    #windows.ssh.password = "vagrant"
    #windows.winssh.shell = "powershell"

    windows.vm.provision "Info", type: "shell", path: "scripts/windows/info.ps1"
    windows.vm.provision "Setup", type: "shell", reboot: true, path: "scripts/windows/setuphyperv.ps1"

    windows.vm.provider :vmware_desktop do |v|
      v.gui = true
      v.memory = "15000"
      v.cpus = 4
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
      v.vmx["hypervisor.cpuid.0"] = "FALSE"
    end

    windows.vm.provision "file",
      source: "windows-sandbox/Vagrantfile",
      destination: "/Users/vagrant/test/Vagrantfile"

    windows.vm.provision "SSH", type: "shell", privileged: true, reboot: true,
      path: "scripts/windows/setupssh.ps1", run: "never"

    #windows.vm.synced_folder "#{ENV['GOPATH']}/src/github.com/hashicorp/vagrant", "/hashicorp/vagrant/embedded/gems/#{VAGRANT_VERSION}/gems/vagrant-#{VAGRANT_VERSION}"
  end
end
