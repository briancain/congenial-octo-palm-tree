$vagrantversion=$args[0]
$vagrantdevversion=$args[1]

Write-Host "Vagrant version arg: $vagrantversion"

Copy-Item /Users/vagrant/vagrantdir/vagrant-$vagrantdevversion.dev.gem -Destination /Users/vagrant/Desktop

cd /Users/vagrant/Desktop
Remove-Item vagrant-$vagrantdevversion.dev -Recurse -Force

/hashicorp/vagrant/embedded/mingw64/bin/gem.cmd unpack vagrant-$vagrantdevversion.dev.gem

Remove-Item /hashicorp/vagrant/embedded/gems/$vagrantversion/gems/vagrant-$vagrantversion -Recurse -Force -EA SilentlyContinue
Copy-Item  /Users/vagrant/Desktop/vagrant-$vagrantdevversion.dev -Destination /hashicorp/vagrant/embedded/gems/$vagrantversion/gems/vagrant-$vagrantversion -Recurse
