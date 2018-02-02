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
    b.vm.provider :vmware_fusion do |v|
      v.memory = 8048
      v.cpus = 2
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    b.vm.provision "shell", inline: <<-SHELL
    echo hello
    SHELL

    #b.vm.network "forwarded_port", guest: 8080, host: 8080
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
    #chef.vm.box = "spox/windows-10"
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

    #windows.vm.provider :virtualbox
    windows.vm.provider :vmware_fusion do |v|
      v.vmx['vhv.enable'] = 'TRUE'
      v.vmx['vhv.allow'] = 'TRUE'
    end

    #windows.vm.synced_folder "../vagrant",
    #  "/hashicorp/vagrant/embedded/gems/gems/vagrant-2.0.1"
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

  config.vm.define "debian" do |d|
    #d.vm.box = "debian/jessie64"
    d.vm.box = "bento/debian-8.2"
    #d.vm.box = "debian93"
    d.vm.provider :virtualbox
    #d.vm.provision "shell", inline: <<-SHELL
    #sudo systemctl enable systemd-networkd.service
    #sudo systemctl start systemd-networkd.service
    #echo $?
    #sudo systemctl status systemd-networkd.service
    #SHELL
    d.vm.network :private_network, ip: "192.168.33.10"
  end

  config.vm.define "ubuntu17" do |u|
    u.vm.box = "bento/ubuntu-17.10"
    u.vm.provider :virtualbox
    u.vm.network :private_network, ip: "192.168.33.10"
    u.vm.network "private_network", ip: "fde4:8dba:82e1::c4"
  end
end
