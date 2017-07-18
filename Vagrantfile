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

  config.vm.define "docker"  do |vm|
    vm.vm.provider "docker" do |d|
      d.image = "ubuntu"
      #d.build_dir = "."
      d.cmd = ["tail", "-f", "/dev/null"]
    end
  end

  #config.vm.define "docker2"  do |vm|
  #  vm.vm.provider "docker" do |d|
  #    d.build_dir = "."
  #    d.force_host_vm = true
  #  end
  #  vm.vm.synced_folder ".", "/vagrant", type: "rsync",
  #    rsync__exclude: ".git/"
  #end


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

  #config.vm.define "chef" do |chef|
  #  chef.vm.box = "ubuntu/trusty64"
  #  chef.vm.provider :virtualbox

  #  chef.vm.provision :chef_solo do |c|
  #    c.add_recipe "test"
  #    c.recipe_url="http://localghost.domain:8000/test.tar.gz"
  #  end
  #end

  #config.ssh.private_key_path = "/Users/brian/code/vagrant-sandbox/foo%bar/id_rsa"

  config.vm.define "virtualbox" do |vbox|
    #vbox.vm.box = "ubuntu/trusty64"
    vbox.vm.box = "ubuntu/xenial64"
    vbox.vm.network "private_network", type: "dhcp"
    #vbox.vm.synced_folder ".", "/vagrant", type: "nfs"
    #vbox.vm.synced_folder ".", "/vagrant", type: "rsync",
    #  rsync__exclude: ".git/"
    vbox.vm.provider :virtualbox

    vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
      echo 'hello' > hello.txt
    SHELL
  end

  config.vm.define "virtualbox-nfs" do |vbox|
    #vbox.vm.box = "ubuntu/trusty64"
    #vbox.vm.box = "ubuntu/xenial64"
    #vbox.vm.box = "centos/7"
    vbox.vm.box = "debian/jessie64"
    vbox.vm.network "private_network", type: "dhcp"
    vbox.vm.network :private_network, ip: "10.0.8.178"
    vbox.vm.network :forwarded_port, guest: 80, host: 8080
    vbox.vm.network :forwarded_port, guest: 35729, host: 35729
    vbox.ssh.forward_agent = true
    vbox.vm.synced_folder ".", "/vagrant", mount_options: ['rw', 'vers=3', 'fsc' ,'actimeo=2', 'async'], nfs: true,
      rsync__exclude: ".git/"
    vbox.vm.provider :virtualbox

    vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
      echo 'hello' > hello.txt
    SHELL

    vbox.vm.provision "ansible" do |a|
      a.playbook = "playbook.yml"
    end
  end

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "ubuntu/xenial64"
    ansible.vm.provision "ansible" do |a|
      a.playbook = "playbook.yml"
    end
  end

end
