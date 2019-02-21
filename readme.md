# Vagrant Sandbox

A repo for developing core Vagrant.

## Usage

Make sure you have cloned [Vagrant](https://github.com/hashicorp/vagrant) some
where on your computer. Then make sure to update the path in this projects `Gemfile`
for where Vagrant lives.

__Note__: Comment out the plugin block in the `Gemfile` if you are not developing
the vmware plugin from source.

```
rvm use @vagrant --create
bundle install
bundle exec vagrant <commands>
```
