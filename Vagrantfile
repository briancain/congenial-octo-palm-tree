# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.trigger.before :up, :destroy, :status, type: "command" do |t|
    t.info = "magic"
  end

  config.trigger.before :up, type: :command do |t|
    t.info = "hello"
    t.run = {inline: "/bin/bash -c 'echo \"secret feature!!!\"'"}
  end

  config.trigger.after :up, type: :command do |t|
    t.run = {inline: "echo 'we are done with the up'"}
  end

  config.trigger.before :"Vagrant::Action::Builtin::ConfigValidate", type: :action do |t|
    t.info = "Magic trigger before validating configs!!"
  end

  config.trigger.before :provisioner_run, type: :action do |t|
    t.info = "Provision stuff!!!"
  end

  config.trigger.after :provisioner_run, type: :action do |t|
    t.info = "It's over"
  end

  config.trigger.before :up, info: "Classic"
  config.trigger.before :status, type: :command, info: "NEW"

  config.vm.define "bork" do |b|
    b.vm.box = "bento/ubuntu-18.04"
    b.vm.provision "Sandbox", type: "file",
      source: "linux-sandbox/Vagrantfile",
      destination: "/home/vagrant/test/Vagrantfile"

    # Start a web server locally to serve up box
    #b.vm.box = "hashicorp/precise64_custom"
    #b.vm.box_url = "http://localhost:8000/box.json"

    #b.vm.network :private_network, type: :dhcp

    #b.vm.provision "shell", inline:<<-SHELL
    #SHELL

    #b.vm.synced_folder "scripts", "/vagrant"
    #b.vm.synced_folder "scripts", "/vagrant", type: "rsync"
    #  rsync__args: ["-avz", "--copy-links"]

    b.vm.provider :virtualbox do |v|
      #v.linked_clone = true
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

    b.vm.provision "file",
      source: "linux-sandbox/Vagrantfile",
      destination: "/home/vagrant/test/Vagrantfile"

    virtualbox_version = "6.0"
    b.vm.provision "VirtualBox", type: "shell",
      path: "scripts/linux/install-vbox.sh",
      args: virtualbox_version

    version = "2.2.3"
    b.vm.provision "Vagrant", type: "shell",
      path: "scripts/linux/install-vagrant.sh",
      args: version

    b.vm.provision "Debug", type: "shell", path: "scripts/linux/setup-debug-env.sh", run: "never"

    #b.vm.synced_folder "../vagrant", "/opt/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"
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
      a.playbook = "ansible/playbook.yml"
    end
    ansible.vm.provider :virtualbox
  end

  config.vm.define "salt" do |salt|
    salt.vm.box = "bento/ubuntu-18.04"
    #salt.vm.box = "windows_10"

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

  config.vm.define "windows" do |windows|
    windows.vm.box = "windows_2016"
    #windows.vm.box = "windows_10" # hyper-v
    #windows.vm.box = "windows_2019"

    windows.vm.provision "Info", type: "shell", path: "scripts/windows/info.ps1"
    windows.vm.provision "Setup", type: "shell", path: "scripts/windows/setup.ps1"

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

    windows.trigger.after :destroy do |trigger|
      trigger.warn = "MAKE SURE TO COMMENT OUT SYNCED FOLDER"
    end

    windows.vm.provision "file",
      source: "windows-sandbox/Vagrantfile",
      destination: "/Users/vagrant/test/Vagrantfile"

    # run me with the `provision` command
    windows.vm.provision "shell", path: "scripts/windows/admin.ps1", run: "never"

    version = "2.2.3"
    #windows.vm.synced_folder "../vagrant", "/hashicorp/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"
  end

  config.vm.define "windows-hyperv" do |windows|
    windows.vm.box = "windows_10" # hyper-v

    windows.vm.provision "Info", type: "shell", path: "scripts/windows/info.ps1"
    windows.vm.provision "Setup", type: "shell", path: "scripts/windows/setuphyperv.ps1"

    windows.vm.provider :vmware_desktop do |v|
      v.gui = true
      v.memory = "10000"
      v.cpus = 4
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
      v.vmx["hypervisor.cpuid.0"] = "FALSE"
    end

    windows.vm.provision "file",
      source: "windows-sandbox/Vagrantfile",
      destination: "/Users/vagrant/test/Vagrantfile"

    windows.trigger.after :destroy do |trigger|
      trigger.warn = "MAKE SURE TO COMMENT OUT SYNCED FOLDER"
    end

    version = "2.2.3"
    #windows.vm.synced_folder "../vagrant", "/hashicorp/vagrant/embedded/gems/#{version}/gems/vagrant-#{version}"
  end

  config.vm.define "macos" do |m|
    # only works on macOS
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

  config.vm.define "rhel" do |r|
    #r.vm.box = "generic/rhel8"
    r.vm.box = "roboxes/rhel8"
    r.vm.hostname = "redhat"
    r.vm.provider :virtualbox
  end

  config.vm.define "arch" do |arch|
    arch.vm.provider :virtualbox
    arch.vm.box = "generic/arch"

    arch.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  end

  config.vm.define "debian" do |d|
    #d.vm.box = "bento/debian-9.4"
    d.vm.box = "debian/stretch64"
    d.vm.provider :virtualbox
    d.vm.synced_folder ".", "/vagrant", disabled: true # disabled because stretch64 uses rsync
    #d.vm.network "private_network", ip: "10.10.0.191"
    #d.vm.network "private_network", ip: "192.168.33.99"
  end

  config.vm.define "dockervm" do |d|
    d.vm.box = "bento/ubuntu-18.04"
    d.vm.provider :virtualbox

    d.vm.provision "Install", type: "shell", path: "scripts/linux/install-docker.sh"

    d.vm.provision "docker" do |d|
      d.run "ubuntu",
        cmd: "bash -l",
        args: "-p 8000:80"
    end
  end

  config.vm.define "freebsd" do |f|
    f.vm.box = "generic/freebsd11"
    f.vm.provider :virtualbox
  end
end
