# Vagrant Sandbox

A repo for developing core Vagrant.

## Usage

__Note__: Comment out the plugin block in the `Gemfile` if you are not developing
the vmware plugin from source.

```
rvm use @vagrant --create
bundle install
bundle exec vagrant <commands>
```
