# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  #config.vm.box = "ubuntu/trusty64"
  #config.vm.provider "docker" do |d|
  #  d.image = "default"
  #end
  #config.vm.box = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  #config.vm.box = "iamseth/rhel-7.3"
  #config.vm.provision "mah docker", type: "docker"  do |d|
  #  #d.post_install_provision "shell", inline:"echo export http_proxy='http://1.2.3.4' >> /etc/default/docker"
  #  d.run "redhat",
  #    cmd: "bash -l",
  #    args: "-v '/vagrant:/var/www'"
  #end

  #config.vm.provider "docker" do |d|
  #  d.build_dir = "."
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

  config.vm.define "virtualbox" do |vbox|
    #vbox.vm.box = "ubuntu/trusty64"
    vbox.vm.box = "ubuntu/xenial64"
    vbox.vm.network "private_network", type: "dhcp"
    vbox.vm.provider :virtualbox

    vbox.vm.synced_folder ".", "/vagrant", type: "nfs"
    vbox.vm.provision "my file", type: "shell", inline: <<-SHELL
      echo 'hello' > hello.txt
    SHELL
  end

end
